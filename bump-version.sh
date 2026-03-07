#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>" >&2
    echo "Example: $0 1.2.0" >&2
    exit 1
fi

VERSION="$1"

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: version must be in semver format (e.g. 1.2.0)" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sed -i '' "s/^version = \".*\"/version = \"$VERSION\"/" "$SCRIPT_DIR/pyproject.toml"
sed -i '' "s/^VERSION = \".*\"/VERSION = \"$VERSION\"/" "$SCRIPT_DIR/pystr"

echo "Bumped version to $VERSION in pyproject.toml and pystr"
