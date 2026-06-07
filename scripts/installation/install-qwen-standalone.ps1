# Atus Code Windows hosted PowerShell entrypoint.
# Pairs with install-atus-standalone.bat: this shim downloads the .bat into TEMP,
# verifies its checksum, and runs it with forwarded arguments.
#
# PowerShell (runs in current session, atus available immediately):
#   irm https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-atus-standalone.ps1 | iex
#
# cmd.exe (runs in current session, atus available immediately):
#   curl -fsSL https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-atus-standalone.bat -o %TEMP%\install-atus.bat && %TEMP%\install-atus.bat
#
# To pin a specific release, set $env:ATUS_INSTALL_VERSION before invoking,
# e.g. $env:ATUS_INSTALL_VERSION = 'vX.Y.Z'. This is equivalent to passing
# --version vX.Y.Z to install-atus-standalone.bat directly.
#
# To point this shim at a non-production hosted endpoint (staging buckets,
# private mirrors), set $env:ATUS_INSTALLER_BAT_URL to the alternate .bat URL.
# The override is required to be HTTPS so a misconfigured value can't silently
# downgrade the download channel. The downstream .bat continues to honor
# ATUS_INSTALL_BASE_URL for archive resolution.
#
# By default the matching SHA256SUMS file is read from the same hosted
# directory as the .bat. Set $env:ATUS_INSTALLER_CHECKSUMS_URL to override it
# when testing a custom installer endpoint.

$ErrorActionPreference = 'Stop'

function Download-File {
    param([string]$Url, [string]$OutFile)
    $prevProgressPreference = $global:ProgressPreference
    $global:ProgressPreference = 'SilentlyContinue'
    try {
        if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
            curl.exe --connect-timeout 15 --max-time 300 --retry 2 -sSfLo $OutFile $Url
            if ($LASTEXITCODE -ne 0) {
                throw "curl.exe download failed (exit code $LASTEXITCODE)"
            }
            return
        }
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing -MaximumRedirection 10 -TimeoutSec 300
    } finally {
        $global:ProgressPreference = $prevProgressPreference
    }
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

function Get-AtusInstallBinDir {
    if (-not [string]::IsNullOrEmpty($env:ATUS_INSTALL_BIN_DIR)) {
        return $env:ATUS_INSTALL_BIN_DIR
    }

    return Join-Path (Get-AtusInstallBase) 'bin'
}

function Get-CurrentCmdShimStatePath {
    return Join-Path (Get-AtusInstallBase) 'current-cmd-shim.txt'
}

function Save-CurrentCmdPathShim {
    param([string]$ShimPath)

    if ([string]::IsNullOrEmpty($ShimPath)) {
        return
    }

    try {
        $statePath = Get-CurrentCmdShimStatePath
        New-Item -ItemType Directory -Path (Split-Path -Parent $statePath) -Force | Out-Null
        [IO.File]::WriteAllText($statePath, $ShimPath, [Text.UTF8Encoding]::new($false))
    } catch {
        # Best-effort cleanup hint only. The installer still works if this fails.
    }
}

function Update-CurrentSessionPath {
    param([string]$BinDir)

    if ([string]::IsNullOrEmpty($BinDir)) {
        return
    }

    $entries = @($env:Path -split ';' | Where-Object { -not [string]::IsNullOrEmpty($_) })
    foreach ($entry in $entries) {
        if ([string]::Equals($entry, $BinDir, [StringComparison]::OrdinalIgnoreCase)) {
            return
        }
    }

    $env:Path = (@($BinDir) + $entries) -join ';'
}

function Get-ParentProcessName {
    try {
        $current = Get-CimInstance Win32_Process -Filter "ProcessId = $PID" -ErrorAction Stop
        if ($null -eq $current -or $null -eq $current.ParentProcessId) {
            return $null
        }
        $parent = Get-CimInstance Win32_Process -Filter "ProcessId = $($current.ParentProcessId)" -ErrorAction Stop
        if ($null -eq $parent) {
            return $null
        }
        return $parent.Name
    } catch {
        return $null
    }
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

function Test-PathContainsDirectory {
    param([string]$PathValue, [string]$Directory)

    $target = Get-NormalizedPath -PathValue $Directory
    if ([string]::IsNullOrEmpty($target)) {
        return $false
    }

    foreach ($entry in @($PathValue -split ';')) {
        $normalizedEntry = Get-NormalizedPath -PathValue $entry
        if ([string]::Equals($normalizedEntry, $target, [StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }

    return $false
}

function Test-WritableDirectory {
    param([string]$Directory)

    if ([string]::IsNullOrEmpty($Directory)) {
        return $false
    }

    if (-not (Test-Path -LiteralPath $Directory -PathType Container)) {
        return $false
    }

    $probe = Join-Path $Directory ('.atus-code-write-test-' + [IO.Path]::GetRandomFileName())
    try {
        [IO.File]::WriteAllText($probe, '')
        Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue
        return $true
    } catch {
        Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue
        return $false
    }
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

function Test-SystemManagedPathDirectory {
    param([string]$Directory)

    $normalizedDirectory = Get-NormalizedPath -PathValue $Directory
    return (
        -not [string]::IsNullOrEmpty($normalizedDirectory) -and
        $normalizedDirectory -match '\\Microsoft\\WindowsApps$'
    )
}

function Install-CurrentCmdPathShim {
    param([string]$AtusCommand, [string]$PathValue)

    $pathEntries = @($PathValue -split ';' | Where-Object { -not [string]::IsNullOrEmpty($_) })
    $candidates = [System.Collections.Generic.List[string]]::new()
    $preferredDirectories = @()

    if (-not [string]::IsNullOrEmpty($env:APPDATA)) {
        $preferredDirectories += Join-Path $env:APPDATA 'npm'
    }
    if (-not [string]::IsNullOrEmpty($env:USERPROFILE)) {
        $preferredDirectories += Join-Path $env:USERPROFILE '.bun\bin'
    }

    foreach ($preferredDirectory in $preferredDirectories) {
        $preferredNormalized = Get-NormalizedPath -PathValue $preferredDirectory
        foreach ($entry in $pathEntries) {
            $entryNormalized = Get-NormalizedPath -PathValue $entry
            if ([string]::Equals($entryNormalized, $preferredNormalized, [StringComparison]::OrdinalIgnoreCase)) {
                Add-PathCandidate -Candidates $candidates -Directory $entry
            }
        }
    }

    $userRoot = Get-NormalizedPath -PathValue $env:USERPROFILE
    foreach ($entry in $pathEntries) {
        if (Test-SystemManagedPathDirectory -Directory $entry) {
            continue
        }
        $entryNormalized = Get-NormalizedPath -PathValue $entry
        if (
            -not [string]::IsNullOrEmpty($userRoot) -and
            -not [string]::IsNullOrEmpty($entryNormalized) -and
            $entryNormalized.StartsWith($userRoot, [StringComparison]::OrdinalIgnoreCase)
        ) {
            Add-PathCandidate -Candidates $candidates -Directory $entry
        }
    }

    foreach ($candidate in $candidates) {
        if (-not (Test-WritableDirectory -Directory $candidate)) {
            continue
        }

        $shimPath = Join-Path $candidate 'atus.cmd'
        if (Test-Path -LiteralPath $shimPath -PathType Leaf) {
            $existingShim = Get-Content -LiteralPath $shimPath -Raw -ErrorAction SilentlyContinue
            if ($existingShim -notmatch 'Atus Code current-session shim') {
                continue
            }
        }

        $shim = "@echo off`r`nREM Atus Code current-session shim. Generated by install-atus-standalone.ps1.`r`ncall `"$AtusCommand`" %*`r`n"
        # Write to a sibling temp file first, then atomically rename so a partial
        # write (process killed, disk full) cannot leave a half-written shim on
        # PATH.
        $shimTempPath = "$shimPath.new"
        [IO.File]::WriteAllText($shimTempPath, $shim, [Text.UTF8Encoding]::new($false))
        Move-Item -LiteralPath $shimTempPath -Destination $shimPath -Force
        Save-CurrentCmdPathShim -ShimPath $shimPath
        return $shimPath
    }

    return $null
}

function Update-CurrentShell {
    $atusInstallBinDir = Get-AtusInstallBinDir
    $atusCommandPath = Join-Path $atusInstallBinDir 'atus.cmd'
    if (-not (Test-Path -LiteralPath $atusCommandPath -PathType Leaf)) {
        return
    }

    if ($env:ATUS_NO_MODIFY_PATH -eq '1') {
        return
    }

    $inheritedPath = $env:Path
    Update-CurrentSessionPath -BinDir $atusInstallBinDir

    $parentProcessName = Get-ParentProcessName
    if ($parentProcessName -ieq 'cmd.exe') {
        if (Test-PathContainsDirectory -PathValue $inheritedPath -Directory $atusInstallBinDir) {
            return
        }

        $shimPath = Install-CurrentCmdPathShim -AtusCommand $atusCommandPath -PathValue $inheritedPath
        if (-not [string]::IsNullOrEmpty($shimPath)) {
            return
        }
        return
    }
}

$atusDefaultInstallerUrl = 'https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-atus-standalone.bat'
$atusDefaultChecksumsUrl = 'https://atus-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/SHA256SUMS'
if ([string]::IsNullOrEmpty($env:ATUS_INSTALLER_BAT_URL)) {
    $atusInstallerUrl = $atusDefaultInstallerUrl
} else {
    if ($env:ATUS_INSTALLER_BAT_URL -notmatch '^https://') {
        Write-Error "ATUS_INSTALLER_BAT_URL must start with https://"
        exit 1
    }
    $atusInstallerUrl = $env:ATUS_INSTALLER_BAT_URL
}

if ([string]::IsNullOrEmpty($env:ATUS_INSTALLER_CHECKSUMS_URL)) {
    if ($atusInstallerUrl -eq $atusDefaultInstallerUrl) {
        $atusChecksumsUrl = $atusDefaultChecksumsUrl
    } else {
        $atusChecksumsUrl = [Uri]::new([Uri]$atusInstallerUrl, 'SHA256SUMS').AbsoluteUri
    }
} else {
    if ($env:ATUS_INSTALLER_CHECKSUMS_URL -notmatch '^https://') {
        Write-Error "ATUS_INSTALLER_CHECKSUMS_URL must start with https://"
        exit 1
    }
    $atusChecksumsUrl = $env:ATUS_INSTALLER_CHECKSUMS_URL
}

$atusInstallerName = [IO.Path]::GetFileName(([Uri]$atusInstallerUrl).AbsolutePath)
if ([string]::IsNullOrEmpty($atusInstallerName)) {
    $atusInstallerName = 'install-atus-standalone.bat'
}
if ([string]::IsNullOrEmpty($env:TEMP)) {
    Write-Error "TEMP environment variable is not set. Please set TEMP to a writable directory."
    exit 1
}
# Use a cryptographically random staging filename so a same-user attacker cannot
# pre-stage a malicious .bat at a predictable path and race the verify/execute
# window between Get-FileHash and `& $atusInstallerPath`.
$atusStagingSuffix = [IO.Path]::GetRandomFileName()
$atusInstallerPath = Join-Path $env:TEMP "atus-installer-$atusStagingSuffix.bat"
$atusChecksumsPath = Join-Path $env:TEMP "atus-installation-SHA256SUMS-$atusStagingSuffix"

try {
    Download-File -Url $atusInstallerUrl -OutFile $atusInstallerPath
} catch {
    Write-Error "Failed to download Atus Code installer from ${atusInstallerUrl}: $($_.Exception.Message)"
    exit 1
}

try {
    Download-File -Url $atusChecksumsUrl -OutFile $atusChecksumsPath
} catch {
    Remove-Item -LiteralPath $atusInstallerPath -Force -ErrorAction SilentlyContinue
    Write-Error "Failed to download Atus Code installer checksums from ${atusChecksumsUrl}: $($_.Exception.Message)"
    exit 1
}

$atusExpectedHash = $null
foreach ($atusChecksumLine in Get-Content -LiteralPath $atusChecksumsPath) {
    if ($atusChecksumLine -match '^([0-9a-fA-F]{64})\s+\*?(.+)$') {
        if ($Matches[2] -eq $atusInstallerName) {
            $atusExpectedHash = $Matches[1].ToLowerInvariant()
            break
        }
    }
}
if ([string]::IsNullOrEmpty($atusExpectedHash)) {
    Remove-Item -LiteralPath $atusInstallerPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $atusChecksumsPath -Force -ErrorAction SilentlyContinue
    Write-Error "Checksum entry for ${atusInstallerName} not found in ${atusChecksumsUrl}"
    exit 1
}

$atusActualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $atusInstallerPath).Hash.ToLowerInvariant()
if ($atusActualHash -ne $atusExpectedHash) {
    Remove-Item -LiteralPath $atusInstallerPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $atusChecksumsPath -Force -ErrorAction SilentlyContinue
    Write-Error "Checksum mismatch for ${atusInstallerName}: expected ${atusExpectedHash}, got ${atusActualHash}."
    exit 1
}

$atusInstallerExitCode = 0
$atusPreviousParentPowerShell = $env:ATUS_INSTALLER_PARENT_POWERSHELL
try {
    $env:ATUS_INSTALLER_PARENT_POWERSHELL = '1'
    & $atusInstallerPath @args
    $atusInstallerExitCode = $LASTEXITCODE
} finally {
    if ($null -eq $atusPreviousParentPowerShell) {
        Remove-Item Env:\ATUS_INSTALLER_PARENT_POWERSHELL -ErrorAction SilentlyContinue
    } else {
        $env:ATUS_INSTALLER_PARENT_POWERSHELL = $atusPreviousParentPowerShell
    }
    Remove-Item -LiteralPath $atusInstallerPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $atusChecksumsPath -Force -ErrorAction SilentlyContinue
}

if ($atusInstallerExitCode -ne 0) {
    exit $atusInstallerExitCode
}

Update-CurrentShell
