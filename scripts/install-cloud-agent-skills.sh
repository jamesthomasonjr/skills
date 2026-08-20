#!/usr/bin/env bash
# Install jeighty/supersuit and this repo's promoted skills into ~/.cursor/skills.
# Intended for Cursor Cloud Agent environment setup. Safe to re-run.
# Compatible with bash 3.2 (macOS /usr/bin/env bash).
set -euo pipefail

SKILLS_DIR="${HOME}/.cursor/skills"
SRC_DIR="${HOME}/.cursor/skill-src"
SUPERSUIT_URL="https://github.com/jeighty/supersuit"
SUPERSUIT_SLUG="jeighty/supersuit"
JT_SKILLS_URL="https://github.com/jamesthomasonjr/skills"
JT_SKILLS_SLUG="jamesthomasonjr/skills"

LINK_ONLY=0

usage() {
  cat <<'EOF'
Usage: install-cloud-agent-skills.sh [--link-only]

  (default)   Clone/refresh checkouts, then symlink skills into ~/.cursor/skills.
  --link-only Relink from existing checkouts. Used as Cloud Agent start so a
              feature-branch checkout picks up promoted skills added after the
              Build snapshot. Does not fetch or clone.
EOF
}

# bash 3.2 + set -u treats a bare "$@" with no args as unbound.
if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    case "${arg}" in
      --link-only) LINK_ONLY=1 ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: ${arg}" >&2
        usage >&2
        exit 2
        ;;
    esac
  done
fi

mkdir -p "${SKILLS_DIR}" "${SRC_DIR}"

abs_path() {
  (cd "$1" && pwd)
}

is_jt_skills_checkout() {
  local dir="${1:-}"
  [ -n "${dir}" ] && [ -d "${dir}" ] || return 1
  [ -d "${dir}/skills/engineering" ] && [ -d "${dir}/skills/productivity" ] || return 1
  [ -f "${dir}/scripts/install-cloud-agent-skills.sh" ] || return 1
  return 0
}

looks_like_remote() {
  local url="${1:-}"
  local slug="$2"
  case "${url}" in
    *"${slug}"*) return 0 ;;
    *) return 1 ;;
  esac
}

find_jt_skills_workspace() {
  local script_dir repo_root toplevel candidate remote
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$(cd "${script_dir}/.." && pwd)"

  if is_jt_skills_checkout "${repo_root}"; then
    printf '%s\n' "${repo_root}"
    return 0
  fi

  for candidate in "${PWD}" /workspace; do
    if is_jt_skills_checkout "${candidate}"; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done

  if toplevel="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    if is_jt_skills_checkout "${toplevel}"; then
      printf '%s\n' "${toplevel}"
      return 0
    fi
    remote="$(git -C "${toplevel}" remote get-url origin 2>/dev/null || true)"
    if looks_like_remote "${remote}" "${JT_SKILLS_SLUG}"; then
      printf '%s\n' "${toplevel}"
      return 0
    fi
  fi

  return 1
}

clone_repo() {
  local slug="$1"
  local url="$2"
  local dest="$3"

  if command -v gh >/dev/null 2>&1; then
    if gh repo clone "${slug}" "${dest}" -- --depth 1; then
      return 0
    fi
    rm -rf "${dest}"
  fi
  git clone --depth 1 "${url}" "${dest}"
}

ensure_cached_checkout() {
  local slug="$1"
  local url="$2"
  local dest="$3"
  local default_ref

  if [ -d "${dest}/.git" ]; then
    git -C "${dest}" fetch --depth 1 origin
    if default_ref="$(git -C "${dest}" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)"; then
      git -C "${dest}" reset --hard "${default_ref}"
    elif git -C "${dest}" rev-parse --verify --quiet origin/main >/dev/null; then
      git -C "${dest}" reset --hard origin/main
    else
      git -C "${dest}" reset --hard FETCH_HEAD
    fi
    return 0
  fi

  if [ -e "${dest}" ]; then
    rm -rf "${dest}"
  fi
  clone_repo "${slug}" "${url}" "${dest}"
}

# Append each linked skill name to _linked_names (newline-separated). In-process
# so ln/cd failures abort the script under set -e (no mapfile / process subshell).
_linked_names=""

reset_linked_names() {
  _linked_names=""
}

append_linked_name() {
  if [ -n "${_linked_names}" ]; then
    _linked_names="${_linked_names}
$1"
  else
    _linked_names="$1"
  fi
}

count_linked_names() {
  local names="$1"
  local count=0
  local name
  if [ -z "${names}" ]; then
    printf '%s\n' 0
    return 0
  fi
  while IFS= read -r name || [ -n "${name}" ]; do
    [ -n "${name}" ] || continue
    count=$((count + 1))
  done <<EOF
${names}
EOF
  printf '%s\n' "${count}"
}

print_linked_names() {
  local names="$1"
  local name
  if [ -z "${names}" ]; then
    echo "  (none)"
    return 0
  fi
  while IFS= read -r name || [ -n "${name}" ]; do
    [ -n "${name}" ] || continue
    printf '  %s\n' "${name}"
  done <<EOF
${names}
EOF
}

link_skill_dirs() {
  local src_root="$1"
  local dest_dir="$2"
  local skill_dir name dest src_abs
  local nullglob_was_on=0

  if [ ! -d "${src_root}" ]; then
    echo "Skill source directory not found: ${src_root}" >&2
    return 1
  fi

  if shopt -q nullglob; then
    nullglob_was_on=1
  fi
  shopt -s nullglob
  for skill_dir in "${src_root}"/*/; do
    [ -f "${skill_dir}/SKILL.md" ] || continue
    name="$(basename "${skill_dir}")"
    src_abs="$(abs_path "${skill_dir}")"
    dest="${dest_dir}/${name}"
    if [ -e "${dest}" ] && [ ! -L "${dest}" ]; then
      rm -rf "${dest}"
    fi
    ln -sfn "${src_abs}" "${dest}"
    append_linked_name "${name}"
  done
  if [ "${nullglob_was_on}" -eq 0 ]; then
    shopt -u nullglob
  fi
}

require_checkout() {
  local label="$1"
  local dest="$2"
  if [ ! -d "${dest}" ]; then
    echo "${label} checkout not found at ${dest}" >&2
    echo "Run without --link-only to clone it first." >&2
    return 1
  fi
}

if [ "${LINK_ONLY}" -eq 1 ]; then
  echo "Relinking Cloud Agent skills into ${SKILLS_DIR}"
else
  echo "Installing Cloud Agent skills into ${SKILLS_DIR}"
fi

supersuit_src="${SRC_DIR}/supersuit"
if [ "${LINK_ONLY}" -eq 1 ]; then
  require_checkout "${SUPERSUIT_SLUG}" "${supersuit_src}"
  echo "Using existing ${SUPERSUIT_SLUG} at ${supersuit_src}"
else
  echo "Obtaining ${SUPERSUIT_SLUG} -> ${supersuit_src}"
  ensure_cached_checkout "${SUPERSUIT_SLUG}" "${SUPERSUIT_URL}" "${supersuit_src}"
fi

if jt_src="$(find_jt_skills_workspace)"; then
  echo "Using current workspace for ${JT_SKILLS_SLUG}: ${jt_src}"
elif [ "${LINK_ONLY}" -eq 1 ]; then
  jt_src="${SRC_DIR}/skills"
  require_checkout "${JT_SKILLS_SLUG}" "${jt_src}"
  echo "Using existing ${JT_SKILLS_SLUG} at ${jt_src}"
else
  jt_src="${SRC_DIR}/skills"
  echo "Obtaining ${JT_SKILLS_SLUG} -> ${jt_src}"
  ensure_cached_checkout "${JT_SKILLS_SLUG}" "${JT_SKILLS_URL}" "${jt_src}"
fi

reset_linked_names
link_skill_dirs "${supersuit_src}/skills" "${SKILLS_DIR}"
supersuit_linked="${_linked_names}"

reset_linked_names
link_skill_dirs "${jt_src}/skills/engineering" "${SKILLS_DIR}"
link_skill_dirs "${jt_src}/skills/productivity" "${SKILLS_DIR}"
jt_linked="${_linked_names}"

echo
echo "Linked $(count_linked_names "${supersuit_linked}") supersuit skill(s):"
print_linked_names "${supersuit_linked}"

echo "Linked $(count_linked_names "${jt_linked}") promoted JT skill(s) (engineering + productivity):"
print_linked_names "${jt_linked}"

echo "Skipped personal/ and in-progress/."
echo "Done. Skills are in ${SKILLS_DIR}"
