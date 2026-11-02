import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  parseResult,
  reportLevel,
  type ReportResult,
} from '../src/ai/results.js';

void test('AI: KTP tidak boleh memberi nama tebakan atau field identitas tambahan', () => {
  assert.throws(() =>
    parseResult('KTP_CHECK', {
      documentType: 'KTP',
      nameReadable: false,
      extractedName: 'Nama',
      explanation: '',
    }),
  );
  assert.throws(() =>
    parseResult('KTP_CHECK', {
      documentType: 'KTP',
      nameReadable: true,
      extractedName: 'Nama',
      explanation: '',
      nik: '123',
    }),
  );
  assert.deepEqual(
    parseResult('KTP_CHECK', {
      documentType: 'OTHER',
      nameReadable: false,
      extractedName: null,
      explanation: 'Bukan KTP',
    }),
    {
      documentType: 'OTHER',
      nameReadable: false,
      extractedName: null,
      explanation: 'Bukan KTP',
    },
  );
});
void test('AI: keluarga menolak DOB/kebutuhan khusus dan batas halaman/anggota', () => {
  assert.throws(() =>
    parseResult('FAMILY_EXTRACTION', {
      members: [{ name: 'Anak', ageGroup: 'CHILD', page: 0 }],
      incomplete: false,
    }),
  );
  assert.throws(() =>
    parseResult('FAMILY_EXTRACTION', {
      members: [
        { name: 'Anak', ageGroup: 'CHILD', page: 1, specialNeeds: ['OTHER'] },
      ],
      incomplete: false,
    }),
  );
  assert.throws(() =>
    parseResult('FAMILY_EXTRACTION', {
      members: Array.from({ length: 21 }, () => ({
        name: null,
        ageGroup: 'UNKNOWN',
        page: 1,
      })),
      incomplete: true,
    }),
  );
});
void test('AI: level diturunkan hanya dari indikator sah yang cukup', () => {
  const raw = {
    relevance: 'MATCH',
    sufficientInformation: true,
    supportedIndicators: ['LOCAL_INUNDATION', 'TRAPPED'],
    explanation: 'Terlihat',
    descriptionMismatch: false,
  };
  assert.equal(
    reportLevel(parseResult('REPORT_ANALYSIS', raw) as ReportResult),
    'HIGH',
  );
  assert.throws(() =>
    parseResult('REPORT_ANALYSIS', { ...raw, relevance: 'MISMATCH' }),
  );
  assert.throws(() =>
    parseResult('REPORT_ANALYSIS', {
      ...raw,
      supportedIndicators: ['DEPTH_3M'],
    }),
  );
  assert.equal(
    reportLevel(
      parseResult('REPORT_ANALYSIS', {
        ...raw,
        supportedIndicators: [],
      }) as ReportResult,
    ),
    'UNRATED',
  );
  assert.throws(() =>
    parseResult('REPORT_ANALYSIS', { ...raw, descriptionMismatch: 'tidak' }),
  );
  assert.throws(() =>
    parseResult('REPORT_ANALYSIS', {
      relevance: raw.relevance,
      sufficientInformation: raw.sufficientInformation,
      supportedIndicators: raw.supportedIndicators,
      explanation: raw.explanation,
    }),
  );
});

void test('AI: ringkasan klaster hanya menerima teks ringkasan yang wajar', () => {
  assert.deepEqual(
    parseResult('CLUSTER_SUMMARY', {
      summary: 'Lima laporan, dua sesuai bukti.',
    }),
    { summary: 'Lima laporan, dua sesuai bukti.' },
  );
  assert.throws(() => parseResult('CLUSTER_SUMMARY', { summary: '' }));
  assert.throws(() => parseResult('CLUSTER_SUMMARY', { summary: '   ' }));
  assert.throws(() =>
    parseResult('CLUSTER_SUMMARY', { summary: 'x', confidence: 0.9 }),
  );
  assert.throws(() =>
    parseResult('CLUSTER_SUMMARY', { summary: 'x'.repeat(1001) }),
  );
});
