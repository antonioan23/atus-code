/**
 * @license
 * Copyright 2025 Atus Code
 * SPDX-License-Identifier: Apache-2.0
 *
 * STUB FILE — Qwen OAuth has been removed in Atus Code.
 *
 * This file exists only to satisfy imports from code that still references
 * the old Qwen OAuth types (the auth type enum value is kept for type
 * compatibility). If any of these APIs are actually called, we throw a
 * clear error so the user can migrate to a supported auth method.
 */

export type AtusCredentials = never;
export type TokenRefreshData = never;
export type ErrorData = never;
export type IQwenOAuth2Client = never;
export type DeviceAuthorizationData = never;
export type QwenOAuth2Event = never;
// Also export a runtime symbol so esbuild sees it (the type alone is erased)
export const QwenOAuth2Event = Symbol('QwenOAuth2Event') as any;

export function getQwenOAuthClient(): never {
  throw new Error(
    'Qwen OAuth has been removed in Atus Code. ' +
      'Use an API-key based auth method (USE_OPENAI with a DashScope-compatible ' +
      'base URL, or one of the providers configured under modelProviders).',
  );
}

export const atusOAuth2Events = {
  on(): never {
    throw new Error('Qwen OAuth has been removed in Atus Code');
  },
  off(): never {
    throw new Error('Qwen OAuth has been removed in Atus Code');
  },
  once(): never {
    throw new Error('Qwen OAuth has been removed in Atus Code');
  },
  emit(): never {
    throw new Error('Qwen OAuth has been removed in Atus Code');
  },
  removeAllListeners(): void {},
  removeListener(): void {},
  listenerCount(): number {
    return 0;
  },
};

// === Stubs for Qwen OAuth credential management (removed) ===
export function clearCachedCredentialFile(): never {
  throw new Error(
    'clearCachedCredentialFile is no longer available: Qwen OAuth has been removed in Atus Code.',
  );
}

export function clearAllCachedCredentialFiles(): never {
  throw new Error(
    'clearAllCachedCredentialFiles is no longer available: Qwen OAuth has been removed in Atus Code.',
  );
}

export function loadCachedCredentials(): never {
  throw new Error(
    'loadCachedCredentials is no longer available: Qwen OAuth has been removed in Atus Code.',
  );
}

export function saveCachedCredentials(): never {
  throw new Error(
    'saveCachedCredentials is no longer available: Qwen OAuth has been removed in Atus Code.',
  );
}
