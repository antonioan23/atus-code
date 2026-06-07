@echo off
REM =============================================================
REM atus-code — start in TEST / dev mode
REM =============================================================
REM Usage:
REM   start-test.bat                      interactive test mode
REM   start-test.bat "your prompt here"   non-interactive (one-shot)
REM   start-test.bat --help               passthrough args
REM
REM What it does:
REM   - isolates state in %TEMP%\atus-test\ (no pollution of ~/.atus-code\)
REM   - enables ATUS_DEBUG=1 + verbose logging
REM   - sets ATUS_LANG=pt-BR
REM   - disables sandbox + update checks (less friction while testing)
REM   - auto-detects the CLI binary (global npm, local node_modules, or PATH)
REM
REM Override the test home:
REM   set ATUS_TEST_HOME=D:\my-test  (before running)
REM =============================================================

setlocal EnableDelayedExpansion

REM --- Test home (isolated from real config) ---
if "%ATUS_TEST_HOME%"=="" set "ATUS_TEST_HOME=%TEMP%\atus-test"
if not exist "%ATUS_TEST_HOME%" mkdir "%ATUS_TEST_HOME%"
if not exist "%ATUS_TEST_HOME%\runtime" mkdir "%ATUS_TEST_HOME%\runtime"

set "ATUS_HOME=%ATUS_TEST_HOME%"
set "ATUS_RUNTIME_DIR=%ATUS_TEST_HOME%\runtime"
set "ATUS_SANDBOX=false"
set "ATUS_DISABLE_UPDATE_CHECK=1"
set "ATUS_SUPPRESS_YOLO_WARNING=1"
set "ATUS_LANG=pt-BR"
set "ATUS_DEBUG=1"
set "ATUS_LOG_LEVEL=debug"
set "NODE_OPTIONS=--enable-source-maps"

REM --- Find the CLI binary ---
set "CLI_BIN="
if exist "%AppData%\npm\atus-code.cmd"            set "CLI_BIN=%AppData%\npm\atus-code.cmd"
if "%CLI_BIN%"=="" if exist "%~dp0node_modules\.bin\atus-code.cmd" set "CLI_BIN=%~dp0node_modules\.bin\atus-code.cmd"
if "%CLI_BIN%"=="" if exist "%~dp0..\node_modules\.bin\atus-code.cmd" set "CLI_BIN=%~dp0..\node_modules\.bin\atus-code.cmd"
if "%CLI_BIN%"=="" set "CLI_BIN=atus-code"

echo.
echo [start-test] ====================================================
echo [start-test]  atus-code  ^(test mode^)
echo [start-test] ====================================================
echo [start-test]  HOME:    !ATUS_TEST_HOME!
echo [start-test]  CLI:     !CLI_BIN!
echo [start-test]  LANG:    !ATUS_LANG!
echo [start-test]  DEBUG:   !ATUS_DEBUG!
echo [start-test]  SANDBOX: !ATUS_SANDBOX!
echo [start-test] ====================================================

REM --- API key check ---
if "%ATUS_PROXY_KEY%"=="" (
    echo [start-test]  ATUS_PROXY_KEY not set. Auth will fail until you set it.
    echo [start-test]    set ATUS_PROXY_KEY=atus-sk-xxxxxxxxxxxxx
) else (
    echo [start-test]  PROXY:   ATUS_PROXY_KEY=***!ATUS_PROXY_KEY:~-4!
)
echo.

REM --- Launch ---
if "%*"=="" (
    REM Interactive test mode
    echo [start-test]  starting interactive mode ^(Ctrl+C to exit^)
    echo.
    "%CLI_BIN%"
) else (
    REM Non-interactive: pass prompt as -p
    echo [start-test]  starting non-interactive mode
    echo.
    "%CLI_BIN%" -p %*
}

endlocal
