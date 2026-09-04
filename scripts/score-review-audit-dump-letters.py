#!/usr/bin/env python3
"""Replay recorded review-audit dump fixtures and score GREEN/RED letters."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

PLANTED_SEATS = (
    "catch-me-up",
    "orient-repo",
    "orient-module",
    "orient-function",
)
CHANGE_REVIEW_SEATS = (
    "review-scope",
    "review-blind",
    "review-intent",
    "review-security",
    "review-performance",
    "review-logic",
    "review-regression",
    "review-checklist",
    "review-verify",
)
SCOPE_KINDS = {"path", "module", "codebase"}
PRIMER_HELD = {"onboard-summary", "orient", "orient-repo", "orient-module"}
FINDING_LINE = re.compile(r"\[P[0-3]\]\s+\S.+\s+—\s+\S+:\d+")


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def letter_in_readme(readme: str, letter: str) -> bool:
    for line in readme.splitlines():
        if line.startswith(letter) and (
            len(line) == len(letter) or line[len(letter)] in ": "
        ):
            return True
    return False


def leftover_findings(dump: dict[str, Any]) -> list[dict[str, Any]]:
    found = []
    for item in dump.get("findings") or []:
        if not isinstance(item, dict):
            continue
        if item.get("preexisting") or item.get("leftover_class"):
            found.append(item)
    return found


def numbered_leftover(dump: dict[str, Any]) -> bool:
    findings = leftover_findings(dump)
    if not findings:
        return False
    text = dump.get("text") or ""
    if FINDING_LINE.search(text):
        return True
    return any(item.get("severity") in {"P0", "P1", "P2", "P3"} for item in findings)


def score_leftover_finding(dump: dict[str, Any]) -> tuple[str, str]:
    if dump.get("has_follow_ups_leftovers"):
        return "RED", "leftover parked under Follow-ups"
    if dump.get("dropped_as_gate3"):
        return "RED", "leftover dropped as Gate 3"
    if not numbered_leftover(dump):
        return "RED", "no numbered leftover finding"
    return "GREEN", "leftover is a numbered finding"


def score_scope(dump: dict[str, Any]) -> tuple[str, str]:
    if dump.get("used_review_scope") or dump.get("used_review_regression"):
        return "RED", "codebase turned into a comparison"
    comparison = dump.get("comparison")
    if comparison:
        return "RED", "dump invented a comparison"
    kind = dump.get("scope_kind")
    if kind not in SCOPE_KINDS:
        return "RED", "scope is not path/module/codebase"
    if not dump.get("scope"):
        return "RED", "missing scope"
    return "GREEN", "codebase is a scope"


def score_primer(dump: dict[str, Any]) -> tuple[str, str]:
    planted, reason = score_planted_seat(dump)
    if planted == "RED":
        return planted, reason
    held = set(dump.get("held") or [])
    if not (held & PRIMER_HELD):
        return "RED", "no parent-held primer product"
    if not dump.get("used_held_primer"):
        return "RED", "held primer was not used"
    return "GREEN", "parent-held primer seeded the tour"


def score_planted_seat(dump: dict[str, Any]) -> tuple[str, str]:
    required = list(dump.get("required_seats") or [])
    planted = [name for name in required if name in PLANTED_SEATS]
    if planted:
        return "RED", "planted orient seat: " + ", ".join(planted)
    change = [name for name in required if name in CHANGE_REVIEW_SEATS]
    if change:
        return "RED", "planted change-review seat: " + ", ".join(change)
    return "GREEN", "no planted orient or change-review seats"


def score_change_review_reuse(dump: dict[str, Any]) -> tuple[str, str]:
    if dump.get("applied_gates_md") or dump.get("used_review_verify"):
        return "RED", "change-review reuse"
    if dump.get("dropped_as_gate3"):
        return "RED", "Gate 3 drop on an audit leftover"
    planted, reason = score_planted_seat(dump)
    if planted == "RED" and "change-review" in reason:
        return planted, reason
    if dump.get("used_review_scope") or dump.get("used_review_regression"):
        return "RED", "change-review reuse via comparison seat"
    return "GREEN", "audit stayed off change-review machinery"


SCORERS = {
    "leftover-finding": score_leftover_finding,
    "scope": score_scope,
    "primer": score_primer,
    "planted-seat": score_planted_seat,
    "change-review-reuse": score_change_review_reuse,
}


def load_dump(case: dict[str, Any], case_path: Path) -> dict[str, Any]:
    if "dump" in case:
        dump = case["dump"]
        if not isinstance(dump, dict):
            raise ValueError(f"{case_path.name}: dump must be an object")
        return dump
    dump_path = case.get("dump_path")
    if not dump_path:
        raise ValueError(f"{case_path.name}: need dump or dump_path")
    path = (case_path.parent / dump_path).resolve()
    loaded = load_json(path)
    if not isinstance(loaded, dict):
        raise ValueError(f"{path}: dump file must be an object")
    return loaded


def score_case(
    case: dict[str, Any], case_path: Path, readme: str
) -> tuple[str, str, str]:
    case_id = case.get("id") or case_path.stem
    letter = case.get("letter")
    expected = case.get("expected")
    kind = case.get("score")
    if not letter or not isinstance(letter, str):
        return case_id, "FAIL", "missing letter citation"
    if expected not in {"GREEN", "RED"}:
        return case_id, "FAIL", "expected must be GREEN or RED"
    if not letter.startswith(expected + " "):
        return case_id, "FAIL", "letter heading color does not match expected"
    if not letter_in_readme(readme, letter):
        return case_id, "FAIL", f"letter not in README: {letter}"
    if kind not in SCORERS:
        return case_id, "FAIL", f"unknown score kind: {kind}"
    try:
        dump = load_dump(case, case_path)
    except ValueError as exc:
        return case_id, "FAIL", str(exc)
    scored, reason = SCORERS[kind](dump)
    if scored != expected:
        return case_id, "FAIL", f"expected {expected}, scored {scored} ({reason})"
    return case_id, "PASS", f"{scored} {reason}"


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Score recorded review-audit dump letters against "
            "fixtures/review-audit/README.md. Does not spin live audit agents."
        )
    )
    parser.add_argument(
        "--sample-dir",
        type=Path,
        help="review-audit directory (default: fixtures/review-audit)",
    )
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    repo_root = Path(__file__).resolve().parent.parent
    sample_dir = (
        args.sample_dir.resolve()
        if args.sample_dir
        else repo_root / "fixtures" / "review-audit"
    )
    readme_path = sample_dir / "README.md"
    letters_dir = sample_dir / "letters"
    if not readme_path.is_file():
        print(f"missing README: {readme_path}", file=sys.stderr)
        return 1
    if not letters_dir.is_dir():
        print(f"missing letters dir: {letters_dir}", file=sys.stderr)
        return 1

    readme = readme_path.read_text(encoding="utf-8")
    failures = 0
    cases = sorted(letters_dir.glob("*.json"))
    if not cases:
        print(f"FAIL letters: no JSON cases in {letters_dir}", file=sys.stderr)
        return 1

    for case_path in cases:
        try:
            case = load_json(case_path)
        except json.JSONDecodeError as exc:
            print(f"FAIL {case_path.name}: invalid JSON ({exc})", file=sys.stderr)
            failures += 1
            continue
        if not isinstance(case, dict):
            print(f"FAIL {case_path.name}: case must be an object", file=sys.stderr)
            failures += 1
            continue
        case_id, status, detail = score_case(case, case_path, readme)
        line = f"{status} {case_id}  {detail}"
        print(line, file=sys.stdout if status == "PASS" else sys.stderr)
        if status != "PASS":
            failures += 1

    if failures:
        print(f"{failures} failed", file=sys.stderr)
        return 1
    print(f"{len(cases)} letters passed")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
