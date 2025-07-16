# Requires PowerShell 5+
$ErrorActionPreference = 'Stop'

$REPO = "Refactorful/migrata-cli-releases"
$INSTALL_DIR = "$env:ProgramFiles\migrata"
$BINARY_NAME = "migrata.exe"
$TMP_DIR = Join-Path $env:TEMP "migrata_tmp"

if (Test-Path $TMP_DIR) { Remove-Item $TMP_DIR -Recurse -Force }
New-Item -ItemType Directory -Path $TMP_DIR | Out-Null

# Detect architecture
switch ($env:PROCESSOR_ARCHITECTURE) {
    "AMD64" { $ARCH_SUFFIX = "x64" }
    "ARM64" { $ARCH_SUFFIX = "arm64" }
    default {
        Write-Error "Unsupported architecture: $env:PROCESSOR_ARCHITECTURE"
        exit 1
    }
}

$ASSET_NAME = "migrata-win-$ARCH_SUFFIX.exe"

# Fetch latest release tag from GitHub API
$VERSION = (Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest").tag_name

$DOWNLOAD_URL = "https://github.com/$REPO/releases/download/$VERSION/$ASSET_NAME"

Write-Host "Downloading from $DOWNLOAD_URL"
Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile "$TMP_DIR\$ASSET_NAME"

# Create install directory if it doesn't exist
if (!(Test-Path $INSTALL_DIR)) { New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null }

Copy-Item "$TMP_DIR\$ASSET_NAME" "$INSTALL_DIR\$BINARY_NAME" -Force

# Add install dir to PATH for current session
$env:PATH = "$INSTALL_DIR;" + $env:PATH

# Show version
& "$INSTALL_DIR\$BINARY_NAME" --version

Write-Host "Installed successfully: $INSTALL_DIR\$BINARY_NAME"
