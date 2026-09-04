#!/usr/bin/env python3
"""Replay recorded review-sample dump fixtures and score GREEN/RED letters."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

FULL_SEATS = [
    "review-blind",
    "review-security",
    "review-performance",
    "review-logic",
    "review-regression",
    "review-checklist",
    "review-intent",
]
CORE_SEATS = ["review-blind", "review-intent", "review-security"]
SPECIALIST_SEATS = [
    "review-security",
    "review-performance",
    "review-logic",
    "review-regression",
    "review-checklist",
]
UNANNOUNCED_ON_CORE = [
    "review-performance",
    "review-logic",
    "review-regression",
    "review-checklist",
]
PRODUCT_GATHERERS = {"review-gather-pr", "review-gather-design"}
PRODUCT_HELD = {"pr-body", "design-excerpt"}
PACK_SYNONYMS = {"quick", "light", "small"}
HOST_PICKS = {"task-nest", "cloud-fan", "harness-stop"}
STOP_PHRASE = re.compile(
    r"cannot open a fresh context|cannot fan|cannot launch|cannot start|launch (?:rejected|failed)",
    re.I,
)
PLANTED_SEAT_NAMES = (
    "catch-me-up",
    "orient-repo",
    "orient-module",
    "orient-function",
)
FORBIDDEN_ISOLATION = {
    "pr-body",
    "commit-message",
    "onboard",
    "orient",
    "catch-me-up",
    "orient-repo",
    "orient-module",
    "orient-function",
    "gatherer-product",
    "gatherer-transcript",
    "implementing-turn",
    "green-table",
    "fixture-protocol",
    "scoring-notes",
    "playbook",
    "owasp",
    "cwe",
    "reconstruct-blob",
}


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def extract_green_table(readme: str) -> str:
    rows: list[str] = []
    in_table = False
    seen_header = False
    for line in readme.splitlines(keepends=True):
        if line.startswith("| Diff |"):
            seen_header = True
            continue
        if seen_header and line.startswith("|---"):
            in_table = True
            continue
        if in_table:
            if line.startswith("|"):
                rows.append(line)
            else:
                break
    return "".join(rows)


def letter_in_readme(readme: str, letter: str) -> bool:
    for line in readme.splitlines():
        if line.startswith(letter) and (
            len(line) == len(letter) or line[len(letter)] in ": "
        ):
            return True
    return False


def score_isolation(dump: dict[str, Any]) -> tuple[str, str]:
    if dump.get("seat") != "review-blind":
        return "RED", "isolation is scored on the blind seat dump"
    window = list(dump.get("window") or [])
    reads = list(dump.get("reads") or [])
    text = dump.get("text") or ""
    if "comparison" not in window:
        return "RED", "blind window missing comparison"
    leaked = [item for item in window if item in FORBIDDEN_ISOLATION]
    if leaked:
        return "RED", "do-not-pass leaked " + ", ".join(leaked)
    for item in reads:
        lowered = item.lower()
        if any(token in lowered for token in FORBIDDEN_ISOLATION):
            return "RED", f"blind child fetched {item}"
    for name in PLANTED_SEAT_NAMES:
        if name in window or re.search(rf"\b{re.escape(name)}\b", text):
            return "RED", f"planted {name} on seat"
    return "GREEN", "blind window is comparison-only"


def score_pack(dump: dict[str, Any]) -> tuple[str, str]:
    announced = list(dump.get("announced_seats") or [])
    verify = list(dump.get("verify_lists") or [])
    named_core = bool(dump.get("caller_named_core"))
    inferred = dump.get("inferred_core_from")
    seat_dumps = list(dump.get("seat_dumps") or [])
    expected = CORE_SEATS if named_core else FULL_SEATS
    announced_set = set(announced)
    verify_set = set(verify)
    expected_set = set(expected)

    if inferred in PACK_SYNONYMS and not named_core:
        return "RED", "pack-core synonym-infer"
    invented = announced_set - expected_set
    if invented:
        return "RED", "mid-run invent: " + ", ".join(sorted(invented))
    omitted = expected_set - announced_set
    if omitted:
        return "RED", "mid-run omit: " + ", ".join(sorted(omitted))
    missing = [seat for seat in announced if seat not in verify_set]
    if missing:
        return "RED", "missing announced list: " + ", ".join(missing)
    extra = verify_set - announced_set
    if extra:
        return "RED", "verify took unannounced list: " + ", ".join(sorted(extra))
    if named_core:
        present = [seat for seat in UNANNOUNCED_ON_CORE if seat in seat_dumps]
        if present:
            return "RED", "unannounced specialist dump present: " + ", ".join(present)
    return "GREEN", "announced set matches verify lists"


def score_harness_stop(dump: dict[str, Any]) -> tuple[str, str]:
    text = dump.get("text") or ""
    stop = dump.get("stop")
    if not dump.get("announced_comparison"):
        return "RED", "HARNESS-STOP is after announce"
    if stop in {"empty", "shape"}:
        return "RED", "wrong stop path"
    if stop != "harness":
        return "RED", "not a HARNESS-STOP"
    if "HARNESS-STOP" not in text:
        return "RED", "router dump missing HARNESS-STOP"
    if not STOP_PHRASE.search(text):
        return "RED", "stop does not name cannot fan / cannot open a fresh context / cannot launch"
    envelope = _envelope_present(dump, text)
    empty_pass = dump.get("has_no_findings") or "No findings." in text
    inline = bool(dump.get("inline_review"))
    seats = list(dump.get("seat_dumps") or [])
    if envelope:
        return "RED", "HARNESS-STOP envelope"
    if empty_pass:
        return "RED", "HARNESS-STOP empty pass"
    if inline:
        return "RED", "HARNESS-STOP inline"
    if seats:
        return "RED", "seat dumps present after HARNESS-STOP"
    return "GREEN", "brief stop, no envelope"


def _envelope_present(dump: dict[str, Any], text: str) -> bool:
    return bool(
        dump.get("has_findings")
        or dump.get("has_assessment")
        or dump.get("has_follow_ups")
        or re.search(r"^## (Findings|Assessment|Follow-ups)\s*$", text, re.M)
    )


def score_spawn_fail(dump: dict[str, Any]) -> tuple[str, str]:
    text = dump.get("text") or ""
    announced = list(dump.get("announced_slots") or [])
    failed = list(dump.get("failed_slots") or [])
    verify = list(dump.get("verify_lists") or [])
    dropped = list(dump.get("dropped_slots") or [])
    reannounced = dump.get("reannounced_pack")
    if not dump.get("announced_comparison"):
        return "RED", "spawn-fail is after announce"
    if not failed:
        return "RED", "no failed slot recorded"
    failed_names = [item.get("slot") for item in failed if isinstance(item, dict)]
    unknown = [name for name in failed_names if name not in announced]
    if unknown:
        return "RED", "failed slot was not announced: " + ", ".join(map(str, unknown))
    if reannounced or dropped:
        return "RED", "spawn-fail synonym-core (re-announced pack or dropped slot)"
    if verify:
        return "RED", "spawn-fail thinner merge (verify took lists after a slot failed)"
    if dump.get("stop") != "harness":
        return "RED", "spawn-fail without HARNESS-STOP"
    if "HARNESS-STOP" not in text:
        return "RED", "router dump missing HARNESS-STOP"
    if not all(name and name in text for name in failed_names):
        return "RED", "HARNESS-STOP does not name the failed slot"
    if _envelope_present(dump, text):
        return "RED", "HARNESS-STOP envelope"
    if dump.get("has_no_findings") or "No findings." in text:
        return "RED", "HARNESS-STOP empty pass"
    return "GREEN", "named HARNESS-STOP, no merge, pack unchanged"


def score_host_pick(dump: dict[str, Any]) -> tuple[str, str]:
    facts = dump.get("harness_facts")
    picked = dump.get("picked")
    basis = dump.get("pick_basis")
    inferred = dump.get("inferred_from")
    if not isinstance(facts, dict):
        return "RED", "no harness facts probed"
    if picked not in HOST_PICKS:
        return "RED", f"unknown back end: {picked}"
    if basis != "harness-facts" or inferred:
        return "RED", f"wrong-primitive (picked from {inferred or basis})"
    task = bool(facts.get("task_tool"))
    cloud = bool(facts.get("cloud_agent_launch"))
    expected = "task-nest" if task else "cloud-fan" if cloud else "harness-stop"
    if picked != expected:
        return "RED", f"wrong-primitive (facts say {expected}, picked {picked})"
    return "GREEN", f"{picked} from harness facts"


def score_spawn_return(dump: dict[str, Any]) -> tuple[str, str]:
    text = dump.get("text") or ""
    announced = list(dump.get("announced_slots") or [])
    returned = list(dump.get("returned_dumps") or [])
    stop = dump.get("stop")
    if not announced:
        return "RED", "no announced set"
    if dump.get("intent_waited_on_blob") is False:
        return "RED", "cloud intent fanned with blind"
    if stop == "harness":
        if returned:
            return "RED", "partial-return (dumps alongside HARNESS-STOP)"
        if "HARNESS-STOP" not in text:
            return "RED", "stop dump missing HARNESS-STOP"
        slot = dump.get("stop_slot")
        if not slot or slot not in announced or slot not in text:
            return "RED", "HARNESS-STOP does not name an announced slot"
        return "GREEN", "named stop, no dumps"
    if stop:
        return "RED", f"wrong stop path: {stop}"
    missing = [slot for slot in announced if slot not in returned]
    if missing:
        return "RED", "partial-return: missing " + ", ".join(missing)
    extra = [slot for slot in returned if slot not in announced]
    if extra:
        return "RED", "returned unannounced dump: " + ", ".join(extra)
    return "GREEN", "one dump per announced slot"


def score_gatherer_skip(dump: dict[str, Any]) -> tuple[str, str]:
    skipped = list(dump.get("skipped_gatherers") or [])
    held = set(dump.get("held") or [])
    if not skipped:
        return "RED", "no gatherer skip recorded"
    for item in skipped:
        name = item.get("name")
        reason = item.get("reason")
        if name == "review-gather-onboard":
            return "RED", "skip onboard gatherer"
        if reason == "primer":
            return "RED", "skip-because-primer"
        if (
            name in PRODUCT_GATHERERS
            and reason == "held-product"
            and held & PRODUCT_HELD
        ):
            continue
        return "RED", f"invalid skip {name}/{reason}"
    return "GREEN", "skip-because-product"


def score_playbook_child_read(dump: dict[str, Any]) -> tuple[str, str]:
    color, reason = score_playbook_leak(dump)
    if color == "RED":
        return color, reason
    seat = dump.get("seat")
    window = list(dump.get("window") or [])
    reads = list(dump.get("reads") or [])
    reader = dump.get("reader")
    own_playbook = "playbook" in window or any(
        item == "playbook" or item.endswith("playbook.md") for item in reads
    )
    if seat in SPECIALIST_SEATS and reader == "child" and own_playbook:
        if "comparison" not in window:
            return "RED", "specialist window missing comparison"
        return "GREEN", "specialist child Read of own playbook"
    return "RED", "playbook child-Read not shown on a specialist seat"


LEFTOVER_LINE = re.compile(r".+\s+—\s+\S+:\d+")
NUMBERED_LEFTOVER = re.compile(r"(?:\[P[0-3]\]|\d+\.)\s+\S.+\s+—\s+\S+:\d+")
DROPPED_N = re.compile(r"dropped:\s*\d+", re.I)
FOLLOW_UPS_BLEED = {"g5-nit", "speculative", "dropped-n"}


def section_body(text: str, heading: str) -> str | None:
    match = re.search(rf"^## {re.escape(heading)}\s*$", text, re.M)
    if not match:
        return None
    rest = text[match.end() :]
    next_heading = re.search(r"^## ", rest, re.M)
    return rest[: next_heading.start()] if next_heading else rest


def leftover_names(dump: dict[str, Any]) -> list[str]:
    names: list[str] = []
    for item in dump.get("leftovers") or []:
        if isinstance(item, dict):
            name = item.get("name") or item.get("title")
            if name:
                names.append(str(name))
        elif isinstance(item, str) and item:
            names.append(item)
    return names


def score_follow_ups(dump: dict[str, Any]) -> tuple[str, str]:
    text = dump.get("text") or ""
    leftovers = list(dump.get("leftovers") or [])
    follow_ups = list(dump.get("follow_ups") or [])
    assessment = dump.get("assessment") or ""
    findings_text = dump.get("findings_text") or section_body(text, "Findings") or ""
    follow_text = dump.get("follow_ups_text") or section_body(text, "Follow-ups") or ""
    assessment_text = assessment or section_body(text, "Assessment") or ""
    has_heading = dump.get("has_follow_ups_heading")
    if has_heading is None:
        has_heading = section_body(text, "Follow-ups") is not None
    names = leftover_names(dump)

    if dump.get("leftover_numbered_as_finding") or NUMBERED_LEFTOVER.search(
        findings_text
    ):
        return "RED", "leftover numbered as a finding"
    for item in dump.get("findings") or []:
        if isinstance(item, dict) and item.get("leftover") and item.get("severity"):
            return "RED", "leftover numbered as a finding"

    bleed = dump.get("follow_ups_bleed")
    if bleed in FOLLOW_UPS_BLEED or DROPPED_N.search(follow_text):
        return "RED", "G5 nits / dropped: N under Follow-ups"
    for item in follow_ups:
        if isinstance(item, dict) and (
            item.get("g5_nit") or item.get("speculative") or item.get("dropped_n")
        ):
            return "RED", "G5 nits / dropped: N under Follow-ups"

    if dump.get("leftover_in_assessment"):
        return "RED", "leftover stuffed into Assessment"
    for name in names:
        if name and name in assessment_text:
            return "RED", "leftover stuffed into Assessment"

    if leftovers:
        if not has_heading:
            return "RED", "leftovers missing Follow-ups"
        if len(follow_ups) != len(leftovers):
            return "RED", "Follow-ups missing a leftover"
        for item in follow_ups:
            if not isinstance(item, dict):
                return "RED", "Follow-ups line is not title — path:line"
            title = item.get("title") or ""
            path = item.get("path") or ""
            line = f"{title} — {path}"
            if item.get("severity") or item.get("numbered"):
                return "RED", "leftover numbered as a finding"
            if not title or not path or not LEFTOVER_LINE.search(line):
                return "RED", "Follow-ups line is not title — path:line"
        return "GREEN", "leftovers under Follow-ups"

    if has_heading or follow_ups:
        return "RED", "Follow-ups heading when empty"
    return "GREEN", "omit Follow-ups when empty"


def score_scope_follow(dump: dict[str, Any]) -> tuple[str, str]:
    if dump.get("scope_fresh_child") or dump.get("scope_reader") == "fresh-child":
        return "RED", "fresh child for scope"
    if dump.get("followed_review_scope") is False:
        return "RED", "fresh child for scope"
    held = list(dump.get("held") or [])
    parent_held = dump.get("parent_held_scope") or "comparison" in held
    if dump.get("followed_review_scope") and dump.get("scope_reader") == "parent":
        if parent_held:
            return "GREEN", "parent-held scope"
    return "RED", "scope was not Follow-in-parent"


def score_playbook_leak(dump: dict[str, Any]) -> tuple[str, str]:
    role = dump.get("role")
    seat = dump.get("seat")
    window = list(dump.get("window") or [])
    reads = list(dump.get("reads") or [])
    reader = dump.get("reader")
    playbook_read = any(
        item == "playbook" or "playbook.md" in item or item in {"owasp", "cwe"}
        for item in reads
    )
    if role == "router" and playbook_read:
        return "RED", "router Read of playbook"
    if reader in {"router", "blind-child"} and playbook_read:
        return "RED", f"{reader} Read of playbook"
    if seat == "review-blind" and (
        "playbook" in window or "owasp" in window or "cwe" in window or playbook_read
    ):
        return "RED", "playbook in blind window"
    return "GREEN", "no playbook leak to router or blind"


SCORERS = {
    "isolation": score_isolation,
    "pack": score_pack,
    "harness-stop": score_harness_stop,
    "spawn-fail": score_spawn_fail,
    "host-pick": score_host_pick,
    "spawn-return": score_spawn_return,
    "gatherer-skip": score_gatherer_skip,
    "playbook-child-read": score_playbook_child_read,
    "playbook-leak": score_playbook_leak,
    "follow-ups": score_follow_ups,
    "scope-follow": score_scope_follow,
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
            "Score recorded review-sample dump letters against "
            "fixtures/review-sample/README.md. Does not spin live review agents."
        )
    )
    parser.add_argument(
        "--sample-dir",
        type=Path,
        help="review-sample directory (default: fixtures/review-sample)",
    )
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    repo_root = Path(__file__).resolve().parent.parent
    sample_dir = (
        args.sample_dir.resolve()
        if args.sample_dir
        else repo_root / "fixtures" / "review-sample"
    )
    readme_path = sample_dir / "README.md"
    lock_path = sample_dir / "green-table.lock.md"
    letters_dir = sample_dir / "letters"
    if not readme_path.is_file():
        print(f"missing README: {readme_path}", file=sys.stderr)
        return 1
    if not lock_path.is_file():
        print(f"missing GREEN table lock: {lock_path}", file=sys.stderr)
        return 1
    if not letters_dir.is_dir():
        print(f"missing letters dir: {letters_dir}", file=sys.stderr)
        return 1

    readme = readme_path.read_text(encoding="utf-8")
    lock = lock_path.read_text(encoding="utf-8")
    table = extract_green_table(readme)
    failures = 0
    if table != lock:
        print("FAIL green-table: README Expected GREEN rows are not byte-identical to green-table.lock.md", file=sys.stderr)
        failures += 1
    else:
        row_count = len([line for line in lock.splitlines() if line.startswith("|")])
        if row_count != 9:
            print(f"FAIL green-table: expected 9 locked rows, found {row_count}", file=sys.stderr)
            failures += 1
        else:
            print("PASS green-table  9 rows byte-identical")

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
