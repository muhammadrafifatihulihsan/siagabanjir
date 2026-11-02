export interface AiConfig {
  apiKey: string;
  model: string;
  timeoutMs: number;
}

export function readAiConfig(env: NodeJS.ProcessEnv): AiConfig {
  const apiKey = (env.DEEPSEEK_API_KEY ?? env.DEEPSEEKAPI)?.trim();
  if (!apiKey || /\s/.test(apiKey)) {
    throw new Error('DEEPSEEK_API_KEY wajib diisi pada environment worker.');
  }
  const model = env.DEEPSEEK_MODEL ?? 'deepseek-flash';
  if (model !== 'deepseek-flash') {
    throw new Error('DEEPSEEK_MODEL belum didukung kontrak analisis.');
  }
  return { apiKey, model, timeoutMs: 60_000 };
}
