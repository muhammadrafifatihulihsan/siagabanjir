"""Validasi link internal pada seluruh Markdown aktif di workspace SiagaBanjir.

Memeriksa bahwa setiap tautan relatif [teks](path) dan [teks](path#anchor)
menunjuk ke file yang ada serta anchor yang terdefinisi.
Dijalankan lokal/CI: python -B -X utf8 .github/scripts/validate_links.py
"""

from pathlib import Path
import re
import sys
import urllib.parse

ROOT = Path(__file__).resolve().parents[2]

# Pola Markdown link: [text](target)
LINK_PATTERN = re.compile(r'\[(?:[^\[\]]*)\]\(([^)]+)\)')

# Pola anchor HTML: <a id="..."></a> atau heading # ...
ANCHOR_ID = re.compile(r'<a\s+id="([^"]+)"', re.I)
HEADING_PATTERN = re.compile(r'^#{1,6}\s+(.+)$', re.M)

# Folder/file yang di-skip
SKIP_DIRS = {
    '.git', 'node_modules', '.dart_tool', 'build', 'dist',
    '.venv', '__pycache__', '.local', 'archive', '.cache',
}


def slugify(heading_text: str) -> str:
    """Konversi heading ke GitHub-style anchor slug."""
    text = re.sub(r'[^\w\s-]', '', heading_text.lower())
    text = re.sub(r'[\s]+', '-', text.strip())
    return text


def collect_markdown_files() -> list[Path]:
    """Kumpulkan semua file .md aktif, skip folder yang tidak relevan."""
    files = []
    for md in ROOT.rglob('*.md'):
        parts = md.relative_to(ROOT).parts
        if any(d in SKIP_DIRS for d in parts):
            continue
        files.append(md)
    return sorted(files)


def extract_anchors(content: str) -> set[str]:
    """Ekstrak semua anchor ID dari konten Markdown."""
    anchors = set()
    # HTML anchors
    for m in ANCHOR_ID.finditer(content):
        anchors.add(m.group(1))
    # Heading slugs
    for m in HEADING_PATTERN.finditer(content):
        anchors.add(slugify(m.group(1)))
    return anchors


def validate() -> list[str]:
    """Validasi semua link internal. Return daftar error."""
    errors = []
    for name in ('AGENTS.md', 'README.md', 'SKILL.md', 'docs', 'rules', 'skills'):
        if not (ROOT / name).exists():
            errors.append(f'Akar workspace tidak lengkap: {name} tidak ditemukan')
    if errors:
        return errors
    md_files = collect_markdown_files()

    # Cache anchor per file
    anchor_cache: dict[Path, set[str]] = {}
    for md in md_files:
        content = md.read_text(encoding='utf-8')
        anchor_cache[md] = extract_anchors(content)

    for md in md_files:
        content = md.read_text(encoding='utf-8')
        rel_path = md.relative_to(ROOT)

        for line_no, line in enumerate(content.splitlines(), 1):
            for match in LINK_PATTERN.finditer(line):
                target = match.group(1).strip()

                # Skip URL eksternal, mailto, dan data URI
                if target.startswith((
                    'http://', 'https://', 'mailto:', 'data:', '#', 'file://',
                )):
                    # Untuk fragment-only link (#anchor), cek di file sendiri
                    if target.startswith('#'):
                        anchor = target[1:]
                        if anchor and anchor not in anchor_cache.get(md, set()):
                            errors.append(
                                f'{rel_path}:{line_no}: anchor #{anchor} '
                                f'tidak ditemukan di file sendiri'
                            )
                    continue

                # Parse path dan fragment
                decoded = urllib.parse.unquote(target)
                if '#' in decoded:
                    path_part, fragment = decoded.rsplit('#', 1)
                else:
                    path_part, fragment = decoded, None

                if not path_part:
                    continue

                # Resolve path relatif dari lokasi file sumber
                target_path = (md.parent / path_part).resolve()

                if not target_path.is_relative_to(ROOT):
                    errors.append(f'{rel_path}:{line_no}: target di luar workspace')
                    continue

                # Cek file/dir ada
                if not target_path.exists():
                    errors.append(
                        f'{rel_path}:{line_no}: target "{path_part}" '
                        f'tidak ditemukan'
                    )
                    continue

                # Windows juga harus mendeteksi case yang akan gagal di Linux.
                current = md.parent
                for part in Path(path_part).parts:
                    if part == '..':
                        current = current.parent
                        continue
                    if part == '.':
                        continue
                    if part not in {child.name for child in current.iterdir()}:
                        errors.append(
                            f'{rel_path}:{line_no}: kapitalisasi target '
                            f'"{path_part}" tidak sesuai'
                        )
                        break
                    current /= part

                # Cek anchor jika ada
                if fragment and target_path.is_file() and target_path.suffix == '.md':
                    if target_path not in anchor_cache:
                        try:
                            tc = target_path.read_text(encoding='utf-8')
                            anchor_cache[target_path] = extract_anchors(tc)
                        except (OSError, UnicodeError) as exc:
                            errors.append(f'{rel_path}:{line_no}: {exc}')
                            continue
                    if fragment not in anchor_cache.get(target_path, set()):
                        errors.append(
                            f'{rel_path}:{line_no}: anchor #{fragment} '
                            f'tidak ditemukan di {target_path.relative_to(ROOT)}'
                        )

    return errors


def main():
    print('Validasi link internal Markdown...')
    errors = validate()
    if errors:
        print(f'\nFAIL: Ditemukan {len(errors)} link bermasalah:\n')
        for e in errors:
            print(f'  {e}')
        sys.exit(1)
    else:
        print(f'PASS: Link internal valid dalam {len(collect_markdown_files())} Markdown.')
        sys.exit(0)


if __name__ == '__main__':
    main()
