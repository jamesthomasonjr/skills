#!/usr/bin/env bash
# Verify the review dump-letter scorer: house fixtures pass, mutations fail.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCORER="${ROOT_DIR}/scripts/score-review-dump-letters.sh"

if [ ! -x "${SCORER}" ]; then
  echo "Expected executable scorer: ${SCORER}" >&2
  exit 1
fi

echo "== house fixtures must pass =="
"${SCORER}"

tmp="$(mktemp -d "${TMPDIR:-/tmp}/review-dump-score.XXXXXX")"
cleanup() {
  rm -rf "${tmp}"
}
trap cleanup EXIT

cp -R "${ROOT_DIR}/fixtures/review-sample" "${tmp}/review-sample"

fail_scorer() {
  local label="$1"
  shift
  if "$@" >"${tmp}/out.txt" 2>"${tmp}/err.txt"; then
    echo "Expected scorer to fail: ${label}" >&2
    cat "${tmp}/out.txt" >&2
    cat "${tmp}/err.txt" >&2
    exit 1
  fi
  echo "ok fail: ${label}"
}

echo "== isolation dump must not pass a playbook =="
python3 - "${tmp}/review-sample/letters/isolation-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["window"].append("playbook")
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "isolation playbook leak" "${SCORER}" --sample-dir "${tmp}/review-sample"
# restore for later mutations
cp "${ROOT_DIR}/fixtures/review-sample/letters/isolation-green.json" \
  "${tmp}/review-sample/letters/isolation-green.json"

echo "== GREEN table must stay nine locked rows =="
python3 - "${tmp}/review-sample/README.md" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
needle = "| `changes/host-gap.diff` | Host has not advertised `native-worktree` yet | Residual-or-empty — not a numbered finding |\n"
extra = "| `changes/new-green.diff` | Invented leftover | Finding: unused helper |\n"
if needle not in text:
    raise SystemExit("host-gap GREEN row missing from copied README")
path.write_text(text.replace(needle, needle + extra, 1), encoding="utf-8")
PY
fail_scorer "widened GREEN table" "${SCORER}" --sample-dir "${tmp}/review-sample"
# restore README
cp "${ROOT_DIR}/fixtures/review-sample/README.md" "${tmp}/review-sample/README.md"

echo "== cases must cite a live README letter =="
python3 - "${tmp}/review-sample/letters/isolation-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["letter"] = "GREEN isolation do-not-pass (renamed, not in README)"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "unknown letter heading" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/isolation-green.json" \
  "${tmp}/review-sample/letters/isolation-green.json"

echo "== expected color must match scored dump =="
python3 - "${tmp}/review-sample/letters/isolation-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["expected"] = "RED"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "expected/score mismatch" "${SCORER}" --sample-dir "${tmp}/review-sample"

echo "score-review-dump-letters test passed"
