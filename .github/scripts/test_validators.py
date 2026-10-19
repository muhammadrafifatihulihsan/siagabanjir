"""Regresi gate publikasi; fixture sementara tidak menyentuh sumber proyek.

Jalankan: python -B -X utf8 -m unittest discover -s .github/scripts -p 'test_*.py'
Pemeliharaan mengikuti rules/documentation.md.
"""

import copy
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import validate_contracts as contracts
import validate_links as links
import validate_skills as skills

ROOT = Path(__file__).resolve().parents[2]


class LinksTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        for name in ('AGENTS.md', 'README.md', 'SKILL.md'):
            (self.root / name).write_text('# Test\n', encoding='utf-8')
        for name in ('docs', 'rules', 'skills'):
            (self.root / name).mkdir()
        self.root_patch = patch.object(links, 'ROOT', self.root)
        self.root_patch.start()
        self.addCleanup(self.root_patch.stop)

    def test_correct_root_is_independent_of_current_directory(self):
        result = subprocess.run(
            [sys.executable, '-B', '-X', 'utf8', str(ROOT / '.github/scripts/validate_links.py')],
            cwd=self.root, capture_output=True, text=True, encoding='utf-8',
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_incomplete_root_fails_instead_of_empty_success(self):
        (self.root / 'AGENTS.md').unlink()
        self.assertTrue(links.validate())

    def test_nested_relative_link_and_anchor(self):
        (self.root / 'docs/guide.md').write_text(
            '[Root](../README.md#test)\n', encoding='utf-8',
        )
        self.assertEqual(links.validate(), [])

    def test_missing_file_and_anchor_are_reported(self):
        (self.root / 'README.md').write_text(
            '[Missing](missing.md)\n[Anchor](AGENTS.md#missing)\n', encoding='utf-8',
        )
        self.assertEqual(len(links.validate()), 2)

    def test_wrong_case_fails_on_windows_and_linux(self):
        (self.root / 'README.md').write_text('[Case](agents.md)\n', encoding='utf-8')
        self.assertTrue(links.validate())

    def test_private_archive_is_not_a_source_to_scan(self):
        archive = self.root / 'archive'
        archive.mkdir()
        (archive / 'private.md').write_text('[Broken](missing.md)\n', encoding='utf-8')
        self.assertEqual(links.validate(), [])

    def test_session_exports_are_excluded_but_active_handoff_is_checked(self):
        for name in ('codex-session-root.md', 'docs/codex-session-nested.md'):
            (self.root / name).write_text('[Broken](missing.md)\n', encoding='utf-8')
        self.assertEqual(links.validate(), [])
        handoff = self.root / 'docs/SESSION-HANDOFF.md'
        handoff.write_text('[Broken](missing.md)\n', encoding='utf-8')
        errors = links.validate()
        self.assertEqual(len(errors), 1)
        self.assertIn('SESSION-HANDOFF.md', errors[0])


class SkillsTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.skill_dir = Path(self.temp.name) / 'siagabanjir-workspace'
        self.skill_dir.mkdir()
        self.source = (ROOT / 'skills/siagabanjir-workspace/SKILL.md').read_text(encoding='utf-8')

    def check_source(self, source):
        (self.skill_dir / 'SKILL.md').write_text(source, encoding='utf-8')
        return skills.validate_skill(self.skill_dir)

    def test_valid_skill(self):
        self.assertEqual(self.check_source(self.source), [])

    def test_malformed_yaml_is_rejected(self):
        self.assertTrue(self.check_source(self.source.replace(
            'name: siagabanjir-workspace', 'name: [unterminated',
        )))

    def test_empty_nonstring_duplicate_and_wrong_name_are_rejected(self):
        for replacement in ('name:', 'name: 123', 'name: other-skill', 'name: a\nname: siagabanjir-workspace'):
            with self.subTest(replacement=replacement):
                self.assertTrue(self.check_source(self.source.replace(
                    'name: siagabanjir-workspace', replacement,
                )))

    def test_missing_description_and_reference_are_rejected(self):
        for source in (
            '\n'.join(line for line in self.source.splitlines() if not line.startswith('description:')),
            self.source.replace('workflow.md#baca-lengkap', 'workflow.md'),
        ):
            with self.subTest(source=source[:80]):
                self.assertTrue(self.check_source(source))

    def test_incomplete_root_and_missing_catalog_fail(self):
        with patch.object(skills, 'ROOT', Path(self.temp.name)):
            self.assertTrue(skills.validate())
            self.assertTrue(skills.validate_catalog())


class ContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.api = json.loads((ROOT / 'docs/openapi.json').read_text(encoding='utf-8'))
        cls.examples = json.loads((ROOT / 'docs/examples.json').read_text(encoding='utf-8'))

    def test_checked_in_contract_and_examples(self):
        self.assertEqual(contracts.validate(self.api, self.examples), [])

    def test_missing_format_dependencies_cannot_pass(self):
        with patch.dict(contracts.FormatChecker.checkers, {}, clear=True):
            self.assertTrue(contracts.validate(self.api, self.examples))

    def test_date_and_uri_formats_are_enforced(self):
        for fmt, valid, invalid in (
            ('date-time', '2026-10-19T01:00:00Z', '2026-99-99T01:00:00Z'),
            ('uri', 'https://example.test/path', 'https://example.test/space path'),
        ):
            with self.subTest(format=fmt):
                checker = contracts.validator(self.api, {'type': 'string', 'format': fmt})
                self.assertTrue(checker.is_valid(valid))
                self.assertFalse(checker.is_valid(invalid))

    def test_broken_reference_is_rejected(self):
        api = copy.deepcopy(self.api)
        api['components']['schemas']['Signup'] = {'$ref': '#/components/schemas/Missing'}
        self.assertTrue(contracts.validate(api, self.examples))

    def test_example_expectation_is_actually_checked(self):
        examples = copy.deepcopy(self.examples)
        examples[0]['expectedValid'] = not examples[0]['expectedValid']
        self.assertTrue(contracts.validate(self.api, examples))

    def test_signup_secret_replay_is_rejected(self):
        api = copy.deepcopy(self.api)
        responses = api['paths']['/auth/signup']['post']['responses']
        responses['200'] = responses['201']
        self.assertTrue(contracts.validate(api, self.examples))

    def test_all_secret_operations_require_safe_conflict(self):
        for path in contracts.SECRET_OPERATIONS:
            with self.subTest(path=path):
                api = copy.deepcopy(self.api)
                del api['paths'][path]['post']['responses']['409']
                self.assertTrue(contracts.validate(api, self.examples))

    def test_conflict_cannot_include_recovery_code(self):
        api = copy.deepcopy(self.api)
        media = api['components']['responses']['SecretReplayConflict']['content']['application/json']
        media['example']['recoveryCode'] = 'A' * 32
        self.assertTrue(contracts.validate(api, self.examples))

    def test_quota_reset_requires_account_id_only_for_account_scope(self):
        checker = contracts.validator(
            self.api, {'$ref': '#/components/schemas/QuotaReset'},
        )
        account_id = '10000000-0000-4000-8000-000000000001'
        cases = (
            ({'scope': 'ALL'}, True),
            ({'scope': 'ALL', 'accountId': account_id}, False),
            ({'scope': 'ACCOUNT'}, False),
            ({'scope': 'ACCOUNT', 'accountId': account_id}, True),
            ({'scope': 'ACCOUNT', 'accountId': 'invalid'}, False),
            ({'scope': 'UNKNOWN', 'accountId': account_id}, False),
        )
        for payload, expected in cases:
            with self.subTest(payload=payload):
                self.assertEqual(checker.is_valid(payload), expected)


if __name__ == '__main__':
    unittest.main()
