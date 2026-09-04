#!/usr/bin/env bash
# Verify the review-audit dump-letter scorer: house fixtures pass, mutations fail.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCORER="${ROOT_DIR}/scripts/score-review-audit-dump-letters.sh"
CHANGE_REVIEW_TEST="${ROOT_DIR}/scripts/test-score-review-dump-letters.sh"

if [ ! -x "${SCORER}" ]; then
  echo "Expected executable scorer: ${SCORER}" >&2
  exit 1
fi

echo "== house audit fixtures must pass =="
"${SCORER}"

echo "== change-review dump letters must still pass (GREEN table unmoved) =="
"${CHANGE_REVIEW_TEST}"

tmp="$(mktemp -d "${TMPDIR:-/tmp}/review-audit-dump-score.XXXXXX")"
cleanup() {
  rm -rf "${tmp}"
}
trap cleanup EXIT

cp -R "${ROOT_DIR}/fixtures/review-audit" "${tmp}/review-audit"

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

echo "== leftover finding dump must not pass Follow-ups parking =="
python3 - "${tmp}/review-audit/letters/leftover-as-finding-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["has_follow_ups_leftovers"] = True
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "leftover Follow-ups parking" "${SCORER}" --sample-dir "${tmp}/review-audit"
cp "${ROOT_DIR}/fixtures/review-audit/letters/leftover-as-finding-green.json" \
  "${tmp}/review-audit/letters/leftover-as-finding-green.json"

echo "== scope dump must not pass a comparison =="
python3 - "${tmp}/review-audit/letters/codebase-scope-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["used_review_scope"] = True
case["dump"]["comparison"] = "git diff $(git merge-base HEAD origin/main)...HEAD"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "scope became a comparison" "${SCORER}" --sample-dir "${tmp}/review-audit"
cp "${ROOT_DIR}/fixtures/review-audit/letters/codebase-scope-green.json" \
  "${tmp}/review-audit/letters/codebase-scope-green.json"

echo "== primer dump must not pass a planted orient seat =="
python3 - "${tmp}/review-audit/letters/parent-held-primer-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["dump"]["required_seats"] = ["orient-repo"]
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "planted orient seat" "${SCORER}" --sample-dir "${tmp}/review-audit"

echo "== cases must cite a live README letter =="
python3 - "${tmp}/review-audit/letters/leftover-as-finding-green.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    case = json.load(f)
case["letter"] = "GREEN leftover is a numbered finding (renamed, not in README)"
with open(path, "w", encoding="utf-8") as f:
    json.dump(case, f, indent=2)
    f.write("\n")
PY
fail_scorer "unknown letter heading" "${SCORER}" --sample-dir "${tmp}/review-audit"

echo "score-review-audit-dump-letters test passed"
