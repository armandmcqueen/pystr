#!/bin/bash
set -e

INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/pystr"
PYSTR_URL="https://raw.githubusercontent.com/armandmcqueen/pystr/main/pystr"

echo "Installing pystr..."
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "Error: uv is not installed."
    echo ""
    echo "pystr requires uv (a fast Python package manager) to run."
    echo ""
    echo "Install uv by following the instructions at:"
    echo "  https://docs.astral.sh/uv/getting-started/installation/"
    echo ""
    exit 1
fi

# Create install directory if needed
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Download pystr
echo "Downloading pystr..."
curl -fsSL "$PYSTR_URL" -o "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo "Installed $("$INSTALL_PATH" --version 2>&1)"

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "Warning: $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add it by running one of these commands:"
    echo ""
    echo "  # For zsh (default on macOS):"
    echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
    echo ""
    echo "  # For bash:"
    echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
fi
