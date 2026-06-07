/**
 * @license
 * Copyright 2025 Qwen
 * SPDX-License-Identifier: Apache-2.0
 */

export const ATUS_CODE_SIMPLE_ENV_VAR = 'ATUS_CODE_SIMPLE';

function isTruthy(value: string | undefined): boolean {
  if (!value) {
    return false;
  }

  return ['1', 'true', 'yes', 'on'].includes(value.toLowerCase().trim());
}

export function isBareMode(cliFlag?: boolean): boolean {
  return cliFlag === true || isTruthy(process.env[ATUS_CODE_SIMPLE_ENV_VAR]);
}
