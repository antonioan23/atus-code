# Atus Code standalone uninstaller.
# Removes files owned by install-atus-standalone.bat/.ps1 and preserves user
# config by default.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -c "irm https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/uninstall-atus-standalone.ps1 | iex"
#
# Set $env:ATUS_UNINSTALL_PURGE = '1' (or pass -Purge) to also remove the
# installer source marker at %USERPROFILE%\.atus-code\source.json. Other Atus Code
# config and auth files are preserved.

param(
    [switch]$Purge,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Output @"
Atus Code standalone uninstaller.

Usage:
  uninstall-atus-standalone.ps1 [-Purge] [-Help]

Options:
  -Purge   Also remove %USERPROFILE%\.atus-code\source.json (same as
           ATUS_UNINSTALL_PURGE=1).
  -Help    Show this message and exit.
"@
    exit 0
}

if ($Purge) {
    $env:ATUS_UNINSTALL_PURGE = '1'
}

function Write-Info {
    param([string]$Message)
    Write-Output "INFO: $Message"
}

function Write-Success {
    param([string]$Message)
    Write-Output "SUCCESS: $Message"
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Output "WARNING: $Message"
}

function Get-AtusInstallBase {
    if (-not [string]::IsNullOrEmpty($env:ATUS_INSTALL_ROOT)) {
        return $env:ATUS_INSTALL_ROOT
    }

    if (-not [string]::IsNullOrEmpty($env:LOCALAPPDATA)) {
        return Join-Path $env:LOCALAPPDATA 'atus-code'
    }

    return Join-Path (Join-Path $env:USERPROFILE 'AppData\Local') 'atus-code'
}

function Get-AtusInstallDir {
    if (-not [string]::IsNullOrEmpty($env:ATUS_INSTALL_LIB_DIR)) {
        return $env:ATUS_INSTALL_LIB_DIR
    }

    return Join-Path (Get-AtusInstallBase) 'atus-code'
}

function Get-AtusInstallBinDir {
    if (-not [string]::IsNullOrEmpty($env:ATUS_INSTALL_BIN_DIR)) {
        return $env:ATUS_INSTALL_BIN_DIR
    }

    return Join-Path (Get-AtusInstallBase) 'bin'
}

function Get-CurrentCmdShimStatePath {
    return Join-Path (Get-AtusInstallBase) 'current-cmd-shim.txt'
}

function Get-NormalizedPath {
    param([string]$PathValue)

    if ([string]::IsNullOrEmpty($PathValue)) {
        return $null
    }

    $trimmed = $PathValue.Trim().Trim('"')
    if ([string]::IsNullOrEmpty($trimmed)) {
        return $null
    }

    try {
        return [IO.Path]::GetFullPath($trimmed).TrimEnd('\')
    } catch {
        return $trimmed.TrimEnd('\')
    }
}

function Test-PathMatches {
    param([string]$Left, [string]$Right)

    $leftPath = Get-NormalizedPath -PathValue $Left
    $rightPath = Get-NormalizedPath -PathValue $Right
    if ([string]::IsNullOrEmpty($leftPath) -or [string]::IsNullOrEmpty($rightPath)) {
        return $false
    }

    return [string]::Equals($leftPath, $rightPath, [StringComparison]::OrdinalIgnoreCase)
}

function Test-AtusStandaloneInstallDir {
    param([string]$InstallDir)

    if (-not (Test-Path -LiteralPath $InstallDir -PathType Container)) {
        return $false
    }

    $manifestPath = Join-Path $InstallDir 'manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        return $false
    }

    try {
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    } catch {
        return $false
    }

    if ($manifest.name -ne '@atus-code/atus-code') {
        return $false
    }

    if ([string]$manifest.target -notmatch '^win-(x64|arm64)$') {
        return $false
    }

    if (-not (Test-Path -LiteralPath (Join-Path $InstallDir 'bin\atus.cmd') -PathType Leaf)) {
        return $false
    }

    if (-not (Test-Path -LiteralPath (Join-Path $InstallDir 'node\node.exe') -PathType Leaf)) {
        return $false
    }

    return $true
}

function Remove-UserPathEntry {
    param([string]$BinDir)

    $target = Get-NormalizedPath -PathValue $BinDir
    if ([string]::IsNullOrEmpty($target)) {
        return
    }

    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ([string]::IsNullOrEmpty($userPath)) {
        return
    }

    $kept = New-Object System.Collections.Generic.List[string]
    $removed = $false
    foreach ($entry in @($userPath -split ';')) {
        if ([string]::IsNullOrEmpty($entry)) {
            continue
        }

        if (Test-PathMatches -Left $entry -Right $target) {
            $removed = $true
            continue
        }

        [void]$kept.Add($entry)
    }

    if ($removed) {
        [Environment]::SetEnvironmentVariable('Path', ($kept -join ';'), 'User')
        Write-Success "Removed $BinDir from user PATH."
    }

    $current = New-Object System.Collections.Generic.List[string]
    foreach ($entry in @($env:Path -split ';')) {
        if ([string]::IsNullOrEmpty($entry)) {
            continue
        }
        if (-not (Test-PathMatches -Left $entry -Right $target)) {
            [void]$current.Add($entry)
        }
    }
    $env:Path = $current -join ';'
}

function Add-PathCandidate {
    param(
        [System.Collections.Generic.List[string]]$Candidates,
        [string]$Directory
    )

    $normalizedDirectory = Get-NormalizedPath -PathValue $Directory
    if ([string]::IsNullOrEmpty($normalizedDirectory)) {
        return
    }

    foreach ($candidate in $Candidates) {
        $normalizedCandidate = Get-NormalizedPath -PathValue $candidate
        if ([string]::Equals($normalizedCandidate, $normalizedDirectory, [StringComparison]::OrdinalIgnoreCase)) {
            return
        }
    }

    [void]$Candidates.Add($Directory.Trim().Trim('"'))
}

function Remove-CurrentCmdPathShimFile {
    param([string]$ShimPath)

    if ([string]::IsNullOrEmpty($ShimPath)) {
        return
    }

    if (-not (Test-Path -LiteralPath $ShimPath -PathType Leaf)) {
        return
    }

    $existingShim = Get-Content -LiteralPath $ShimPath -Raw -ErrorAction SilentlyContinue
    if ($existingShim -notmatch 'Atus Code current-session shim') {
        return
    }

    Remove-Item -LiteralPath $ShimPath -Force -ErrorAction SilentlyContinue
    Write-Success "Removed current cmd.exe atus shim: $ShimPath"
}

function Remove-RecordedCurrentCmdPathShim {
    $statePath = Get-CurrentCmdShimStatePath
    if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
        return
    }

    foreach ($shimPath in Get-Content -LiteralPath $statePath -ErrorAction SilentlyContinue) {
        Remove-CurrentCmdPathShimFile -ShimPath $shimPath
    }

    Remove-Item -LiteralPath $statePath -Force -ErrorAction SilentlyContinue
}

function Remove-CurrentCmdPathShim {
    Remove-RecordedCurrentCmdPathShim

    $candidates = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in @($env:Path -split ';')) {
        if (-not [string]::IsNullOrEmpty($entry)) {
            Add-PathCandidate -Candidates $candidates -Directory $entry
        }
    }

    if (-not [string]::IsNullOrEmpty($env:LOCALAPPDATA)) {
        Add-PathCandidate -Candidates $candidates -Directory (Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps')
    }
    if (-not [string]::IsNullOrEmpty($env:APPDATA)) {
        Add-PathCandidate -Candidates $candidates -Directory (Join-Path $env:APPDATA 'npm')
    }
    if (-not [string]::IsNullOrEmpty($env:USERPROFILE)) {
        Add-PathCandidate -Candidates $candidates -Directory (Join-Path $env:USERPROFILE '.bun\bin')
    }

    foreach ($candidate in $candidates) {
        $shimPath = Join-Path $candidate 'atus.cmd'
        Remove-CurrentCmdPathShimFile -ShimPath $shimPath
    }
}

function Remove-InstallWrapper {
    param([string]$InstallDir, [string]$BinDir)

    $wrapperPath = Join-Path $BinDir 'atus.cmd'
    if (-not (Test-Path -LiteralPath $wrapperPath -PathType Leaf)) {
        return
    }

    $wrapper = Get-Content -LiteralPath $wrapperPath -Raw -ErrorAction SilentlyContinue
    $targetCommand = Join-Path (Join-Path $InstallDir 'bin') 'atus.cmd'
    if (
        $wrapper -notmatch [regex]::Escape($targetCommand) -and
        $wrapper -notmatch 'Atus Code current-session shim'
    ) {
        Write-WarningMessage "$wrapperPath does not point at this standalone install; skipping."
        return
    }

    Remove-Item -LiteralPath $wrapperPath -Force
    Write-Success "Removed $wrapperPath"
}

function Remove-EmptyDirectory {
    param([string]$Directory)

    if ([string]::IsNullOrEmpty($Directory)) {
        return
    }

    if (-not (Test-Path -LiteralPath $Directory -PathType Container)) {
        return
    }

    try {
        Remove-Item -LiteralPath $Directory -Force -ErrorAction Stop
    } catch {
        return
    }
}

function Remove-SourceMarker {
    if ([string]::IsNullOrEmpty($env:USERPROFILE)) {
        return
    }

    $atusDir = Join-Path $env:USERPROFILE '.atus-code'
    $sourceJson = Join-Path $atusDir 'source.json'

    if ($env:ATUS_UNINSTALL_PURGE -ne '1') {
        Write-Info "Preserving $atusDir (set ATUS_UNINSTALL_PURGE=1 to remove source.json)."
        return
    }

    if (Test-Path -LiteralPath $sourceJson -PathType Leaf) {
        Remove-Item -LiteralPath $sourceJson -Force
        Write-Success "Removed $sourceJson"
    }

    Remove-EmptyDirectory -Directory $atusDir
}

Write-Output "Atus Code Standalone Uninstaller"
Write-Output ""

$installBase = Get-AtusInstallBase
$installDir = Get-AtusInstallDir
$installBinDir = Get-AtusInstallBinDir
$installWasManaged = Test-AtusStandaloneInstallDir -InstallDir $installDir

if ($installWasManaged) {
    Remove-CurrentCmdPathShim
    Remove-Item -LiteralPath $installDir -Recurse -Force
    Write-Success "Removed $installDir"
} elseif (Test-Path -LiteralPath $installDir) {
    Write-WarningMessage "$installDir exists but is not a Atus Code standalone install; skipping."
} else {
    Write-Info "No standalone runtime found at $installDir."
}

if ($installWasManaged) {
    Remove-InstallWrapper -InstallDir $installDir -BinDir $installBinDir
} else {
    Write-Info "Leaving $(Join-Path $installBinDir 'atus.cmd') unchanged because no managed standalone runtime was removed."
}

Remove-UserPathEntry -BinDir $installBinDir
Remove-SourceMarker
if ([string]::IsNullOrEmpty($env:ATUS_INSTALL_BIN_DIR)) {
    Remove-EmptyDirectory -Directory $installBinDir
}
if ([string]::IsNullOrEmpty($env:ATUS_INSTALL_ROOT)) {
    Remove-EmptyDirectory -Directory $installBase
}

Write-Success "Atus Code standalone install removed."
