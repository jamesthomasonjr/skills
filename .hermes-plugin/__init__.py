import os
from pathlib import Path

PROMOTED_BUCKETS = ("engineering", "productivity")


def _skills_root() -> str:
    """Locate the skills/ tree for either supported install layout.

    - git-clone install: the plugin dir is the repo root, so `.hermes-plugin/`
      and `skills/` are siblings and this resolves `../skills`.
    - flattened install: `skills/` sits next to this module.
    """
    here = os.path.dirname(os.path.realpath(__file__))
    candidates = (
        os.path.realpath(os.path.join(here, "..", "skills")),
        os.path.realpath(os.path.join(here, "skills")),
    )
    for cand in candidates:
        if any(os.path.isdir(os.path.join(cand, b)) for b in PROMOTED_BUCKETS):
            return cand
    raise RuntimeError(
        f"jamesthomasonjr-skills plugin: cannot find the skills/ tree (looked at {candidates})."
    )


def register(ctx):
    root = _skills_root()
    # Only promoted buckets are registered; personal/ and in-progress/ stay out.
    # register_skill requires a pathlib.Path, not a str.
    for bucket in PROMOTED_BUCKETS:
        bucket_dir = os.path.join(root, bucket)
        if not os.path.isdir(bucket_dir):
            continue
        for name in sorted(os.listdir(bucket_dir)):
            skill_md = os.path.join(bucket_dir, name, "SKILL.md")
            if os.path.isfile(skill_md):
                ctx.register_skill(name, Path(skill_md))
