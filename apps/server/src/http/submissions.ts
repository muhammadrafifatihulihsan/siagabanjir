import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { requireSession } from '../auth/session.js';
import { withConnection } from '../db/pool.js';
import { parseMultipart } from '../storage/vault.js';
import {
  createUpload,
  getUpload,
  submitReport,
  getSubmission,
  closeSubmission,
  listOwnReports,
  getOwnReport,
  listReportNotes,
  getMediaStream,
} from '../reporting/submissions.js';
import type { UploadInput, SubmissionInput } from '../reporting/submissions.js';
import { HttpProblem } from './problem.js';

function validateUuid(id: string): void {
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      id,
    )
  ) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
}

function parseIdempotencyKey(
  request: FastifyRequest,
  expectedId?: string,
): string {
  const key = request.headers['idempotency-key'];
  if (
    typeof key !== 'string' ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      key,
    )
  ) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  const normalizedKey = key.toLowerCase();
  if (expectedId && normalizedKey !== expectedId.toLowerCase()) {
    throw new HttpProblem(400, 'BAD_REQUEST');
  }
  return normalizedKey;
}

function envelope(request: FastifyRequest, data: unknown) {
  return { data, requestId: request.id, serverTime: new Date().toISOString() };
}

export function registerSubmissions(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  // Tambahkan content type parser multipart
  if (!app.hasContentTypeParser('multipart/form-data')) {
    app.addContentTypeParser(
      'multipart/form-data',
      { parseAs: 'buffer', bodyLimit: 27 * 1024 * 1024 },
      (_req, body, done) => {
        done(null, body);
      },
    );
  }

  // 1. PUT /api/v1/me/uploads/:uploadId
  app.put<{ Params: { uploadId: string } }>(
    '/api/v1/me/uploads/:uploadId',
    async (request, reply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const uploadId = request.params.uploadId.toLowerCase();
      validateUuid(uploadId);
      parseIdempotencyKey(request, uploadId);

      const contentType = request.headers['content-type'];
      if (!contentType || !contentType.includes('multipart/form-data')) {
        throw new HttpProblem(415, 'UNSUPPORTED_MEDIA_TYPE');
      }

      const bodyBuffer = request.body as Buffer;
      if (!Buffer.isBuffer(bodyBuffer) || bodyBuffer.length === 0) {
        throw new HttpProblem(400, 'BAD_REQUEST');
      }

      const parsed = parseMultipart(contentType, bodyBuffer);
      if (!parsed.file) {
        throw new HttpProblem(422, 'VALIDATION_FAILED');
      }

      const purpose = parsed.fields.purpose as UploadInput['purpose'];
      const origin = parsed.fields.origin as UploadInput['origin'];
      if (!purpose || !origin) {
        throw new HttpProblem(422, 'VALIDATION_FAILED');
      }

      const { upload, isReplay } = await createUpload(
        deps,
        session.id,
        uploadId,
        { purpose, origin },
        parsed.file.data,
      );

      return reply.code(isReplay ? 200 : 201).send(envelope(request, upload));
    },
  );

  // 2. GET /api/v1/me/uploads/:uploadId
  app.get<{ Params: { uploadId: string } }>(
    '/api/v1/me/uploads/:uploadId',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const uploadId = request.params.uploadId.toLowerCase();
      validateUuid(uploadId);

      const upload = await getUpload(deps, session.id, uploadId);
      return envelope(request, upload);
    },
  );

  // 3. PUT /api/v1/me/submissions/:submissionId
  app.put<{ Params: { submissionId: string }; Body: SubmissionInput }>(
    '/api/v1/me/submissions/:submissionId',
    {
      schema: {
        body: {
          type: 'object',
          additionalProperties: false,
          required: [
            'uploadIds',
            'description',
            'point',
            'occurredAt',
            'deviceSignals',
          ],
          properties: {
            uploadIds: {
              type: 'array',
              items: { type: 'string', minLength: 36, maxLength: 36 },
              minItems: 1,
              maxItems: 2,
            },
            description: { type: 'string', minLength: 1, maxLength: 2000 },
            point: {
              type: 'object',
              additionalProperties: false,
              required: ['latitude', 'longitude', 'source'],
              properties: {
                latitude: { type: 'number', minimum: -90, maximum: 90 },
                longitude: { type: 'number', minimum: -180, maximum: 180 },
                source: { enum: ['GPS', 'MANUAL'] },
              },
            },
            occurredAt: {
              anyOf: [{ type: 'string' }, { type: 'null' }],
            },
            deviceSignals: {
              type: 'object',
              additionalProperties: false,
              required: [
                'mockLocation',
                'developerMode',
                'observedAt',
                'buildId',
              ],
              properties: {
                mockLocation: {
                  enum: ['DETECTED', 'NOT_DETECTED', 'UNKNOWN'],
                },
                developerMode: {
                  enum: ['DETECTED', 'NOT_DETECTED', 'UNKNOWN'],
                },
                observedAt: { type: 'string' },
                buildId: { type: 'string', minLength: 1, maxLength: 100 },
              },
            },
          },
        },
      },
    },
    async (request, reply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const submissionId = request.params.submissionId.toLowerCase();
      validateUuid(submissionId);
      parseIdempotencyKey(request, submissionId);

      const { state, isReplay } = await submitReport(
        deps,
        session.id,
        submissionId,
        request.body,
      );

      return reply.code(isReplay ? 200 : 201).send(envelope(request, state));
    },
  );

  // 4. GET /api/v1/me/submissions/:submissionId
  app.get<{ Params: { submissionId: string } }>(
    '/api/v1/me/submissions/:submissionId',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const submissionId = request.params.submissionId.toLowerCase();
      validateUuid(submissionId);

      const state = await getSubmission(deps, session.id, submissionId);
      return envelope(request, state);
    },
  );

  // 5. POST /api/v1/me/submissions/:submissionId/close
  app.post<{ Params: { submissionId: string } }>(
    '/api/v1/me/submissions/:submissionId/close',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const submissionId = request.params.submissionId.toLowerCase();
      validateUuid(submissionId);
      const key = parseIdempotencyKey(request);

      const state = await closeSubmission(deps, session.id, submissionId, key);
      return envelope(request, state);
    },
  );

  // 6. GET /api/v1/me/reports
  app.get<{ Querystring: { cursor?: string; q?: string } }>(
    '/api/v1/me/reports',
    {
      schema: {
        querystring: {
          type: 'object',
          additionalProperties: false,
          properties: {
            cursor: { type: 'string', minLength: 1, maxLength: 2048 },
            q: { type: 'string', minLength: 0, maxLength: 100 },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const page = await listOwnReports(deps, session.id, request.query);
      return envelope(request, page);
    },
  );

  // 7. GET /api/v1/me/reports/:reportId
  app.get<{ Params: { reportId: string } }>(
    '/api/v1/me/reports/:reportId',
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      if (session.role !== 'CITIZEN') {
        throw new HttpProblem(403, 'FORBIDDEN');
      }

      const reportId = request.params.reportId.toLowerCase();
      validateUuid(reportId);

      const report = await getOwnReport(deps, session.id, reportId);
      return envelope(request, report);
    },
  );

  // 8. GET /api/v1/reports/:reportId/notes
  app.get<{
    Params: { reportId: string };
    Querystring: { cursor?: string; q?: string };
  }>(
    '/api/v1/reports/:reportId/notes',
    {
      schema: {
        querystring: {
          type: 'object',
          additionalProperties: false,
          properties: {
            cursor: { type: 'string', minLength: 1, maxLength: 2048 },
            q: { type: 'string', minLength: 0, maxLength: 100 },
          },
        },
      },
    },
    async (request) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const reportId = request.params.reportId.toLowerCase();
      validateUuid(reportId);

      const page = await listReportNotes(
        deps,
        session.id,
        session.role,
        reportId,
        request.query,
      );
      return envelope(request, page);
    },
  );

  // 9. GET /api/v1/media/:mediaId
  app.get<{ Params: { mediaId: string } }>(
    '/api/v1/media/:mediaId',
    async (request, reply) => {
      const session = await withConnection(deps.pool, (connection) =>
        requireSession(connection, request.headers.authorization),
      );
      const mediaId = request.params.mediaId.toLowerCase();
      validateUuid(mediaId);

      const rangeHeader = request.headers.range;
      const media = await getMediaStream(
        deps,
        session.id,
        session.role,
        mediaId,
        rangeHeader,
      );

      reply.header('Content-Type', media.mime);
      reply.header('Accept-Ranges', 'bytes');
      reply.header('Cache-Control', 'private, no-transform');

      if (
        media.isRange &&
        media.rangeStart !== undefined &&
        media.rangeEnd !== undefined
      ) {
        reply.code(206);
        reply.header(
          'Content-Range',
          `bytes ${media.rangeStart}-${media.rangeEnd}/${media.totalSize}`,
        );
        reply.header('Content-Length', media.data.length);
      } else {
        reply.code(200);
        reply.header('Content-Length', media.totalSize);
      }

      return reply.send(media.data);
    },
  );
}
