"""Validate GitHub event routing, not actor permissions or application readiness."""

import json
import os
from pathlib import Path
import sys

MEMBER_BRANCHES = {'branch-rafi', 'branch-melia', 'branch-hasan'}
TARGETS = {'main', 'development'}


def validate(event_name: str, event: dict, repository: str) -> str:
    if not repository or event.get('repository', {}).get('full_name') != repository:
        raise ValueError('Repository event tidak cocok dengan repository workflow.')
    if event_name == 'push':
        allowed = {f'refs/heads/{name}' for name in MEMBER_BRANCHES | TARGETS}
        if event.get('ref') not in allowed or event.get('deleted', False):
            raise ValueError('Push bukan update branch permanen yang diizinkan.')
        return 'PASS: event push branch permanen; arah PR tidak diuji pada push.'
    if event_name != 'pull_request':
        raise ValueError('Jenis event tidak didukung.')
    pr = event.get('pull_request') or {}
    base, head = pr.get('base') or {}, pr.get('head') or {}
    for endpoint in (base, head):
        if (endpoint.get('repo') or {}).get('full_name') != repository:
            raise ValueError('Base dan head PR harus berasal dari repository yang sama.')
    allowed_heads = MEMBER_BRANCHES if base.get('ref') == 'development' else (
        {'development'} if base.get('ref') == 'main' else set()
    )
    if head.get('ref') not in allowed_heads:
        raise ValueError('Arah PR wajib branch anggota ke development, atau development ke main.')
    return 'PASS: pasangan base/head PR dan repository sesuai kebijakan.'


def main() -> int:
    try:
        event = json.loads(Path(os.environ['GITHUB_EVENT_PATH']).read_text(encoding='utf-8'))
        print(validate(os.environ['GITHUB_EVENT_NAME'], event, os.environ['GITHUB_REPOSITORY']))
    except (OSError, ValueError, KeyError, TypeError, AttributeError) as error:
        print(f'FAIL: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
