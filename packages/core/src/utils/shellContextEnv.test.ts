/**
 * @license
 * Copyright 2025 Qwen
 * SPDX-License-Identifier: Apache-2.0
 */

import { describe, expect, it, beforeEach, afterEach } from 'vitest';
import { getShellContextEnvVars } from './shellContextEnv.js';
import { runWithAgentContext } from '../agents/runtime/agent-context.js';
import { promptIdContext } from './promptIdContext.js';

describe('getShellContextEnvVars', () => {
  let originalSessionId: string | undefined;

  beforeEach(() => {
    originalSessionId = process.env['ATUS_CODE_SESSION_ID'];
    delete process.env['ATUS_CODE_SESSION_ID'];
  });

  afterEach(() => {
    if (originalSessionId !== undefined) {
      process.env['ATUS_CODE_SESSION_ID'] = originalSessionId;
    } else {
      delete process.env['ATUS_CODE_SESSION_ID'];
    }
  });

  it('returns empty strings for agent/prompt when no context is available', () => {
    const env = getShellContextEnvVars();
    expect(env).toEqual({
      ATUS_CODE_AGENT_ID: '',
      ATUS_CODE_PROMPT_ID: '',
    });
  });

  it('returns ATUS_CODE_SESSION_ID when set in process.env', () => {
    process.env['ATUS_CODE_SESSION_ID'] = 'test-session-123';
    const env = getShellContextEnvVars();
    expect(env['ATUS_CODE_SESSION_ID']).toBe('test-session-123');
  });

  it('returns ATUS_CODE_AGENT_ID when called within agent context', async () => {
    const env = await runWithAgentContext('my-agent-42', async () =>
      getShellContextEnvVars(),
    );
    expect(env['ATUS_CODE_AGENT_ID']).toBe('my-agent-42');
  });

  it('returns ATUS_CODE_PROMPT_ID when called within prompt context', () => {
    const env = promptIdContext.run('prompt-abc', () =>
      getShellContextEnvVars(),
    );
    expect(env['ATUS_CODE_PROMPT_ID']).toBe('prompt-abc');
  });

  it('returns all vars when all contexts are active', async () => {
    process.env['ATUS_CODE_SESSION_ID'] = 'sess-uuid';
    const env = await runWithAgentContext('agent-xyz', async () =>
      promptIdContext.run('prompt-456', () => getShellContextEnvVars()),
    );
    expect(env).toEqual({
      ATUS_CODE_SESSION_ID: 'sess-uuid',
      ATUS_CODE_AGENT_ID: 'agent-xyz',
      ATUS_CODE_PROMPT_ID: 'prompt-456',
    });
  });

  it('sets empty string for agent/prompt to override inherited env', () => {
    // Simulates a nested atus-code process where parent injected these
    const env = getShellContextEnvVars();
    expect(env['ATUS_CODE_AGENT_ID']).toBe('');
    expect(env['ATUS_CODE_PROMPT_ID']).toBe('');
    // Empty strings will overwrite any stale inherited values in process.env
  });
});
