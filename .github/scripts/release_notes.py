"""Extract the changelog entry for a release tag; fail before publishing bad notes."""

import argparse
from pathlib import Path
import re


def notes_for_tag(changelog: str, tag: str) -> str:
    if not re.fullmatch(r'v(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)', tag):
        raise ValueError('Tag harus berformat vMAJOR.MINOR.PATCH.')
    heading = re.compile(r'^## \[' + re.escape(tag[1:]) + r'\] - \d{4}-\d{2}-\d{2}\s*$', re.MULTILINE)
    matches = list(heading.finditer(changelog))
    if len(matches) != 1:
        raise ValueError('CHANGELOG harus memiliki tepat satu entri untuk tag tersebut.')
    remainder = changelog[matches[0].end():]
    next_heading = re.search(r'^## ', remainder, re.MULTILINE)
    body = remainder[:next_heading.start()] if next_heading else remainder
    if not any(line.strip() and not line.startswith('#') for line in body.splitlines()):
        raise ValueError('Entri CHANGELOG tidak boleh kosong.')
    return body.strip() + '\n'


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('tag')
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    changelog = Path(__file__).resolve().parents[2] / 'CHANGELOG.md'
    try:
        notes = notes_for_tag(changelog.read_text(encoding='utf-8'), args.tag)
    except ValueError as error:
        parser.error(str(error))
    args.output.write_text(notes, encoding='utf-8', newline='\n')


if __name__ == '__main__':
    main()
