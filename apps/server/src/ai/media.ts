import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { mkdtemp, mkdir, readFile, writeFile, rm } from 'node:fs/promises';
import { join } from 'node:path';
import { getStorageDirectory } from '../storage/vault.js';
import { AnalysisError, type AnalysisImage } from './provider.js';

const run = promisify(execFile);
export async function prepareImages(
  data: Buffer,
  mime: string,
  document: boolean,
): Promise<AnalysisImage[]> {
  const parent = join(getStorageDirectory(), 'working');
  await mkdir(parent, { recursive: true });
  const dir = await mkdtemp(join(parent, 'analysis-'));
  const input = join(dir, 'source');
  const started = Date.now();
  const execute = async (binary: string, args: string[]) =>
    run(binary, args, {
      timeout: Math.max(1, 60_000 - (Date.now() - started)),
      maxBuffer: 3 * 1024 * 1024,
      windowsHide: true,
    });
  try {
    await writeFile(input, data);
    const sources: { path: string; time?: number }[] = [];
    if (mime === 'application/pdf') {
      const info = await execute(process.env.PDFINFO_PATH ?? 'pdfinfo', [
        input,
      ]);
      const pages = Number(/^Pages:\s+(\d+)/m.exec(info.stdout)?.[1]);
      if (!pages || pages > 10 || /^Encrypted:\s+yes/m.test(info.stdout))
        throw new AnalysisError('PREPROCESS_FAILED');
      for (let page = 1; page <= pages; page++) {
        const prefix = join(dir, `page-${page}`);
        await execute(process.env.PDFTOPPM_PATH ?? 'pdftoppm', [
          '-f',
          String(page),
          '-l',
          String(page),
          '-singlefile',
          '-scale-to',
          '2400',
          '-jpeg',
          '-jpegopt',
          'quality=90',
          input,
          prefix,
        ]);
        sources.push({ path: `${prefix}.jpg` });
      }
    } else if (mime === 'video/mp4') {
      const probe = await execute(process.env.FFPROBE_PATH ?? 'ffprobe', [
        '-v',
        'error',
        '-show_entries',
        'format=duration',
        '-of',
        'default=noprint_wrappers=1:nokey=1',
        input,
      ]);
      const duration = Number(probe.stdout.trim());
      if (!Number.isFinite(duration) || duration <= 0 || duration > 5)
        throw new AnalysisError('PREPROCESS_FAILED');
      for (const time of [0, duration / 2, Math.max(0, duration - 0.04)])
        sources.push({ path: input, time });
    } else if (mime.startsWith('image/')) sources.push({ path: input });
    else throw new AnalysisError('PREPROCESS_FAILED');
    const images: AnalysisImage[] = [];
    const edge = document ? 2400 : 1600;
    for (const [index, source] of sources.entries()) {
      let bytes: Buffer | undefined;
      for (const quality of [3, 5, 8]) {
        const output = join(dir, `frame-${index}-${quality}.jpg`);
        await execute(process.env.FFMPEG_PATH ?? 'ffmpeg', [
          '-v',
          'error',
          ...(source.time === undefined ? [] : ['-ss', String(source.time)]),
          '-i',
          source.path,
          '-frames:v',
          '1',
          '-vf',
          `scale=w='min(${edge},iw)':h='min(${edge},ih)':force_original_aspect_ratio=decrease`,
          '-map_metadata',
          '-1',
          '-q:v',
          String(quality),
          output,
        ]);
        bytes = await readFile(output);
        if (bytes.length <= 2 * 1024 * 1024) break;
      }
      if (!bytes?.length || bytes.length > 2 * 1024 * 1024)
        throw new AnalysisError('PREPROCESS_FAILED');
      images.push({ mime: 'image/jpeg', data: bytes });
    }
    return images;
  } catch {
    throw new AnalysisError('PREPROCESS_FAILED');
  } finally {
    // dir berasal dari mkdtemp di bawah storage/working, tidak memakai nama upload.
    await rm(dir, { recursive: true, force: true });
  }
}
