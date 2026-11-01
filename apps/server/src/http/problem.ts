export class HttpProblem extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    readonly retryAfterSeconds: number | null = null,
    readonly currentVersion: number | null = null,
  ) {
    super(code);
  }
}
