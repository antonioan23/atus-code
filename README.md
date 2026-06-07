<div align="center">

[![npm version](https://img.shields.io/npm/v/@atus-code/atus-code.svg)](https://www.npmjs.com/package/@atus-code/atus-code)
[![License](https://img.shields.io/github/license/atuscode/atus-code.svg)](./LICENSE)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D22.0.0-brightgreen.svg)](https://nodejs.org/)
[![Downloads](https://img.shields.io/npm/dm/@atus-code/atus-code.svg)](https://www.npmjs.com/package/@atus-code/atus-code)

<a href="https://trendshift.io/repositories/15287" target="_blank"><img src="https://trendshift.io/api/badge/repositories/15287" alt="atuscode%2Fatus-code | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>

**An open-source AI agent that lives in your terminal.**

<a href="https://atuscode.github.io/atus-code-docs/zh/users/overview">中文</a> |
<a href="https://atuscode.github.io/atus-code-docs/de/users/overview">Deutsch</a> |
<a href="https://atuscode.github.io/atus-code-docs/fr/users/overview">français</a> |
<a href="https://atuscode.github.io/atus-code-docs/ja/users/overview">日本語</a> |
<a href="https://atuscode.github.io/atus-code-docs/ru/users/overview">Русский</a> |
<a href="https://atuscode.github.io/atus-code-docs/pt-BR/users/overview">Português (Brasil)</a>

</div>

## 🎉 News

- **2026-04-15**: Qwen OAuth free tier has been discontinued. To continue using atus code, switch to [Alibaba Cloud Coding Plan](https://modelstudio.console.alibabacloud.com/?tab=coding-plan#/efm/coding-plan-index), [OpenRouter](https://openrouter.ai), [Fireworks AI](https://app.fireworks.ai), or bring your own API key. Run `atus auth` to configure.

- **2026-04-13**: Qwen OAuth free tier policy update: daily quota adjusted to 100 requests/day (from 1,000).

- **2026-04-02**: Qwen3.6-Plus is now live! Get an API key from [Alibaba Cloud ModelStudio](https://modelstudio.console.alibabacloud.com/ap-southeast-1?tab=doc#/doc/?type=model&url=2840914_2&modelId=qwen3.6-plus) to access it through the OpenAI-compatible API.

- **2026-02-16**: Qwen3.5-Plus is now live!

## Why atus code?

atus code is an open-source AI agent for the terminal, optimized for Qwen series models. It helps you understand large codebases, automate tedious work, and ship faster.

- **Multi-protocol, flexible providers**: use OpenAI / Anthropic / Gemini-compatible APIs, [Alibaba Cloud Coding Plan](https://modelstudio.console.alibabacloud.com/?tab=coding-plan#/efm/coding-plan-index), [OpenRouter](https://openrouter.ai), [Fireworks AI](https://app.fireworks.ai), or bring your own API key.
- **Open-source, co-evolving**: both the framework and the Qwen3-Coder model are open-source—and they ship and evolve together.
- **Agentic workflow, feature-rich**: rich built-in tools (Skills, SubAgents) for a full agentic workflow and a Claude Code-like experience.
- **Terminal-first, IDE-friendly**: built for developers who live in the command line, with optional integration for VS Code, Zed, and JetBrains IDEs.

![](https://gw.alicdn.com/imgextra/i1/O1CN01D2DviS1wwtEtMwIzJ_!!6000000006373-2-tps-1600-900.png)

## Installation

### Quick Install (Recommended)

#### Linux / macOS

```bash
curl -fsSL https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-atus-standalone.sh | bash
```

#### Windows

```powershell
irm https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-atus-standalone.ps1 | iex
```

> **Note**: It's recommended to restart your terminal after installation to ensure environment variables take effect.

### Manual Installation

#### Prerequisites

Make sure you have Node.js 22 or later installed. Download it from [nodejs.org](https://nodejs.org/en/download).

#### NPM

```bash
npm install -g @atus-code/atus-code@latest
```

#### Homebrew (macOS, Linux)

```bash
brew install atus-code
```

## Quick Start

```bash
# Start atus code (interactive)
atus

# Then, in the session:
/help
/auth
```

On first use, you'll be prompted to sign in. You can run `/auth` anytime to switch authentication methods.

Example prompts:

```text
What does this project do?
Explain the codebase structure.
Help me refactor this function.
Generate unit tests for this module.
```

<details>
<summary>Click to watch a demo video</summary>

<video src="https://cloud.video.taobao.com/vod/HLfyppnCHplRV9Qhz2xSqeazHeRzYtG-EYJnHAqtzkQ.mp4" controls>
Your browser does not support the video tag.
</video>

</details>

## 🦞 Use atus code for Coding Tasks in Claw

Copy the prompt below and paste it into your agent:

```
Use atus code as a coding agent. First, fetch and read this skill reference:
https://raw.githubusercontent.com/atuscode/atus-code/refs/heads/main/.atus-code/skills/atus-code-claw/SKILL.md
Then follow the instructions inside to install, authenticate, and use atus code via acpx for all coding tasks.
```

## Authentication

atus code supports the following authentication methods:

- **API Key (recommended)**: use an API key from Alibaba Cloud Model Studio ([Beijing](https://bailian.console.aliyun.com/) / [intl](https://modelstudio.console.alibabacloud.com/)) or any supported provider (OpenAI, Anthropic, Google GenAI, and other compatible endpoints).
- **Atus Proxy (multi-provider)**: subscribe to [Atus Proxy](https://atus.hostclube.com/v1) for a single API key that works across 6 upstream providers (poolside, novita, agnes, opengitlawb, vanchin, routeway) plus all NVIDIA NIM models. Recommended for teams that want one key for many models.
- **Coding Plan**: subscribe to the Alibaba Cloud Coding Plan ([Beijing](https://bailian.console.aliyun.com/cn-beijing?tab=coding-plan#/efm/coding-plan-index) / [intl](https://modelstudio.console.alibabacloud.com/?tab=coding-plan#/efm/coding-plan-index)) for a fixed monthly fee with higher quotas.

> ⚠️ **Qwen OAuth was discontinued on April 15, 2026.** If you were previously using Qwen OAuth, please switch to one of the methods above. Run `atus` and then `/auth` to reconfigure.

#### API Key (recommended)

Use an API key to connect to Alibaba Cloud Model Studio or any supported provider. Supports multiple protocols:

- **OpenAI-compatible**: Alibaba Cloud ModelStudio, ModelScope, OpenAI, OpenRouter, and other OpenAI-compatible providers
- **Anthropic**: Claude models
- **Google GenAI**: Gemini models

The **recommended** way to configure models and providers is by editing `~/.atus-code/settings.json` (create it if it doesn't exist). This file lets you define all available models, API keys, and default settings in one place.

##### Quick Setup in 3 Steps

**Step 1:** Create or edit `~/.atus-code/settings.json`

Here is a complete example:

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "qwen3.6-plus",
        "name": "qwen3.6-plus",
        "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "description": "Qwen3-Coder via Dashscope",
        "envKey": "DASHSCOPE_API_KEY"
      }
    ]
  },
  "env": {
    "DASHSCOPE_API_KEY": "sk-xxxxxxxxxxxxx"
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "qwen3.6-plus"
  }
}
```

**Step 2:** Understand each field

| Field                        | What it does                                                                                                                          |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `modelProviders`             | Declares which models are available and how to connect to them. Keys like `openai`, `anthropic`, `gemini` represent the API protocol. |
| `modelProviders[].id`        | The model ID sent to the API (e.g. `qwen3.6-plus`, `gpt-4o`).                                                                         |
| `modelProviders[].envKey`    | The name of the environment variable that holds your API key.                                                                         |
| `modelProviders[].baseUrl`   | The API endpoint URL (required for non-default endpoints).                                                                            |
| `env`                        | A fallback place to store API keys (lowest priority; prefer `.env` files or `export` for sensitive keys).                             |
| `security.auth.selectedType` | The protocol to use on startup (`openai`, `anthropic`, `gemini`, `vertex-ai`).                                                        |
| `model.name`                 | The default model to use when atus code starts.                                                                                       |

**Step 3:** Start atus code — your configuration takes effect automatically:

```bash
atus
```

Use the `/model` command at any time to switch between all configured models.

##### Using Atus Proxy (multi-provider)

[Atus Proxy](https://atus.hostclube.com/v1) is the recommended multi-provider gateway bundled with this CLI. One API key gives you access to 6 upstream providers and 130+ models:

| Provider    | Models | Speed    | Cost     |
| ----------- | ------ | -------- | -------- |
| poolside    | 2      | ~0.5s    | paid     |
| novita      | 7 free | 0.9-1.5s | **free** |
| agnes       | 5      | 0.8-13s  | mixed    |
| opengitlawb | 1      | ~2.9s    | free     |
| vanchin     | 1      | ~3s      | free     |
| nvidia NIM  | 120+   | 11-30s   | varies   |

**Recommended free starter models**:

| Model id               | Provider    | Speed | Notes                      |
| ---------------------- | ----------- | ----- | -------------------------- |
| `baidu/cobuddy`        | novita      | ~0.9s | fast, free, good for code  |
| `minimax/minimax-m3`   | opengitlawb | ~2.9s | free, high quality         |
| `poolside/laguna-xs.2` | poolside    | ~0.5s | ultra-fast, paid but cheap |

Create your API key at <https://atus.hostclube.com>, then add to `~/.atus-code/settings.json`:

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "baidu/cobuddy",
        "name": "baidu/cobuddy",
        "baseUrl": "https://atus.hostclube.com/v1",
        "description": "Atus Proxy — fast free coder model",
        "envKey": "ATUS_PROXY_KEY"
      }
    ]
  },
  "env": { "ATUS_PROXY_KEY": "atus-sk-xxxxxxxxxxxxx" },
  "security": { "auth": { "selectedType": "openai" } },
  "model": { "name": "baidu/cobuddy" }
}
```

Or just export the key in your shell:

```bash
export ATUS_PROXY_KEY="atus-sk-xxxxxxxxxxxxx"
```

> 💡 The base URL is `https://atus.hostclube.com/v1` — that's all the proxy
> needs. The same key works for all models, just change the `id` in
> `modelProviders.openai[0].id`.

##### More Examples

<details>
<summary>Coding Plan (Alibaba Cloud ModelStudio) — fixed monthly fee, higher quotas</summary>

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "qwen3.6-plus",
        "name": "qwen3.6-plus (Coding Plan)",
        "baseUrl": "https://coding.dashscope.aliyuncs.com/v1",
        "description": "qwen3.6-plus from ModelStudio Coding Plan",
        "envKey": "BAILIAN_CODING_PLAN_API_KEY"
      },
      {
        "id": "qwen3.5-plus",
        "name": "qwen3.5-plus (Coding Plan)",
        "baseUrl": "https://coding.dashscope.aliyuncs.com/v1",
        "description": "qwen3.5-plus with thinking enabled from ModelStudio Coding Plan",
        "envKey": "BAILIAN_CODING_PLAN_API_KEY",
        "generationConfig": {
          "extra_body": {
            "enable_thinking": true
          }
        }
      },
      {
        "id": "glm-4.7",
        "name": "glm-4.7 (Coding Plan)",
        "baseUrl": "https://coding.dashscope.aliyuncs.com/v1",
        "description": "glm-4.7 with thinking enabled from ModelStudio Coding Plan",
        "envKey": "BAILIAN_CODING_PLAN_API_KEY",
        "generationConfig": {
          "extra_body": {
            "enable_thinking": true
          }
        }
      },
      {
        "id": "kimi-k2.5",
        "name": "kimi-k2.5 (Coding Plan)",
        "baseUrl": "https://coding.dashscope.aliyuncs.com/v1",
        "description": "kimi-k2.5 with thinking enabled from ModelStudio Coding Plan",
        "envKey": "BAILIAN_CODING_PLAN_API_KEY",
        "generationConfig": {
          "extra_body": {
            "enable_thinking": true
          }
        }
      }
    ]
  },
  "env": {
    "BAILIAN_CODING_PLAN_API_KEY": "sk-xxxxxxxxxxxxx"
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "qwen3.6-plus"
  }
}
```

> Subscribe to the Coding Plan and get your API key at [Alibaba Cloud ModelStudio(Beijing)](https://bailian.console.aliyun.com/cn-beijing?tab=coding-plan#/efm/coding-plan-index) or [Alibaba Cloud ModelStudio(intl)](https://modelstudio.console.alibabacloud.com/?tab=coding-plan#/efm/coding-plan-index).

</details>

<details>
<summary>Multiple providers (OpenAI + Anthropic + Gemini)</summary>

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "gpt-4o",
        "name": "GPT-4o",
        "envKey": "OPENAI_API_KEY",
        "baseUrl": "https://api.openai.com/v1"
      }
    ],
    "anthropic": [
      {
        "id": "claude-sonnet-4-20250514",
        "name": "Claude Sonnet 4",
        "envKey": "ANTHROPIC_API_KEY"
      }
    ],
    "gemini": [
      {
        "id": "gemini-2.5-pro",
        "name": "Gemini 2.5 Pro",
        "envKey": "GEMINI_API_KEY"
      }
    ]
  },
  "env": {
    "OPENAI_API_KEY": "sk-xxxxxxxxxxxxx",
    "ANTHROPIC_API_KEY": "sk-ant-xxxxxxxxxxxxx",
    "GEMINI_API_KEY": "AIzaxxxxxxxxxxxxx"
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "gpt-4o"
  }
}
```

</details>

<details>
<summary>Enable thinking mode (for supported models like qwen3.5-plus)</summary>

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "qwen3.5-plus",
        "name": "qwen3.5-plus (thinking)",
        "envKey": "DASHSCOPE_API_KEY",
        "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "generationConfig": {
          "extra_body": {
            "enable_thinking": true
          }
        }
      }
    ]
  },
  "env": {
    "DASHSCOPE_API_KEY": "sk-xxxxxxxxxxxxx"
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "qwen3.5-plus"
  }
}
```

</details>

> **Tip:** You can also set API keys via `export` in your shell or `.env` files, which take higher priority than `settings.json` → `env`. See the [authentication guide](https://atuscode.github.io/atus-code-docs/en/users/configuration/auth/) for full details.

> **Security note:** Never commit API keys to version control. The `~/.atus-code/settings.json` file is in your home directory and should stay private.

#### Local Model Setup (Ollama / vLLM)

You can also run models locally — no API key or cloud account needed. This is not an authentication method; instead, configure your local model endpoint in `~/.atus-code/settings.json` using the `modelProviders` field.

Set `generationConfig.contextWindowSize` inside the matching provider entry
and adjust it to the context length configured on your local server.

<details>
<summary>Ollama setup</summary>

1. Install Ollama from [ollama.com](https://ollama.com/)
2. Pull a model: `ollama pull qwen3:32b`
3. Configure `~/.atus-code/settings.json`:

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "qwen3:32b",
        "name": "Qwen3 32B (Ollama)",
        "baseUrl": "http://localhost:11434/v1",
        "description": "Qwen3 32B running locally via Ollama",
        "generationConfig": {
          "contextWindowSize": 131072
        }
      }
    ]
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "qwen3:32b"
  }
}
```

</details>

<details>
<summary>vLLM setup</summary>

1. Install vLLM: `pip install vllm`
2. Start the server: `vllm serve Qwen/Qwen3-32B`
3. Configure `~/.atus-code/settings.json`:

```json
{
  "modelProviders": {
    "openai": [
      {
        "id": "Qwen/Qwen3-32B",
        "name": "Qwen3 32B (vLLM)",
        "baseUrl": "http://localhost:8000/v1",
        "description": "Qwen3 32B running locally via vLLM",
        "generationConfig": {
          "contextWindowSize": 131072
        }
      }
    ]
  },
  "security": {
    "auth": {
      "selectedType": "openai"
    }
  },
  "model": {
    "name": "Qwen/Qwen3-32B"
  }
}
```

</details>

## Usage

As an open-source terminal agent, you can use atus code in five primary ways:

1. Interactive mode (terminal UI)
2. Headless mode (scripts, CI)
3. IDE integration (VS Code, Zed)
4. SDKs (TypeScript, Python, Java)
5. Daemon mode — `atus serve` exposes ACP over HTTP+SSE so multiple clients share one agent (experimental)

#### Interactive mode

```bash
cd your-project/
atus
```

Run `atus` in your project folder to launch the interactive terminal UI. Use `@` to reference local files (for example `@src/main.ts`).

#### Headless mode

```bash
cd your-project/
atus -p "your question"
```

Use `-p` to run atus code without the interactive UI—ideal for scripts, automation, and CI/CD. Learn more: [Headless mode](https://atuscode.github.io/atus-code-docs/en/users/features/headless).

#### IDE integration

Use atus code inside your editor (VS Code, Zed, and JetBrains IDEs):

- [Use in VS Code](https://atuscode.github.io/atus-code-docs/en/users/integration-vscode/)
- [Use in Zed](https://atuscode.github.io/atus-code-docs/en/users/integration-zed/)
- [Use in JetBrains IDEs](https://atuscode.github.io/atus-code-docs/en/users/integration-jetbrains/)

#### Daemon mode (`atus serve`, experimental)

```bash
cd your-project/
atus serve
# → atus serve listening on http://127.0.0.1:4170 (mode=http-bridge)
```

Run atus code as a local HTTP daemon so IDE plugins, web UIs, CI scripts and custom CLIs all share **one** agent session over HTTP+SSE — instead of each spawning their own subprocess. Loopback bind has no auth by default (set `ATUS_SERVER_TOKEN` to enable bearer auth even on loopback); remote binds (`--hostname 0.0.0.0`) **require** a token — boot refuses without one. See:

- [Daemon mode user guide](https://atuscode.github.io/atus-code-docs/en/users/atus-serve)
- [HTTP protocol reference](https://atuscode.github.io/atus-code-docs/en/developers/atus-serve-protocol)
- [DaemonClient TypeScript quickstart](https://atuscode.github.io/atus-code-docs/en/developers/examples/daemon-client-quickstart)

#### SDKs

Build on top of atus code with the available SDKs:

- TypeScript: [Use the atus code SDK](./packages/sdk-typescript/README.md)
- Python: [Use the Python SDK](./packages/sdk-python/README.md)
- Java: [Use the Java SDK](./packages/sdk-java/atuscode/README.md)

Python SDK example:

```python
import asyncio

from atus_code_sdk import is_sdk_result_message, query


async def main() -> None:
    result = query(
        "Summarize the repository layout.",
        {
            "cwd": "/path/to/project",
            "path_to_qwen_executable": "atus",
        },
    )

    async for message in result:
        if is_sdk_result_message(message):
            print(message["result"])


asyncio.run(main())
```

## Commands & Shortcuts

### Session Commands

- `/help` - Display available commands
- `/clear` - Clear conversation history
- `/compress` - Compress history to save tokens
- `/stats` - Show current session information
- `/bug` - Submit a bug report
- `/exit` or `/quit` - Exit atus code

### Keyboard Shortcuts

- `Ctrl+C` - Cancel current operation
- `Ctrl+D` - Exit (on empty line)
- `Up/Down` - Navigate command history

> Learn more about [Commands](https://atuscode.github.io/atus-code-docs/en/users/features/commands/)
>
> **Tip**: In YOLO mode (`--yolo`), vision switching happens automatically without prompts when images are detected. Learn more about [Approval Mode](https://atuscode.github.io/atus-code-docs/en/users/features/approval-mode/)

## Configuration

atus code can be configured via `settings.json`, environment variables, and CLI flags.

| File                         | Scope         | Description                                                                             |
| ---------------------------- | ------------- | --------------------------------------------------------------------------------------- |
| `~/.atus-code/settings.json` | User (global) | Applies to all your atus code sessions. **Recommended for `modelProviders` and `env`.** |
| `.atus-code/settings.json`   | Project       | Applies only when running atus code in this project. Overrides user settings.           |

The most commonly used top-level fields in `settings.json`:

| Field                        | Description                                                                                          |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- |
| `modelProviders`             | Define available models per protocol (`openai`, `anthropic`, `gemini`, `vertex-ai`).                 |
| `env`                        | Fallback environment variables (e.g. API keys). Lower priority than shell `export` and `.env` files. |
| `security.auth.selectedType` | The protocol to use on startup (e.g. `openai`).                                                      |
| `model.name`                 | The default model to use when atus code starts.                                                      |

> See the [Authentication](#api-key-flexible) section above for complete `settings.json` examples, and the [settings reference](https://atuscode.github.io/atus-code-docs/en/users/configuration/settings/) for all available options.

## Benchmark Results

### Terminal-Bench Performance

| Agent     | Model              | Accuracy |
| --------- | ------------------ | -------- |
| atus code | Qwen3-Coder-480A35 | 37.5%    |
| atus code | Qwen3-Coder-30BA3B | 31.3%    |

## Ecosystem

Looking for a graphical interface?

- [**AionUi**](https://github.com/iOfficeAI/AionUi) A modern GUI for command-line AI tools including atus code
- [**Gemini CLI Desktop**](https://github.com/Piebald-AI/gemini-cli-desktop) A cross-platform desktop/web/mobile UI for atus code

## Troubleshooting

If you encounter issues, check the [troubleshooting guide](https://atuscode.github.io/atus-code-docs/en/users/support/troubleshooting/).

**Common issues:**

- **`Qwen OAuth free tier was discontinued on 2026-04-15`**: Qwen OAuth is no longer available. Run `atus` → `/auth` and switch to API Key or Coding Plan. See the [Authentication](#authentication) section above for setup instructions.

To report a bug from within the CLI, run `/bug` and include a short title and repro steps.

## Connect with Us

- Discord: https://discord.gg/RN7tqZCeDK
- Dingtalk: https://qr.dingtalk.com/action/joingroup?code=v1,k1,+FX6Gf/ZDlTahTIRi8AEQhIaBlqykA0j+eBKKdhLeAE=&_dt_no_comment=1&origin=1

## Acknowledgments

This project is based on [Google Gemini CLI](https://github.com/google-gemini/gemini-cli). We acknowledge and appreciate the excellent work of the Gemini CLI team. Our main contribution focuses on parser-level adaptations to better support Atus-Coder models.
