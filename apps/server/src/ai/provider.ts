import type { AiConfig } from './config.js';

export class AnalysisError extends Error {
  constructor(
    readonly code: string,
    readonly retryable = false,
  ) {
    super(code);
  }
}

export interface AnalysisImage {
  mime: 'image/jpeg' | 'image/png';
  data: Buffer;
}

// Transport tidak mengembalikan raw error provider atau credential ke pemanggil.
export async function callDeepSeek(
  config: AiConfig,
  prompt: string,
  images: AnalysisImage[],
  maxTokens: number,
  request: typeof fetch = fetch,
): Promise<unknown> {
  if (
    !images.length ||
    images.length > 10 ||
    images.some((i) => !i.data.length || i.data.length > 2 * 1024 * 1024)
  ) {
    throw new AnalysisError('PREPROCESS_FAILED');
  }
  const body = JSON.stringify({
    model: config.model,
    stream: false,
    response_format: { type: 'json_object' },
    max_tokens: maxTokens,
    messages: [
      { role: 'system', content: prompt },
      {
        role: 'user',
        content: images.map((image) => ({
          type: 'image_url',
          image_url: {
            url: `data:${image.mime};base64,${image.data.toString('base64')}`,
          },
        })),
      },
    ],
  });
  if (Buffer.byteLength(body) > 40 * 1024 * 1024)
    throw new AnalysisError('PREPROCESS_FAILED');
  try {
    const response = await request(
      'https://api.deepseek.com/chat/completions',
      {
        method: 'POST',
        redirect: 'error',
        headers: {
          Authorization: `Bearer ${config.apiKey}`,
          'Content-Type': 'application/json',
        },
        body,
        signal: AbortSignal.timeout(config.timeoutMs),
      },
    );
    if (!response.ok) {
      await response.body?.cancel();
      throw new AnalysisError(
        'PROVIDER_FAILED',
        response.status === 429 || response.status >= 500,
      );
    }
    const reader = response.body?.getReader();
    if (!reader) throw new AnalysisError('INVALID_OUTPUT');
    const chunks: Uint8Array[] = [];
    let size = 0;
    try {
      for (;;) {
        const { done, value } = await reader.read();
        if (done) break;
        size += value.byteLength;
        if (size > 256 * 1024) throw new AnalysisError('INVALID_OUTPUT');
        chunks.push(value);
      }
    } finally {
      await reader.cancel();
    }
    const envelope: unknown = JSON.parse(
      Buffer.concat(chunks).toString('utf8'),
    );
    if (
      !envelope ||
      typeof envelope !== 'object' ||
      !('choices' in envelope) ||
      !Array.isArray(envelope.choices)
    )
      throw new AnalysisError('INVALID_OUTPUT');
    const choice: unknown = envelope.choices[0];
    if (
      !choice ||
      typeof choice !== 'object' ||
      !('finish_reason' in choice) ||
      choice.finish_reason !== 'stop' ||
      !('message' in choice)
    )
      throw new AnalysisError('INVALID_OUTPUT');
    const message = choice.message;
    if (
      !message ||
      typeof message !== 'object' ||
      !('content' in message) ||
      typeof message.content !== 'string'
    )
      throw new AnalysisError('INVALID_OUTPUT');
    return JSON.parse(message.content) as unknown;
  } catch (error) {
    if (error instanceof AnalysisError) throw error;
    if (error instanceof SyntaxError) throw new AnalysisError('INVALID_OUTPUT');
    throw new AnalysisError('PROVIDER_UNAVAILABLE', true);
  }
}
