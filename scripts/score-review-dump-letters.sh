#!/usr/bin/env bash
# Replay recorded review-sample dump letters. No live review agents.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec python3 "${ROOT_DIR}/scripts/score-review-dump-letters.py" "$@"
