# Uninstall

Your uninstall method depends on how you installed the CLI.

## Method 1: Using npx

npx runs packages from a temporary cache without a permanent installation. To "uninstall" the CLI, you must clear this cache, which will remove atus-code and any other packages previously executed with npx.

The npx cache is a directory named `_npx` inside your main npm cache folder. You can find your npm cache path by running `npm config get cache`.

**For macOS / Linux**

```bash
# The path is typically ~/.npm/_npx
rm -rf "$(npm config get cache)/_npx"
```

**For Windows**

_Command Prompt_

```cmd
:: The path is typically %LocalAppData%\npm-cache\_npx
rmdir /s /q "%LocalAppData%\npm-cache\_npx"
```

_PowerShell_

```powershell
# The path is typically $env:LocalAppData\npm-cache\_npx
Remove-Item -Path (Join-Path $env:LocalAppData "npm-cache\_npx") -Recurse -Force
```

## Method 2: Using npm (Global Install)

If you installed the CLI globally (e.g. `npm install -g @atus-code/atus-code`), use the `npm uninstall` command with the `-g` flag to remove it.

```bash
npm uninstall -g @atus-code/atus-code
```

This command completely removes the package from your system.

## Method 3: Standalone Install

If you installed via the standalone installer (`curl ... | bash` or `irm ... | iex`), use the dedicated uninstall script.

**Linux / macOS**

```bash
curl -fsSL https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/uninstall-atus-standalone.sh | bash
```

**Windows**

```powershell
irm https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/uninstall-atus-standalone.ps1 | iex
```

The uninstaller removes the standalone runtime, generated `atus` wrapper, and installer-managed PATH changes. Your atus code configuration (`~/.atus-code`) is preserved by default.
