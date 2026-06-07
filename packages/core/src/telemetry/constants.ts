/**
 * @license
 * Copyright 2025 Google LLC
 * SPDX-License-Identifier: Apache-2.0
 */

export const SERVICE_NAME = 'atus-code';

export const EVENT_USER_PROMPT = 'atus-code.user_prompt';
export const EVENT_USER_RETRY = 'atus-code.user_retry';
export const EVENT_TOOL_CALL = 'atus-code.tool_call';
export const EVENT_API_REQUEST = 'atus-code.api_request';
export const EVENT_API_ERROR = 'atus-code.api_error';
export const EVENT_API_CANCEL = 'atus-code.api_cancel';
export const EVENT_API_RESPONSE = 'atus-code.api_response';
export const EVENT_CLI_CONFIG = 'atus-code.config';
export const EVENT_EXTENSION_DISABLE = 'atus-code.extension_disable';
export const EVENT_EXTENSION_ENABLE = 'atus-code.extension_enable';
export const EVENT_EXTENSION_INSTALL = 'atus-code.extension_install';
export const EVENT_EXTENSION_UNINSTALL = 'atus-code.extension_uninstall';
export const EVENT_EXTENSION_UPDATE = 'atus-code.extension_update';
export const EVENT_FLASH_FALLBACK = 'atus-code.flash_fallback';
export const EVENT_RIPGREP_FALLBACK = 'atus-code.ripgrep_fallback';
export const EVENT_NEXT_SPEAKER_CHECK = 'atus-code.next_speaker_check';
export const EVENT_SLASH_COMMAND = 'atus-code.slash_command';
export const EVENT_IDE_CONNECTION = 'atus-code.ide_connection';
export const EVENT_CHAT_COMPRESSION = 'atus-code.chat_compression';
export const EVENT_INVALID_CHUNK = 'atus-code.chat.invalid_chunk';
export const EVENT_CONTENT_RETRY = 'atus-code.chat.content_retry';
export const EVENT_CONTENT_RETRY_FAILURE =
  'atus-code.chat.content_retry_failure';
// Phase 4b — HTTP-status retry telemetry emitted by `retryWithBackoff` for
// 429 / 5xx errors at LLM call sites. Distinct from EVENT_CONTENT_RETRY,
// which is fired by geminiChat for InvalidStreamError retries on a separate
// retry budget. See docs/design/telemetry-llm-request-timing-design.md.
export const EVENT_API_RETRY = 'atus-code.api_retry';
export const EVENT_CONVERSATION_FINISHED = 'atus-code.conversation_finished';
export const EVENT_MALFORMED_JSON_RESPONSE =
  'atus-code.malformed_json_response';
export const EVENT_FILE_OPERATION = 'atus-code.file_operation';
export const EVENT_MODEL_SLASH_COMMAND = 'atus-code.slash_command.model';
export const EVENT_SUBAGENT_EXECUTION = 'atus-code.subagent_execution';
export const EVENT_SKILL_LAUNCH = 'atus-code.skill_launch';
export const EVENT_AUTH = 'atus-code.auth';
export const EVENT_USER_FEEDBACK = 'atus-code.user_feedback';

// Prompt Suggestion Events
export const EVENT_PROMPT_SUGGESTION = 'atus-code.prompt_suggestion';
export const EVENT_SPECULATION = 'atus-code.speculation';

// Arena Events
export const EVENT_ARENA_SESSION_STARTED = 'atus-code.arena_session_started';
export const EVENT_ARENA_AGENT_COMPLETED = 'atus-code.arena_agent_completed';
export const EVENT_ARENA_SESSION_ENDED = 'atus-code.arena_session_ended';

// Performance Events
export const EVENT_STARTUP_PERFORMANCE = 'atus-code.startup.performance';
export const EVENT_MEMORY_USAGE = 'atus-code.memory.usage';
export const EVENT_PERFORMANCE_BASELINE = 'atus-code.performance.baseline';
export const EVENT_PERFORMANCE_REGRESSION = 'atus-code.performance.regression';

// Managed Auto-Memory Events
export const EVENT_MEMORY_EXTRACT = 'atus-code.memory.extract';
export const EVENT_MEMORY_DREAM = 'atus-code.memory.dream';
export const EVENT_MEMORY_RECALL = 'atus-code.memory.recall';

// Session Tracing Span Names
export const SPAN_INTERACTION = 'atus-code.interaction';
export const SPAN_LLM_REQUEST = 'atus-code.llm_request';
export const SPAN_TOOL = 'atus-code.tool';
export const SPAN_TOOL_EXECUTION = 'atus-code.tool.execution';
/** Brackets the time a tool spends in `awaiting_approval` waiting on the user. */
export const SPAN_TOOL_BLOCKED_ON_USER = 'atus-code.tool.blocked_on_user';
/** Wraps each pre/post-tool-use hook fire site for per-hook latency / decision tracking. */
export const SPAN_HOOK = 'atus-code.hook';
/**
 * Wraps a single subagent invocation. Parents the LLM/tool/hook spans the
 * subagent emits, so concurrent subagents (parallel AGENT tool calls) get
 * isolated subtrees instead of interleaving under the parent interaction
 * (#3731 Phase 3).
 */
export const SPAN_SUBAGENT = 'atus-code.subagent';
