import { afterEach, beforeEach, describe, expect, it } from 'vitest';
import path from 'node:path';
import { Storage } from '@atus-code/atus-code-core';
import type { LoadedSettings } from '../config/settings.js';
import { runWithAcpRuntimeOutputDir } from './runtimeOutputDirContext.js';

describe('runWithAcpRuntimeOutputDir', () => {
  beforeEach(() => {
    Storage.setRuntimeBaseDir(null);
    delete process.env['ATUS_RUNTIME_DIR'];
  });

  afterEach(() => {
    Storage.setRuntimeBaseDir(null);
    delete process.env['ATUS_RUNTIME_DIR'];
  });

  it('uses the merged runtimeOutputDir relative to cwd within the async context', async () => {
    const cwd = path.resolve('workspace', 'project-a');
    const settings = {
      merged: {
        advanced: {
          runtimeOutputDir: '.atus-code-runtime',
        },
      },
    } as LoadedSettings;

    await runWithAcpRuntimeOutputDir(settings, cwd, async () => {
      expect(Storage.getRuntimeBaseDir()).toBe(path.join(cwd, '.atus-code-runtime'));
    });

    expect(Storage.getRuntimeBaseDir()).toBe(Storage.getGlobalQwenDir());
  });
});
