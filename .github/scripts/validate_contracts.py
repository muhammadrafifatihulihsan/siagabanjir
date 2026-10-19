"""Periksa schema/contoh dan invariant SRS-IF-004; bukan tes runtime aplikasi.

Jalankan: python -B -X utf8 .github/scripts/validate_contracts.py
Pemeliharaan mengikuti rules/documentation.md.
"""

import json
from pathlib import Path
import sys

from jsonschema import Draft202012Validator, FormatChecker
from jsonschema.exceptions import SchemaError

ROOT = Path(__file__).resolve().parents[2]
SECRET_OPERATIONS = (
    '/auth/signup', '/auth/login', '/auth/reset-password', '/me/recovery-code',
)
REQUIRED_FORMATS = {'date-time', 'email', 'uri', 'uuid'}


def resolve_ref(document: dict, reference: str):
    if not reference.startswith('#/'):
        raise ValueError(f'Referensi harus lokal: {reference}')
    value = document
    for part in reference[2:].split('/'):
        value = value[part.replace('~1', '/').replace('~0', '~')]
    return value


def references(value):
    if isinstance(value, dict):
        if '$ref' in value:
            yield value['$ref']
        for child in value.values():
            yield from references(child)
    elif isinstance(value, list):
        for child in value:
            yield from references(child)


def validator(api: dict, schema: dict) -> Draft202012Validator:
    return Draft202012Validator(
        {**schema, 'components': api['components']},
        format_checker=FormatChecker(),
    )


def validate(api: dict, examples: list) -> list[str]:
    errors = []
    missing_formats = REQUIRED_FORMATS - FormatChecker.checkers.keys()
    if missing_formats:
        return [
            'Pemeriksa format belum tersedia: ' + ', '.join(sorted(missing_formats))
            + '; pasang .github/requirements-validation.txt',
        ]
    for reference in references(api):
        try:
            resolve_ref(api, reference)
        except (KeyError, TypeError, ValueError) as exc:
            errors.append(f'Referensi tidak valid: {reference}: {exc}')
    for name, schema in api['components']['schemas'].items():
        try:
            Draft202012Validator.check_schema(schema)
        except SchemaError as exc:
            errors.append(f'Schema {name}: {exc}')
    if errors:
        return errors
    if not examples:
        errors.append('Contoh payload tidak boleh kosong')
    names = set()
    for example in examples:
        name = example['name']
        if name in names:
            errors.append(f'Nama contoh ganda: {name}')
        names.add(name)
        if not isinstance(example['expectedValid'], bool):
            errors.append(f'{name}: expectedValid harus boolean')
            continue
        if example['scope'] != 'SCHEMA_ONLY':
            errors.append(f'{name}: contoh bukan bukti runtime')
        schema_name = example['schema']
        if schema_name not in api['components']['schemas']:
            errors.append(f'{name}: schema {schema_name} tidak ditemukan')
            continue
        schema = {'$ref': '#/components/schemas/' + schema_name}
        actual = validator(api, schema).is_valid(example['payload'])
        if actual != example['expectedValid']:
            errors.append(f'{name}: valid={actual}, harapan={example["expectedValid"]}')

    # Signup pertama mengeluarkan recovery code; respons 200 replay tidak sah.
    signup = api['paths'].get('/auth/signup', {}).get('post', {})
    if '200' in signup.get('responses', {}):
        errors.append('SRS-IF-004: signup tidak boleh menyediakan respons replay 200')
    for path in SECRET_OPERATIONS:
        responses = api['paths'].get(path, {}).get('post', {}).get('responses', {})
        conflict = responses.get('409')
        if conflict is None:
            errors.append(f'SRS-IF-004: {path} tidak mendefinisikan konflik 409')
            continue
        if '$ref' in conflict:
            conflict = resolve_ref(api, conflict['$ref'])
        media = conflict.get('content', {}).get('application/json', {})
        schema = media.get('schema', {})
        example = media.get('example', {})
        if schema != {'$ref': '#/components/schemas/Error'}:
            errors.append(f'SRS-IF-004: {path} konflik harus memakai Error aman')
        if (
            example.get('code') != 'RESULT_ALREADY_COMMITTED'
            or not validator(api, {'$ref': '#/components/schemas/Error'}).is_valid(example)
        ):
            errors.append(f'SRS-IF-004: {path} contoh konflik tidak valid/aman')
    return errors


def main():
    try:
        api = json.loads((ROOT / 'docs/openapi.json').read_text(encoding='utf-8'))
        examples = json.loads((ROOT / 'docs/examples.json').read_text(encoding='utf-8'))
        errors = validate(api, examples)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        print(f'FAIL: Kontrak tidak dapat diperiksa: {exc}')
        return 1
    if errors:
        print('\n'.join(errors))
        return 1
    print(
        f'PASS: {len(api["components"]["schemas"])} schema, '
        f'{len(examples)} contoh, referensi dan kontrak replay rahasia. '
        'Pengujian aplikasi tetap NOT_RUN.'
    )
    return 0


if __name__ == '__main__':
    sys.exit(main())
