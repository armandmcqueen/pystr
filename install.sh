#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYSTR_PATH="$SCRIPT_DIR/pystr"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/pystr"

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Install pystr to ~/.local/bin"
    echo ""
    echo "Options:"
    echo "  --uninstall  Remove pystr"
    echo "  -h, --help   Show this help message"
}

# Parse arguments
UNINSTALL=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Handle uninstall
if [ "$UNINSTALL" = true ]; then
    if [ -e "$INSTALL_PATH" ]; then
        echo "Removing $INSTALL_PATH..."
        rm -f "$INSTALL_PATH"
        echo "Uninstalled pystr"
    else
        echo "pystr not found at $INSTALL_PATH"
    fi
    exit 0
fi

# Create install directory if needed
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Remove existing installation
if [ -e "$INSTALL_PATH" ]; then
    echo "Removing existing installation..."
    rm -f "$INSTALL_PATH"
fi

# Install by copying
echo "Installing pystr to $INSTALL_PATH..."
cp "$PYSTR_PATH" "$INSTALL_PATH"
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
