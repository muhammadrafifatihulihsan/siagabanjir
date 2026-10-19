"""Validasi YAML frontmatter dan struktur delapan SKILL.md SiagaBanjir.

Memeriksa bahwa setiap SKILL.md memiliki YAML frontmatter yang valid dengan
field name dan description, serta merujuk ke protokol baca lengkap dan
matriks dokumentasi.
Dijalankan lokal/CI: python -B -X utf8 .github/scripts/validate_skills.py
"""

from pathlib import Path
import re
import sys

import yaml

ROOT = Path(__file__).resolve().parents[2]
SKILLS_DIR = ROOT / 'skills'

EXPECTED_SKILLS = [
    'siagabanjir-backend',
    'siagabanjir-debug',
    'siagabanjir-flutter',
    'siagabanjir-requirements',
    'siagabanjir-review',
    'siagabanjir-ui',
    'siagabanjir-verification',
    'siagabanjir-workspace',
]

# YAML frontmatter pattern
YAML_PATTERN = re.compile(
    r'^---\s*\n(.*?)\n---\s*\n',
    re.DOTALL
)

REQUIRED_YAML_FIELDS = ['name', 'description']

REQUIRED_REFERENCES = [
    'workflow.md#baca-lengkap',
    'documentation.md',
]


class UniqueKeyLoader(yaml.SafeLoader):
    """Tolak key ganda agar metadata tidak ditimpa diam-diam."""


def unique_mapping(loader, node):
    mapping = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node)
        if not isinstance(key, str) or key in mapping:
            raise yaml.constructor.ConstructorError(
                None, None, 'key harus string unik', key_node.start_mark,
            )
        mapping[key] = loader.construct_object(value_node)
    return mapping


UniqueKeyLoader.add_constructor(
    yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, unique_mapping,
)


def validate_skill(skill_dir: Path) -> list[str]:
    """Validasi satu SKILL.md. Return daftar error."""
    errors = []
    skill_md = skill_dir / 'SKILL.md'

    if not skill_md.exists():
        errors.append(f'{skill_dir.name}: SKILL.md tidak ditemukan')
        return errors

    content = skill_md.read_text(encoding='utf-8')

    # Cek YAML frontmatter
    yaml_match = YAML_PATTERN.match(content)
    if not yaml_match:
        errors.append(f'{skill_dir.name}: YAML frontmatter tidak ditemukan')
        return errors

    yaml_text = yaml_match.group(1)

    try:
        metadata = yaml.load(yaml_text, Loader=UniqueKeyLoader)
    except yaml.YAMLError as exc:
        return [f'{skill_dir.name}: YAML tidak valid: {exc}']
    if not isinstance(metadata, dict):
        return [f'{skill_dir.name}: frontmatter harus mapping YAML']
    for field in REQUIRED_YAML_FIELDS:
        value = metadata.get(field)
        if not isinstance(value, str) or not value.strip():
            errors.append(f'{skill_dir.name}: "{field}" harus string tidak kosong')
    name = metadata.get('name')
    if isinstance(name, str):
        if (
            name != skill_dir.name or len(name) > 64
            or not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', name)
        ):
            errors.append(f'{skill_dir.name}: name tidak cocok dengan nama folder')
    description = metadata.get('description')
    if isinstance(description, str) and (
        len(description) > 1024 or '<' in description or '>' in description
    ):
        errors.append(f'{skill_dir.name}: description melampaui batas metadata')

    # Cek referensi wajib
    for ref in REQUIRED_REFERENCES:
        if ref not in content:
            errors.append(
                f'{skill_dir.name}: referensi ke "{ref}" tidak ditemukan'
            )

    # Cek living document marker
    if 'Living document' not in content:
        errors.append(f'{skill_dir.name}: penanda living document tidak ada')

    # Cek panjang minimal (skill terlalu pendek mungkin kosong)
    lines = content.strip().splitlines()
    if len(lines) < 15:
        errors.append(
            f'{skill_dir.name}: hanya {len(lines)} baris — mungkin tidak lengkap'
        )

    return errors


def validate_catalog() -> list[str]:
    """Validasi katalog SKILL.md di root."""
    errors = []
    catalog = ROOT / 'SKILL.md'

    if not catalog.exists():
        errors.append('SKILL.md (katalog) tidak ditemukan di root')
        return errors

    content = catalog.read_text(encoding='utf-8')
    for skill_name in EXPECTED_SKILLS:
        if skill_name not in content:
            errors.append(
                f'Katalog SKILL.md: skill "{skill_name}" tidak terdaftar'
            )

    return errors


def validate() -> list[str]:
    all_errors = []
    for name in ('AGENTS.md', 'README.md', 'SKILL.md', 'docs', 'rules', 'skills'):
        if not (ROOT / name).exists():
            all_errors.append(f'Akar workspace tidak lengkap: {name} tidak ditemukan')
    if all_errors:
        return all_errors

    # Cek jumlah skill
    found_dirs = sorted(d.name for d in SKILLS_DIR.iterdir() if d.is_dir())
    if set(found_dirs) != set(EXPECTED_SKILLS):
        missing = set(EXPECTED_SKILLS) - set(found_dirs)
        extra = set(found_dirs) - set(EXPECTED_SKILLS)
        if missing:
            all_errors.append(f'Skill hilang: {", ".join(sorted(missing))}')
        if extra:
            all_errors.append(f'Skill tambahan: {", ".join(sorted(extra))}')

    # Validasi setiap skill
    for skill_name in EXPECTED_SKILLS:
        skill_dir = SKILLS_DIR / skill_name
        if skill_dir.exists():
            all_errors.extend(validate_skill(skill_dir))

    # Validasi katalog
    all_errors.extend(validate_catalog())
    return all_errors


def main():
    print('Validasi YAML skill dan struktur...')
    all_errors = validate()

    if all_errors:
        print(f'\n❌ Ditemukan {len(all_errors)} masalah:\n')
        for e in all_errors:
            print(f'  {e}')
        sys.exit(1)
    else:
        print(f'✅ Seluruh {len(EXPECTED_SKILLS)} skill valid.')
        sys.exit(0)


if __name__ == '__main__':
    main()
