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
cp "${ROOT_DIR}/fixtures/review-sample/letters/isolation-green.json" \
  "${tmp}/review-sample/letters/isolation-green.json"

echo "== pack-core GREEN must not infer core from a synonym =="
python3 - "${tmp}/review-sample/letters/pack-core-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["caller_named_core"] = False
case["dump"]["inferred_core_from"] = "quick"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "pack-core synonym-infer" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/pack-core-green.json" \
  "${tmp}/review-sample/letters/pack-core-green.json"

echo "== skip-product GREEN must not skip onboard =="
python3 - "${tmp}/review-sample/letters/gatherer-skip-product-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["skipped_gatherers"] = [
    {"name": "review-gather-onboard", "reason": "held-product"}
]
case["dump"]["held"] = ["onboard-summary"]
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "skip onboard gatherer" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/gatherer-skip-product-green.json" \
  "${tmp}/review-sample/letters/gatherer-skip-product-green.json"

echo "== leftover Follow-ups GREEN must not take G5 nits / dropped: N =="
python3 - "${tmp}/review-sample/letters/follow-ups-leftover-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["follow_ups_bleed"] = "dropped-n"
case["dump"]["follow_ups_text"] = "unusedFormatCents — src/pricing.js:3\ndropped: 2"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "Follow-ups G5 nits / dropped: N" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/follow-ups-leftover-green.json" \
  "${tmp}/review-sample/letters/follow-ups-leftover-green.json"

echo "== leftover Follow-ups GREEN must not number a leftover =="
python3 - "${tmp}/review-sample/letters/follow-ups-leftover-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["leftover_numbered_as_finding"] = True
case["dump"]["findings"] = [
    {
        "title": "unusedFormatCents",
        "path": "src/pricing.js:3",
        "severity": "P3",
        "leftover": True,
    }
]
case["dump"]["findings_text"] = "[P3] unusedFormatCents — src/pricing.js:3"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "leftover numbered as a finding" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/follow-ups-leftover-green.json" \
  "${tmp}/review-sample/letters/follow-ups-leftover-green.json"

echo "== leftover Follow-ups GREEN must not stuff leftovers into Assessment =="
python3 - "${tmp}/review-sample/letters/follow-ups-leftover-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["leftover_in_assessment"] = True
case["dump"]["assessment"] = (
    "Target is nits-only.diff versus src/. Leftovers unusedFormatCents remain."
)
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "leftover stuffed into Assessment" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/follow-ups-leftover-green.json" \
  "${tmp}/review-sample/letters/follow-ups-leftover-green.json"

echo "== HARNESS-STOP GREEN must not write No findings. =="
python3 - "${tmp}/review-sample/letters/harness-stop-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["has_no_findings"] = True
case["dump"]["text"] += "\nNo findings."
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "HARNESS-STOP empty pass" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/harness-stop-green.json" \
  "${tmp}/review-sample/letters/harness-stop-green.json"

echo "== HARNESS-STOP GREEN must not review inline =="
python3 - "${tmp}/review-sample/letters/harness-stop-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["inline_review"] = True
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "HARNESS-STOP inline" "${SCORER}" --sample-dir "${tmp}/review-sample"
cp "${ROOT_DIR}/fixtures/review-sample/letters/harness-stop-green.json" \
  "${tmp}/review-sample/letters/harness-stop-green.json"

echo "== parent-held scope GREEN must not open a fresh child =="
python3 - "${tmp}/review-sample/letters/scope-parent-held-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["followed_review_scope"] = False
case["dump"]["scope_reader"] = "fresh-child"
case["dump"]["scope_fresh_child"] = True
case["dump"]["parent_held_scope"] = False
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "fresh child for scope" "${SCORER}" --sample-dir "${tmp}/review-sample"

echo "score-review-dump-letters test passed"
