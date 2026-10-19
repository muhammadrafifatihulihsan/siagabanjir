"""Regression coverage for release-note selection before GitHub publication."""

import unittest

from release_notes import notes_for_tag


class ReleaseNotesTests(unittest.TestCase):
    def test_selects_exact_version_without_adjacent_entries(self):
        changelog = (
            '## [Unreleased]\nBelum dirilis.\n\n'
            '## [0.1.0] - 2026-10-19\n\nBaseline dokumentasi.\n'
            '### Ditambahkan\n- Kontrak API.\n\n'
            '## [0.0.1] - 2026-10-18\nVersi lama.\n'
        )
        self.assertEqual(
            notes_for_tag(changelog, 'v0.1.0'),
            'Baseline dokumentasi.\n### Ditambahkan\n- Kontrak API.\n'
        )

    def test_missing_and_duplicate_versions_fail(self):
        entry = '## [0.1.0] - 2026-10-19\nBaseline.\n'
        for changelog in ['', '## [Unreleased]\nBelum dirilis.\n', entry + entry]:
            with self.subTest(changelog=changelog), self.assertRaises(ValueError):
                notes_for_tag(changelog, 'v0.1.0')

    def test_empty_entry_cannot_publish_adjacent_notes(self):
        for empty in ['\n', '\n### Ditambahkan\n']:
            changelog = '## [0.1.0] - 2026-10-19\n' + empty + '## [0.0.1] - 2026-10-18\nLama.\n'
            with self.subTest(empty=empty), self.assertRaises(ValueError):
                notes_for_tag(changelog, 'v0.1.0')

    def test_invalid_tag_is_rejected(self):
        for tag in ['main', '0.1.0', 'v01.0.0', 'v0.1.0-extra', 'v0.1.0\n']:
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                notes_for_tag('## [0.1.0] - 2026-10-19\nBaseline.\n', tag)


if __name__ == '__main__':
    unittest.main()
