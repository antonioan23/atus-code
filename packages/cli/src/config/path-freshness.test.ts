/**
 * @license
 * Copyright 2025 Google LLC
 * SPDX-License-Identifier: Apache-2.0
 */

import { afterEach, beforeEach, describe, expect, it } from 'vitest';
import * as path from 'node:path';
import { homedir } from 'node:os';
import { getUserSettingsDir, getUserSettingsPath } from './settings.js';
import { getTrustedFoldersPath } from './trustedFolders.js';

// Regression guard: `ATUS_HOME` is resolved by `preResolveHomeEnvOverrides()`
// AFTER any module that imports a settings/trustedFolders path has loaded.
// A top-level `const` would freeze the pre-bootstrap value and split state
// across callers. Each test mutates `process.env.ATUS_HOME` post-load and
// asserts the exported path getters reflect the new value.

describe('settings/trustedFolders path getters are lazy', () => {
  let originalQwenHome: string | undefined;
  let originalTrustedPath: string | undefined;

  beforeEach(() => {
    originalQwenHome = process.env['ATUS_HOME'];
    originalTrustedPath = process.env['ATUS_CODE_TRUSTED_FOLDERS_PATH'];
    delete process.env['ATUS_HOME'];
    delete process.env['ATUS_CODE_TRUSTED_FOLDERS_PATH'];
  });

  afterEach(() => {
    if (originalQwenHome === undefined) delete process.env['ATUS_HOME'];
    else process.env['ATUS_HOME'] = originalQwenHome;
    if (originalTrustedPath === undefined)
      delete process.env['ATUS_CODE_TRUSTED_FOLDERS_PATH'];
    else process.env['ATUS_CODE_TRUSTED_FOLDERS_PATH'] = originalTrustedPath;
  });

  it('getUserSettingsPath() reflects ATUS_HOME set after module load', () => {
    const defaultPath = getUserSettingsPath();
    expect(defaultPath).toBe(path.join(homedir(), '.atus-code', 'settings.json'));

    process.env['ATUS_HOME'] = '/tmp/atus-lazy-test';
    expect(getUserSettingsPath()).toBe(
      path.join('/tmp/atus-lazy-test', 'settings.json'),
    );
  });

  it('getUserSettingsDir() reflects ATUS_HOME set after module load', () => {
    expect(getUserSettingsDir()).toBe(path.join(homedir(), '.atus-code'));

    process.env['ATUS_HOME'] = '/tmp/atus-lazy-test';
    expect(getUserSettingsDir()).toBe(path.normalize('/tmp/atus-lazy-test'));
  });

  it('getTrustedFoldersPath() reflects ATUS_HOME set after module load', () => {
    expect(getTrustedFoldersPath()).toBe(
      path.join(homedir(), '.atus-code', 'trustedFolders.json'),
    );

    process.env['ATUS_HOME'] = '/tmp/atus-lazy-test';
    expect(getTrustedFoldersPath()).toBe(
      path.join('/tmp/atus-lazy-test', 'trustedFolders.json'),
    );
  });
});
