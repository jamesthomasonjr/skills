#!/usr/bin/env bash
# Install jeighty/supersuit and this repo's promoted skills into ~/.cursor/skills.
# Intended for Cursor Cloud Agent environment setup. Safe to re-run.
set -euo pipefail

SKILLS_DIR="${HOME}/.cursor/skills"
SRC_DIR="${HOME}/.cursor/skill-src"
SUPERSUIT_URL="https://github.com/jeighty/supersuit"
SUPERSUIT_SLUG="jeighty/supersuit"
JT_SKILLS_URL="https://github.com/jamesthomasonjr/skills"
JT_SKILLS_SLUG="jamesthomasonjr/skills"

mkdir -p "${SKILLS_DIR}" "${SRC_DIR}"

abs_path() {
  (cd "$1" && pwd)
}

is_jt_skills_checkout() {
  local dir="${1:-}"
  [[ -n "${dir}" && -d "${dir}" ]] || return 1
  [[ -d "${dir}/skills/engineering" && -d "${dir}/skills/productivity" ]] || return 1
  [[ -f "${dir}/scripts/install-cloud-agent-skills.sh" ]] || return 1
  return 0
}

looks_like_remote() {
  local url="${1:-}"
  local slug="$2"
  [[ "${url}" == *"${slug}"* ]]
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

  if [[ -d "${dest}/.git" ]]; then
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

  if [[ -e "${dest}" ]]; then
    rm -rf "${dest}"
  fi
  clone_repo "${slug}" "${url}" "${dest}"
}

# Print each linked skill name (one per line) for the summary.
link_skill_dirs() {
  local src_root="$1"
  local dest_dir="$2"
  local skill_dir name dest src_abs

  shopt -s nullglob
  for skill_dir in "${src_root}"/*/; do
    [[ -f "${skill_dir}/SKILL.md" ]] || continue
    name="$(basename "${skill_dir}")"
    src_abs="$(abs_path "${skill_dir}")"
    dest="${dest_dir}/${name}"
    if [[ -e "${dest}" && ! -L "${dest}" ]]; then
      rm -rf "${dest}"
    fi
    ln -sfn "${src_abs}" "${dest}"
    printf '%s\n' "${name}"
  done
  shopt -u nullglob
}

echo "Installing Cloud Agent skills into ${SKILLS_DIR}"

supersuit_src="${SRC_DIR}/supersuit"
echo "Obtaining ${SUPERSUIT_SLUG} -> ${supersuit_src}"
ensure_cached_checkout "${SUPERSUIT_SLUG}" "${SUPERSUIT_URL}" "${supersuit_src}"

if jt_src="$(find_jt_skills_workspace)"; then
  echo "Using current workspace for ${JT_SKILLS_SLUG}: ${jt_src}"
else
  jt_src="${SRC_DIR}/skills"
  echo "Obtaining ${JT_SKILLS_SLUG} -> ${jt_src}"
  ensure_cached_checkout "${JT_SKILLS_SLUG}" "${JT_SKILLS_URL}" "${jt_src}"
fi

mapfile -t supersuit_linked < <(link_skill_dirs "${supersuit_src}/skills" "${SKILLS_DIR}")
mapfile -t jt_linked < <(
  {
    link_skill_dirs "${jt_src}/skills/engineering" "${SKILLS_DIR}"
    link_skill_dirs "${jt_src}/skills/productivity" "${SKILLS_DIR}"
  }
)

echo
echo "Linked ${#supersuit_linked[@]} supersuit skill(s):"
if [[ ${#supersuit_linked[@]} -eq 0 ]]; then
  echo "  (none)"
else
  printf '  %s\n' "${supersuit_linked[@]}"
fi

echo "Linked ${#jt_linked[@]} promoted JT skill(s) (engineering + productivity):"
if [[ ${#jt_linked[@]} -eq 0 ]]; then
  echo "  (none)"
else
  printf '  %s\n' "${jt_linked[@]}"
fi

echo "Skipped personal/ and in-progress/."
echo "Done. Skills are in ${SKILLS_DIR}"
