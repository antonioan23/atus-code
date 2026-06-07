/**
 * @license
 * Copyright 2025 Atus Code
 * SPDX-License-Identifier: Apache-2.0
 *
 * STUB — Qwen OAuth has been removed in Atus Code.
 * This file exists only so existing imports keep compiling.
 */

import { useState, useCallback, useEffect } from 'react';
import { AuthType, type DeviceAuthorizationData } from '@atus-code/atus-code-core';

export interface AtusAuthState {
  deviceAuth: DeviceAuthorizationData | null;
  authStatus: 'idle' | 'polling' | 'success' | 'error' | 'timeout' | 'rate_limit';
  authMessage: string | null;
}

export interface ExternalAuthState {
  title: string;
  message: string;
  detail?: string;
}

export const useQwenAuth = (
  _pendingAuthType: AuthType | undefined,
  isAuthenticating: boolean,
) => {
  const [atusAuthState] = useState<AtusAuthState>({
    deviceAuth: null,
    authStatus: 'idle',
    authMessage: null,
  });
  const cancelQwenAuth = useCallback(() => {}, []);

  useEffect(() => {
    if (isAuthenticating) {
      throw new Error(
        'Qwen OAuth has been removed in Atus Code. ' +
          'Use an API-key based auth method or the OpenAI-compatible ' +
          'DashScope provider (https://dashscope.aliyuncs.com/compatible-mode/v1).',
      );
    }
  }, [isAuthenticating]);

  return { atusAuthState, cancelQwenAuth };
};
