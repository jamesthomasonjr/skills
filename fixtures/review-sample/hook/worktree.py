"""Workspace helper. Always uses git worktree."""

import subprocess


def ensure_workspace(path):
    subprocess.run(["git", "worktree", "add", path], check=True)
