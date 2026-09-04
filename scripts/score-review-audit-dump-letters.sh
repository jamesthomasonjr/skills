#!/usr/bin/env bash
# Replay recorded review-audit dump letters. No live audit agents.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec python3 "${ROOT_DIR}/scripts/score-review-audit-dump-letters.py" "$@"
