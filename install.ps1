# Requires PowerShell 5+
param([string]$Version)

$ErrorActionPreference = 'Stop'

$REPO = "Refactorful/migrata-cli-releases"
$INSTALL_DIR = "$env:ProgramFiles\Migrata"
$BINARY_NAME = "migrata.exe"
$TMP_DIR = Join-Path $env:TEMP "migrata_tmp"
$DEST = "$INSTALL_DIR\$BINARY_NAME"

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
if ($Version) {
    $VERSION = "v" + $Version.TrimStart('v')
    Write-Host "Installing version: $VERSION"
} else {
    Write-Host "Fetching latest release..."
    $VERSION = (Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest").tag_name
}

# Verify the release version exists
try {
    Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/tags/$VERSION" | Out-Null
} catch {
    Write-Host "Error: version $VERSION not found. Check available releases at https://github.com/$REPO/releases" -ForegroundColor Red
    exit 1
}

$DOWNLOAD_URL = "https://github.com/$REPO/releases/download/$VERSION/$ASSET_NAME"

Write-Host "Downloading from $DOWNLOAD_URL"
try {
    Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile "$TMP_DIR\$ASSET_NAME"
} catch {
    Write-Host "Error: failed to download $ASSET_NAME for version $VERSION. It may not exist for this release." -ForegroundColor Red
    exit 1
}

# Create install directory if it doesn't exist
if (!(Test-Path $INSTALL_DIR)) { New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null }

# Remove older executable before installing
if (Test-Path $DEST) {
    Remove-Item $DEST -Force
    Write-Host "Removed old executable: $DEST"
}

Copy-Item "$TMP_DIR\$ASSET_NAME" $DEST -Force

# Add install dir to PATH for current session
$env:PATH = "$INSTALL_DIR;" + $env:PATH
# Persist install dir to user PATH
$currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentUserPath -notlike "*$INSTALL_DIR*") {
    [Environment]::SetEnvironmentVariable("Path", "$INSTALL_DIR;" + $currentUserPath, "User")
    Write-Host "Added $INSTALL_DIR to user PATH. You may need to restart your shell for changes to take effect."
}

# Show version
& $DEST --version

Write-Host "Installed successfully: $DEST"
