#!/bin/sh

set -e

REPO="Refactorful/migrata-cli-releases"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="migrata"
TMP_DIR="$(mktemp -d)"
DEST="${INSTALL_DIR}/${BINARY_NAME}"

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

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Fetching latest release..."
  VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | sed -n 's/.*"tag_name": "\(.*\)",.*/\1/p')
  if [ -z "$VERSION" ]; then
    echo "Error: could not determine the latest release. Check your network connection."
    exit 1
  fi
else
  VERSION="v${VERSION#v}"
  echo "Installing version: $VERSION"
fi

# Verify the release version exists
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/${REPO}/releases/tags/${VERSION}")
if [ "$HTTP_CODE" != "200" ]; then
  echo "Error: version ${VERSION} not found. Check available releases at https://github.com/${REPO}/releases"
  exit 1
fi

# Construct the download URL using the new format
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${ASSET_NAME}"

echo "Downloading from $DOWNLOAD_URL"
curl -fL "$DOWNLOAD_URL" -o "$TMP_DIR/$ASSET_NAME"
chmod +x "$TMP_DIR/$ASSET_NAME"

# macOS codesign + quarantine fix
if [ "$PLATFORM" = "osx" ]; then
  echo "Removing quarantine and signing binary..."
  xattr -d com.apple.quarantine "$TMP_DIR/$ASSET_NAME" 2>/dev/null || true
  codesign --sign - --force --deep "$TMP_DIR/$ASSET_NAME" 2>/dev/null || true
fi

echo "Installing to $DEST (requires sudo)"

# Remove older executable before installing
if [ -f "$DEST" ]; then
  echo "Removing old executable: $DEST"
  sudo rm -f "$DEST"
fi

sudo mv "$TMP_DIR/$ASSET_NAME" "$DEST"

echo "Installed successfully: $(command -v $BINARY_NAME)"
$BINARY_NAME --version || true
