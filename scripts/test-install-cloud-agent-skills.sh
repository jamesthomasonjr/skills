#!/usr/bin/env bash
# Verify the cloud skill installer links skills for both Cursor and Codex homes.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="${ROOT_DIR}/scripts/install-cloud-agent-skills.sh"

tmp_home="$(mktemp -d "${TMPDIR:-/tmp}/cloud-skill-install.XXXXXX")"
cleanup() {
  rm -rf "${tmp_home}"
}
trap cleanup EXIT

export HOME="${tmp_home}"
export CODEX_HOME="${tmp_home}/.codex"
log_file="${tmp_home}/install-cloud-agent-skills-test.log"

supersuit_skill_dir="${HOME}/.cache/cloud-agent-skill-src/supersuit/skills/sample-supersuit"
mkdir -p "${supersuit_skill_dir}"
cat >"${supersuit_skill_dir}/SKILL.md" <<'EOF'
---
name: sample-supersuit
description: sample
---
EOF

"${INSTALLER}" --link-only >"${log_file}"

assert_link() {
  local path="$1"
  if [ ! -L "${path}" ]; then
    echo "Expected symlink: ${path}" >&2
    cat "${log_file}" >&2
    exit 1
  fi
}

assert_link "${HOME}/.cursor/skills/sample-supersuit"
assert_link "${CODEX_HOME}/skills/sample-supersuit"
assert_link "${HOME}/.cursor/skills/debug"
assert_link "${CODEX_HOME}/skills/debug"

echo "install-cloud-agent-skills test passed"
