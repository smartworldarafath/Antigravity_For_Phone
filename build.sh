#!/usr/bin/env bash
# build.sh - Convenient root wrapper for Antigravity APK builder.
# Usage:
#   bash build.sh                 # Build standard release edition (dist/antigravity.apk)
#   bash build.sh --region-bypass # Build release edition with region bypass (dist/antigravity-region-bypass.apk)
#   bash build.sh --all           # Build both editions and SHA256SUMS.txt

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if command -v python3 >/dev/null 2>&1; then
    exec python3 "$SCRIPT_DIR/build.py" "$@"
else
    exec python "$SCRIPT_DIR/build.py" "$@"
fi
