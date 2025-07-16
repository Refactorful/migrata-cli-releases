#!/bin/sh

set -e

REPO="Refactorful/migrata-cli-releases"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="migrata"
TMP_DIR="$(mktemp -d)"

# Detect OS
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  linux)
    PLATFORM="linux"
    ;;
  darwin)
    PLATFORM="osx"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64)
    ARCH_SUFFIX="x64"
    ;;
  arm64|aarch64)
    ARCH_SUFFIX="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

ASSET_NAME="${BINARY_NAME}-${PLATFORM}-${ARCH_SUFFIX}"

echo "Detected platform: $PLATFORM-$ARCH_SUFFIX"
echo "Fetching latest release..."

# Construct the download URL using the new format
VERSION="v0.0.1"
# VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | sed -n 's/.*"tag_name": "\(.*\)",.*/\1/p')
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${ASSET_NAME}"

echo "Downloading from $DOWNLOAD_URL"
curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/$ASSET_NAME"
chmod +x "$TMP_DIR/$ASSET_NAME"

# macOS codesign + quarantine fix
if [ "$PLATFORM" = "osx" ]; then
  echo "Removing quarantine and signing binary..."
  xattr -d com.apple.quarantine "$TMP_DIR/$ASSET_NAME" 2>/dev/null || true
  codesign --sign - --force --deep "$TMP_DIR/$ASSET_NAME" 2>/dev/null || true
fi

echo "Installing to $INSTALL_DIR/$BINARY_NAME (requires sudo)"
sudo mv "$TMP_DIR/$ASSET_NAME" "$INSTALL_DIR/$BINARY_NAME"

echo "Installed successfully: $(command -v $BINARY_NAME)"
$BINARY_NAME --version || true
