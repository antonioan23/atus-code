#!/usr/bin/perl -i
# Comprehensive atus -> atus rename script.
# Run from repo root: perl -i scripts/rename-atus-to-atus.pl <files>
# Order matters: most specific patterns first.
# Uses single-quoted regexes to avoid @-interpolation issues.

use strict;
use warnings;

local $/;  # slurp mode

while (<>) {
    # Phase 1: Brand name "atus code" -> "atus code"
    s'atus code'atus code'g;
    s'Atus-Code'Atus-Code'g;
    s'atus code'atus code'gi;

    # Phase 2: Specific identifiers (before generic atus -> atus)
    s'atus-code'atus-code'g;
    s'atusCode'atusCode'g;
    s'AtusCode'AtusCode'g;

    # GitHub org atuscode -> atuscode
    s'atuscode'atuscode'g;
    s'atuscode'atuscode'g;

    # npm scope: @atus-code/ -> @atus-code/  (escape @ to avoid array interpolation)
    s'\@atus-code/'@atus-code/'g;

    # Extension config file
    s'atus-extension\.json'atus-extension.json'g;
    s'atus-extension-install\.json'atus-extension-install.json'g;

    # atusignore / AtusIgnore
    s'\bqwenignore\b'atusignore'g;
    s'\bQwenIgnore\b'AtusIgnore'g;

    # Settings schema key
    s'\brespectQwenIgnore\b'respectAtusIgnore'g;

    # esbuild defines
    s'__atus_dirname'__atus_dirname'g;
    s'__atus_filename'__atus_filename'g;

    # Container image
    s'ghcr\.io/atuscode/atus-code'ghcr.io/atuscode/atus-code'gi;
    s'ghcr\.io/atuscode/'ghcr.io/atuscode/'gi;

    # Phase 3: Environment variables (ATUS_* -> ATUS_*)
    s'\bQWEN_HOME\b'ATUS_HOME'g;
    s'\bQWEN_RUNTIME_DIR\b'ATUS_RUNTIME_DIR'g;
    s'\bQWEN_DIR\b'ATUS_DIR'g;
    s'\bQWEN_MODEL\b'ATUS_MODEL'g;
    s'\bQWEN_SANDBOX\b'ATUS_SANDBOX'g;
    s'\bQWEN_DEBUG\b'ATUS_DEBUG'g;
    s'\bQWEN_LOGGER\b'ATUS_LOGGER'g;
    s'\bQWEN_LOG_LEVEL\b'ATUS_LOG_LEVEL'g;
    s'\bQWEN_SETTINGS\b'ATUS_SETTINGS'g;
    s'\bQWEN_PROJECT_DIR\b'ATUS_PROJECT_DIR'g;
    s'\bQWEN_PACKAGE_ROOT\b'ATUS_PACKAGE_ROOT'g;
    s'\bQWEN_OUTPUT_PATH\b'ATUS_OUTPUT_PATH'g;
    s'\bQWEN_EXTRACT_DIR\b'ATUS_EXTRACT_DIR'g;
    s'\bQWEN_WORKING_DIR\b'ATUS_WORKING_DIR'g;
    s'\bQWEN_TEMP_FILE_PREFIX\b'ATUS_TEMP_FILE_PREFIX'g;
    s'\bQWEN_TEMP_FILE_EXTENSION\b'ATUS_TEMP_FILE_EXTENSION'g;
    s'\bQWEN_SKILL_ROOT\b'ATUS_SKILL_ROOT'g;
    s'\bQWEN_SHELL_COMMAND\b'ATUS_SHELL_COMMAND'g;
    s'\bQWEN_OAUTH\b'ATUS_OAUTH'g;
    s'\bQWEN_DEFAULT_AUTH_TYPE\b'ATUS_DEFAULT_AUTH_TYPE'g;
    s'\bQWEN_API_KEY\b'ATUS_API_KEY'g;
    s'\bQWEN_BASE_URL\b'ATUS_BASE_URL'g;
    s'\bQWEN_EMBEDDING_MODEL\b'ATUS_EMBEDDING_MODEL'g;
    s'\bQWEN_FLASH_MODEL\b'ATUS_FLASH_MODEL'g;
    s'\bQWEN_MAINTAINER_HANDLE\b'ATUS_MAINTAINER_HANDLE'g;
    s'\bQWEN_GIT_STATUS_SEPARATOR__\b'ATUS_GIT_STATUS_SEPARATOR__'g;
    s'\bQWEN_IMAGE_TOKEN_ESTIMATE\b'ATUS_IMAGE_TOKEN_ESTIMATE'g;
    s'\bQWEN_DEBUG_LOG_FILE\b'ATUS_DEBUG_LOG_FILE'g;
    s'\bQWEN_DAEMON_URL\b'ATUS_DAEMON_URL'g;
    s'\bQWEN_DAEMON_WORKSPACE\b'ATUS_DAEMON_WORKSPACE'g;
    s'\bQWEN_DAEMON_TOKEN\b'ATUS_DAEMON_TOKEN'g;
    s'\bQWEN_SERVER_TOKEN\b'ATUS_SERVER_TOKEN'g;
    s'\bQWEN_SERVER_TOKEN_ENV\b'ATUS_SERVER_TOKEN_ENV'g;
    s'\bQWEN_PID\b'ATUS_PID'g;
    s'\bQWEN_SERVE_DEBUG\b'ATUS_SERVE_DEBUG'g;
    s'\bQWEN_SYSTEM_MD\b'ATUS_SYSTEM_MD'g;
    s'\bQWEN_WRITE_SYSTEM_MD\b'ATUS_WRITE_SYSTEM_MD'g;
    s'\bQWEN_DISABLE_AUTO_TITLE\b'ATUS_DISABLE_AUTO_TITLE'g;
    s'\bQWEN_DISABLED_SLASH_COMMANDS\b'ATUS_DISABLED_SLASH_COMMANDS'g;
    s'\bQWEN_DISABLE_HYPERLINKS\b'ATUS_DISABLE_HYPERLINKS'g;
    s'\bQWEN_TUI_E\b'ATUS_TUI_E'g;
    s'\bQWEN_TELEMETRY_ENABLED\b'ATUS_TELEMETRY_ENABLED'g;
    s'\bQWEN_TELEMETRY_TARGET\b'ATUS_TELEMETRY_TARGET'g;
    s'\bQWEN_TELEMETRY_OTLP_ENDPOINT\b'ATUS_TELEMETRY_OTLP_ENDPOINT'g;
    s'\bQWEN_TELEMETRY_OTLP_LOGS\b'ATUS_TELEMETRY_OTLP_LOGS'g;
    s'\bQWEN_TELEMETRY_OTLP_METRICS\b'ATUS_TELEMETRY_OTLP_METRICS'g;
    s'\bQWEN_TELEMETRY_OTLP_TRACES\b'ATUS_TELEMETRY_OTLP_TRACES'g;
    s'\bQWEN_TELEMETRY_OTLP_PROTOCOL\b'ATUS_TELEMETRY_OTLP_PROTOCOL'g;
    s'\bQWEN_TELEMETRY_INCLUDE_SENSITIVE_SPAN_ATTRIBUTES\b'ATUS_TELEMETRY_INCLUDE_SENSITIVE_SPAN_ATTRIBUTES'g;
    s'\bQWEN_TELEMETRY_LOG_PROMPTS\b'ATUS_TELEMETRY_LOG_PROMPTS'g;
    s'\bQWEN_TELEMETRY_OUTFILE\b'ATUS_TELEMETRY_OUTFILE'g;
    s'\bQWEN_PR_REVIEW_MODEL\b'ATUS_PR_REVIEW_MODEL'g;
    s'\bQWEN_HELPFULNESS_LEVELS\b'ATUS_HELPFULNESS_LEVELS'g;
    s'\bQWEN_FLICKER_VERBOSE\b'ATUS_FLICKER_VERBOSE'g;
    s'\bQWEN_COMPUTER_USE_AUTO_APPROVE\b'ATUS_COMPUTER_USE_AUTO_APPROVE'g;
    s'\bQWEN_COMPUTER_USE_PACKAGE\b'ATUS_COMPUTER_USE_PACKAGE'g;
    s'\bQWEN_CREDENTIAL_FILENAME\b'ATUS_CREDENTIAL_FILENAME'g;
    s'\bQWEN_CREDENTIAL_FILE_MODE\b'ATUS_CREDENTIAL_FILE_MODE'g;
    s'\bQWEN_COMPACT_MAX_RECENT_FILES\b'ATUS_COMPACT_MAX_RECENT_FILES'g;
    s'\bQWEN_COMPACT_MAX_RECENT_IMAGES\b'ATUS_COMPACT_MAX_RECENT_IMAGES'g;
    s'\bQWEN_COMPACT_SCREENSHOT_THRESHOLD\b'ATUS_COMPACT_SCREENSHOT_THRESHOLD'g;
    s'\bQWEN_COMPACT_SCREENSHOT_TRIGGER\b'ATUS_COMPACT_SCREENSHOT_TRIGGER'g;
    s'\bQWEN_BASELINE_'ATUS_BASELINE_'g;
    s'\bQWEN_BASELINE_ENABLE_PROMPT_LATENCY\b'ATUS_BASELINE_ENABLE_PROMPT_LATENCY'g;
    s'\bQWEN_ISSUE_FOLLOWUP_BOT_'ATUS_ISSUE_FOLLOWUP_BOT_'g;
    s'\bQWEN_'ATUS_'g;  # catch-all for any remaining ATUS_*

    # Phase 4: ATUS_CODE_* env vars
    s'\bQWEN_CODE_LANG\b'ATUS_LANG'g;
    s'\bQWEN_CODE_API_TIMEOUT_MS\b'ATUS_API_TIMEOUT_MS'g;
    s'\bQWEN_CODE_MERMAID_IMAGE_PROTOCOL\b'ATUS_MERMAID_IMAGE_PROTOCOL'g;
    s'\bQWEN_CODE_MERMAID_IMAGE_RENDERING\b'ATUS_MERMAID_IMAGE_RENDERING'g;
    s'\bQWEN_CODE_IDE_SERVER_PORT\b'ATUS_IDE_SERVER_PORT'g;
    s'\bQWEN_CODE_IDE_SERVER_STDIO_COMMAND\b'ATUS_IDE_SERVER_STDIO_COMMAND'g;
    s'\bQWEN_CODE_IDE_SERVER_STDIO_ARGS\b'ATUS_IDE_SERVER_STDIO_ARGS'g;
    s'\bQWEN_CODE_IDE_WORKSPACE_PATH\b'ATUS_IDE_WORKSPACE_PATH'g;
    s'\bQWEN_CODE_COMPANION_EXTENSION_NAME\b'ATUS_COMPANION_EXTENSION_NAME'g;
    s'\bQWEN_CODE_SETTINGS_CORRUPTED_PATH\b'ATUS_SETTINGS_CORRUPTED_PATH'g;
    s'\bQWEN_CODE_SETTINGS_WAS_RECOVERED\b'ATUS_SETTINGS_WAS_RECOVERED'g;
    s'\bQWEN_CODE_SYSTEM_SETTINGS_PATH\b'ATUS_SYSTEM_SETTINGS_PATH'g;
    s'\bQWEN_CODE_SYSTEM_DEFAULTS_PATH\b'ATUS_SYSTEM_DEFAULTS_PATH'g;
    s'\bQWEN_CODE_TRUSTED_FOLDERS_PATH\b'ATUS_TRUSTED_FOLDERS_PATH'g;
    s'\bQWEN_CODE_BOT_TOKEN\b'ATUS_BOT_TOKEN'g;
    s'\bQWEN_CODE_MAX_OUTPUT_TOKENS\b'ATUS_MAX_OUTPUT_TOKENS'g;
    s'\bQWEN_CODE_MAX_TOOL_CONCURRENCY\b'ATUS_MAX_TOOL_CONCURRENCY'g;
    s'\bQWEN_CODE_NO_RELAUNCH\b'ATUS_NO_RELAUNCH'g;
    s'\bQWEN_CODE_DISABLE_EARLY_CAPTURE\b'ATUS_DISABLE_EARLY_CAPTURE'g;
    s'\bQWEN_CODE_DISABLE_MERMAID_IMAGES\b'ATUS_DISABLE_MERMAID_IMAGES'g;
    s'\bQWEN_CODE_DISABLE_PRECONNECT\b'ATUS_DISABLE_PRECONNECT'g;
    s'\bQWEN_CODE_DISABLE_SYNCHRONIZED_OUTPUT\b'ATUS_DISABLE_SYNCHRONIZED_OUTPUT'g;
    s'\bQWEN_CODE_MEMORY_BASE_DIR\b'ATUS_MEMORY_BASE_DIR'g;
    s'\bQWEN_CODE_MEMORY_LOCAL\b'ATUS_MEMORY_LOCAL'g;
    s'\bQWEN_CODE_FORCE_ENCRYPTED_FILE_STORAGE\b'ATUS_FORCE_ENCRYPTED_FILE_STORAGE'g;
    s'\bQWEN_CODE_FORCE_FILE_STORAGE\b'ATUS_FORCE_FILE_STORAGE'g;
    s'\bQWEN_CODE_FORCE_SYNCHRONIZED_OUTPUT\b'ATUS_FORCE_SYNCHRONIZED_OUTPUT'g;
    s'\bQWEN_CODE_SYNCHRONIZED_OUTPUT\b'ATUS_SYNCHRONIZED_OUTPUT'g;
    s'\bQWEN_CODE_CPU_PROFILE\b'ATUS_CPU_PROFILE'g;
    s'\bQWEN_CODE_PROFILE_RUNTIME\b'ATUS_PROFILE_RUNTIME'g;
    s'\bQWEN_CODE_PROFILE_STARTUP\b'ATUS_PROFILE_STARTUP'g;
    s'\bQWEN_CODE_PROFILE_STARTUP_NO_HEAP\b'ATUS_PROFILE_STARTUP_NO_HEAP'g;
    s'\bQWEN_CODE_PROFILE_STARTUP_OUTER\b'ATUS_PROFILE_STARTUP_OUTER'g;
    s'\bQWEN_CODE_DEBUG\b'ATUS_DEBUG_LOG'g;
    s'\bQWEN_CODE_TOOL_CALL_STYLE\b'ATUS_TOOL_CALL_STYLE'g;
    s'\bQWEN_CODE_LEGACY_ERASE_LINES\b'ATUS_LEGACY_ERASE_LINES'g;
    s'\bQWEN_CODE_LEGACY_MCP_BLOCKING\b'ATUS_LEGACY_MCP_BLOCKING'g;
    s'\bQWEN_CODE_ENABLE_CRON\b'ATUS_ENABLE_CRON'g;
    s'\bQWEN_CODE_ENABLE_FORK_SUBAGENT\b'ATUS_ENABLE_FORK_SUBAGENT'g;
    s'\bQWEN_CODE_ENABLE_AWAY_SUMMARY\b'ATUS_ENABLE_AWAY_SUMMARY'g;
    s'\bQWEN_CODE_MAX_BACKGROUND_AGENTS\b'ATUS_MAX_BACKGROUND_AGENTS'g;
    s'\bQWEN_CODE_STOP_HOOK_BLOCK_CAP\b'ATUS_STOP_HOOK_BLOCK_CAP'g;
    s'\bQWEN_CODE_SIMPLE\b'ATUS_SIMPLE'g;
    s'\bQWEN_CODE_SIMPLE_ENV_VAR\b'ATUS_SIMPLE_ENV_VAR'g;
    s'\bQWEN_CODE_INTEGRATION_TEST\b'ATUS_INTEGRATION_TEST'g;
    s'\bQWEN_CODE_VERSION\b'ATUS_VERSION'g;
    s'\bQWEN_CODE_ENTRYPOINT\b'ATUS_ENTRYPOINT'g;
    s'\bQWEN_CODE_SDK_LEVEL\b'ATUS_SDK_LEVEL'g;
    s'\bQWEN_CODE_SDK\b'ATUS_SDK'g;
    s'\bQWEN_CODE_CHAT\b'ATUS_CHAT'g;
    s'\bQWEN_CODE_CLI_PATH\b'ATUS_CLI_PATH'g;
    s'\bQWEN_CODE_PROMPT_ID\b'ATUS_PROMPT_ID'g;
    s'\bQWEN_CODE_SUPPRESS_YOLO_WARNING\b'ATUS_SUPPRESS_YOLO_WARNING'g;
    s'\bQWEN_CODE_UNATTENDED_RETRY\b'ATUS_UNATTENDED_RETRY'g;
    s'\bQWEN_CODE_EMIT_TOOL_USE_SUMMARIES\b'ATUS_EMIT_TOOL_USE_SUMMARIES'g;
    s'\bQWEN_CODE_AGENT_ID\b'ATUS_AGENT_ID'g;
    s'\bQWEN_CODE_'ATUS_'g;  # catch-all

    # Phase 5: Settings directory paths
    s'/etc/atus-code/'/etc/atus-code/'g;
    s'C:\\ProgramData\\atus-code\\'C:\\ProgramData\\atus-code\\'g;
    s'/Library/Application Support/AtusCode/'/Library/Application Support/AtusCode/'g;
    s'~/\.atus-code/'~/.atus-code/'g;
    s'\.atus-code/'.atus-code/'g;
    s'\.atus-code\b'.atus-code'g;
    s"ATUS_DIR = '\.atus-code'"ATUS_DIR = '.atus-code'"g;
    s'\.atusignore'.atusignore'g;

    # Phase 6: Repo / container URLs
    s'https://github\.com/atuscode/atus-code'https://github.com/atuscode/atus-code'g;
    s'https://github\.com/atuscode/atus-code'https://github.com/atuscode/atus-code'gi;
    s'github\.com/atuscode/atus-code-action'github.com/atuscode/atus-code-action'g;  # external, keep similar

    # NPM registry
    s'www\.npmjs\.com/package/\@atus-code/atus-code'www.npmjs.com/package/\@atus-code/atus-code'g;
    s'registry\.npmjs\.org/\@atus-code/atus-code'registry.npmjs.org/\@atus-code/atus-code'g;
    s'\\@atus-code/atus-code/-/atus-code-'\\@atus-code/atus-code/-/atus-code-'g;

    # atus-code-assets bucket
    s'atus-code-assets\.oss-cn-hangzhou\.aliyuncs\.com'atus-code-assets.oss-cn-hangzhou.aliyuncs.com'g;

    # Phase 7: Zed extension hardcoded version
    s'atus-code-0\.10\.0\.tgz'atus-code-0.10.0.tgz'g;

    # Phase 8: Generic identifiers (lowercase atus -> atus)
    # Skip model names (qwen2, qwen3, etc.) using negative lookahead
    s'\bqwen(?![0-9A-Za-z])'atus'g;
    # Lowercase atus followed by uppercase letter (identifiers like atusClient, atusLogger)
    s'\bqwen(?=[A-Z])'atus'g;

    # Phase 8.5: Capitalized Qwen followed by uppercase letter (identifiers like AtusClient)
    # Exclude LM (handled by Phase 2 as atuscode) and Code (handled by Phase 2 as AtusCode)
    s'\bQwen(?=[A-Z])(?!LM|Code|OAuth|Code-|Code-)'Atus'g;

    # Phase 8.7: atus-code- prefix (skill names, file refs, etc.)
    s'atus-code-claw'atus-code-claw'g;
    s'atus-code-action'atus-code-action'g;  # also rename action references

    # Phase 8.8: Python SDK
    s'atus-code-sdk'atus-code-sdk'g;
    s'atus_code_sdk'atus_code_sdk'g;

    # Phase 9: Settings keys
    s'general\.atusCode'general.atusCode'g;
    s'general\.respectAtusIgnore'general.respectAtusIgnore'g;

    # Phase 11: Debug log category names
    s'Atus_helpfulness'Atus_helpfulness'g;
    s'Atus_md_additions'Atus_md_additions'g;

    # Phase 12: Java SDK (atuscode-sdk, atuscode)
    s'atuscode-sdk'atuscode-sdk'g;
    s'atuscode'atuscode'g;

    print;
}
