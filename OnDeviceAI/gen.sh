#!/bin/zsh
set -euo pipefail

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "XcodeGen not found. Install with: brew install xcodegen" >&2
  exit 1
fi

xcodegen generate
