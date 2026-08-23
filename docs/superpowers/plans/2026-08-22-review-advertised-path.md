# Review Advertised-Path Findings Implementation Plan

> **For agentic workers:** After plan save, emit workflow outcomes `subagent-driven` or `inline` per human choice; do not hard-code the next skill. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When this change’s own hook, header, or extractor cannot do what it claims, that is a numbered finding — without stretching the procedure-file rule, without loosening ordinary app-code gates, and without inventing findings for host-not-advertised residuals.

**Architecture:** `gates.md` stays the authoritative playbook. The same advertised-path letter is copied into `review-defects` so the two files cannot disagree. The router still only classifies. New stored patches under `fixtures/review-sample/` model Bugbot High 2 (Stop stdin vs extractor) and a native-worktree-style host gap.

**Tech Stack:** Agent skills (`gates.md` + `review-defects/SKILL.md`), existing review-sample fixture + new hook diffs, writing-skills TDD via subagents. Spec: `docs/superpowers/specs/2026-08-22-review-advertised-path-design.md`.

## Global Constraints

- No new promoted skill. Do not add `review-skill` / `review-brief`. Do not touch `.claude-plugin/plugin.json` or catalog READMEs.
- Router classify table unchanged. Router does not review and does not restate the new rule.
- Do not loosen the six gates for ordinary application code.
- Do not stretch the procedure-file unsatisfiable-pair rule onto `hooks.json` or ordinary docs.
- Do not open plan/spec review. Plan/spec/design with no procedure or advertised-path diff stays `shape-*`.
- Same letter in `gates.md` and the leaf. Do not paraphrase one into a weaker “prefer.”
- No new Findings / Assessment / Close headings. No near-survivor / residual-risk / future-work sections. Empty pass stays empty.
- Do not add output-contract sections. Do not add a drop-list / trace phrase to `review-defects`.
- Mixed-turn / stop-path envelopes stay as they are.
- writing-skills TDD: RED against **current** gates/leaf **before** the advertised-path letter exists. Ban `docs/superpowers/**` in RED/GREEN prompts.
- Do not copy live supersuit files. Fixture only. Do not implement the supersuit hook fix.
- Do not open a PR against jeighty/supersuit.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/review-sample/hook/extract.py` | Parent CLI-only mediator (argv `--id` / `--from` / `--on`) |
| `fixtures/review-sample/hook/hooks.json` | Parent SessionStart-only hook config |
| `fixtures/review-sample/hook/session-start` | Parent agent-mediated header (no `HOST_EXEC`) |
| `fixtures/review-sample/hook/worktree.py` | Parent git-worktree helper (no native-worktree claim) |
| `fixtures/review-sample/hook/README.md` | Ordinary docs (not procedure) |
| `fixtures/review-sample/hook/docs/plan.md` | Implementation plan (not procedure) |
| `fixtures/review-sample/changes/advertised-path-miss.diff` | High 2: Stop + `HOST_EXEC` + extractor miss |
| `fixtures/review-sample/changes/host-gap.diff` | native-worktree style host-not-advertised |
| `fixtures/review-sample/README.md` | Name the new diffs + expected GREEN |
| `docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md` | RED notes + GREEN results |
| `skills/engineering/review-changes/gates.md` | Authoritative advertised-path letter |
| `skills/engineering/review-defects/SKILL.md` | Same letter + rationalizations / Failures |

Do not edit `review-changes/SKILL.md` classify table. Do not edit plugin.json or catalog READMEs.

---

### Task 1: Hook fixtures (exist before RED)

**Files:**
- Create: `fixtures/review-sample/hook/extract.py`
- Create: `fixtures/review-sample/hook/hooks.json`
- Create: `fixtures/review-sample/hook/session-start`
- Create: `fixtures/review-sample/hook/worktree.py`
- Create: `fixtures/review-sample/hook/README.md`
- Create: `fixtures/review-sample/hook/docs/plan.md`
- Create: `fixtures/review-sample/changes/advertised-path-miss.diff`
- Create: `fixtures/review-sample/changes/host-gap.diff`
- Modify: `fixtures/review-sample/README.md`

RED cannot review a change that does not exist. Create the fixture **before** any baseline run. Do **not** edit `gates.md` or `review-defects` in this task.

**Interfaces:**
- Consumes: existing `fixtures/review-sample/` layout (parent + `changes/*.diff`)
- Produces: hook parent tree + two unified diffs against that parent

- [ ] **Step 1: Write the parent CLI mediator**

`fixtures/review-sample/hook/extract.py`:

```python
"""CLI mediator. Reads --id / --from / --on from argv only."""

import argparse
import json
import sys


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--id")
    parser.add_argument("--from", dest="from_id")
    parser.add_argument("--on")
    return parser.parse_args(argv)


def run(args):
    if args.id or (args.from_id and args.on):
        return {
            "mode": "auto",
            "id": args.id,
            "from": args.from_id,
            "on": args.on,
        }
    return {"mode": "idle", "reason": "no run id or from/on"}


def main(argv=None):
    print(json.dumps(run(parse_args(argv))))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
```

- [ ] **Step 2: Write parent hooks, header, worktree helper, README, plan**

`fixtures/review-sample/hook/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "./session-start"
          }
        ]
      }
    ]
  }
}
```

`fixtures/review-sample/hook/session-start`:

```bash
#!/usr/bin/env bash
# Agent-mediated header. The model calls extract.py --id / --from / --on.
echo "WORKFLOW_MAP: execute extract.py --id <id> (or --from / --on)."
```

`fixtures/review-sample/hook/worktree.py`:

```python
"""Workspace helper. Always uses git worktree."""

import subprocess


def ensure_workspace(path):
    subprocess.run(["git", "worktree", "add", path], check=True)
```

`fixtures/review-sample/hook/README.md`:

```markdown
# hook-sample

Tiny fixture mediator used to test advertised-path review.

`extract.py` is argv-only. This README is ordinary docs.
```

`fixtures/review-sample/hook/docs/plan.md`:

```markdown
# Implementation plan

Register a Stop hook after the CLI mediator ships.
```

- [ ] **Step 3: Write `changes/advertised-path-miss.diff`**

High 2 model: Stop registered; `HOST_EXEC` claims Stop auto-exec; `_extract_handoff` reads `id`/`from`/`on`; Stop stdin is `session_id`/`stop_hook_active`; designed idle-when-no-handoff present.

```diff
--- a/hook/hooks.json
+++ b/hook/hooks.json
@@ -8,6 +8,17 @@
           }
         ]
       }
+    ],
+    "Stop": [
+      {
+        "hooks": [
+          {
+            "type": "command",
+            "command": "python3 ./extract.py"
+          }
+        ]
+      }
     ]
   }
 }
--- a/hook/session-start
+++ b/hook/session-start
@@ -1,3 +1,4 @@
 #!/usr/bin/env bash
-# Agent-mediated header. The model calls extract.py --id / --from / --on.
-echo "WORKFLOW_MAP: execute extract.py --id <id> (or --from / --on)."
+# HOST_EXEC: the host auto-executes via Stop. Do not invent argv.
+echo "HOST_EXEC: Stop hook runs extract.py. Claude Code: Stop hook."
--- a/hook/extract.py
+++ b/hook/extract.py
@@ -1,10 +1,36 @@
-"""CLI mediator. Reads --id / --from / --on from argv only."""
+"""Stop mediator. HOST_EXEC claims the host auto-executes via Stop."""
 
 import argparse
 import json
 import sys
 
 
+def _read_stdin_payload():
+    raw = sys.stdin.read()
+    if not raw.strip():
+        return None
+    return json.loads(raw)
+
+
+def _extract_handoff(payload):
+    """Return (id, from, on) from hook JSON.
+
+    Claude Stop stdin has session_id / stop_hook_active, not id/from/on.
+    """
+    if not payload:
+        return None, None, None
+    action_id = payload.get("id") if isinstance(payload.get("id"), str) else None
+    from_id = payload.get("from") if isinstance(payload.get("from"), str) else None
+    on = payload.get("on") if isinstance(payload.get("on"), str) else None
+    return action_id, from_id, on
+
+
 def parse_args(argv=None):
     parser = argparse.ArgumentParser()
     parser.add_argument("--id")
@@ -14,13 +40,22 @@
 
 
 def run(args):
-    if args.id or (args.from_id and args.on):
+    payload = None
+    if not args.id and not args.from_id:
+        payload = _read_stdin_payload()
+        extracted_id, extracted_from, extracted_on = _extract_handoff(payload)
+        args.id = args.id or extracted_id
+        args.from_id = args.from_id or extracted_from
+        args.on = args.on or extracted_on
+    if args.id or (args.from_id and args.on):
         return {
             "mode": "auto",
             "id": args.id,
             "from": args.from_id,
             "on": args.on,
         }
+    # Designed idle-when-no-handoff. A Stop with no id/from/on is silent idle.
     return {"mode": "idle", "reason": "no run id or from/on"}
```

- [ ] **Step 4: Write `changes/host-gap.diff`**

```diff
--- a/hook/worktree.py
+++ b/hook/worktree.py
@@ -1,7 +1,10 @@
-"""Workspace helper. Always uses git worktree."""
+"""Workspace helper. Host has not advertised native-worktree yet."""
 
 import subprocess
 
 
 def ensure_workspace(path):
+    # Residual: native-worktree is a host capability this change does not
+    # advertise. Keep git worktree. Do not infer the token from the product name.
     subprocess.run(["git", "worktree", "add", path], check=True)
```

- [ ] **Step 5: Append to `fixtures/review-sample/README.md`**

After the existing diffs table, add:

```markdown
| `changes/advertised-path-miss.diff` | Stop stdin `session_id`/`stop_hook_active` vs `_extract_handoff` `id`/`from`/`on`; `HOST_EXEC` claims Stop auto-exec | Numbered finding |
| `changes/host-gap.diff` | Host has not advertised `native-worktree` yet | Residual-or-empty — not a numbered finding |

Hook parent: `hook/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). A this-PR advertised path is a finding. A host-not-advertised capability is residual-or-empty.
```

- [ ] **Step 6: Confirm diffs apply cleanly (dry-run, then restore)**

```bash
cd fixtures/review-sample
patch -p1 --dry-run < changes/advertised-path-miss.diff
patch -p1 --dry-run < changes/host-gap.diff
```

Expected: each reports `patching file` with no fuzz/rejects. Do not leave a patched parent.

- [ ] **Step 7: Commit**

```bash
git add fixtures/review-sample
git commit -m "test(fixtures): add advertised-path review diffs"
```

---

### Task 2: RED baseline (current gates, no new rule)

**Files:**
- Create: `docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md` (after the runs)

**Interfaces:**
- Consumes: Task 1 fixture; **current** `skills/engineering/review-changes/gates.md` and `review-defects/SKILL.md` (no advertised-path letter yet)
- Produces: verbatim drop excuses the GREEN letter must close

Do **not** edit `gates.md` or `review-defects` in this task. If those files already contain the advertised-path letter, **stop** — that is not TDD.

- [ ] **Step 1: Launch fresh `generalPurpose` subagents in parallel**

Each prompt is the quoted user sentence plus this hard ban (include it verbatim):

```
Read skills/engineering/review-changes/SKILL.md first. Follow it end to end, including sibling handoff (read sibling SKILL.md from that file’s directory, not cwd). Apply gates.md as it exists today.

HARD BAN: Do not read docs/superpowers/**. Do not invent a new skill. Do not edit any files. Stay read-only.
```

Workspace: repo root. `subagent_type`: `generalPurpose`. Wait for results.

**A — advertised-path miss + thoroughness (the empty-pass case)**

```
Review fixtures/review-sample/changes/advertised-path-miss.diff against fixtures/review-sample/hook/. Be thorough. Flag anything the author should fix before this ships. Bugbot High 2 said Stop stdin has session_id / stop_hook_active, not id/from/on, so _extract_handoff always misses while HOST_EXEC claims Stop auto-exec.
```

**A2 — same candidate + drop pressure**

```
Apply today’s review-defects + gates.md to fixtures/review-sample/changes/advertised-path-miss.diff against fixtures/review-sample/hook/. All six gates must be true. If any gate is shaky, drop. When in doubt about impact, drop. Gate 4 is “call path demonstrable from the code.” There is no live harness eval. Designed idle-when-no-handoff is intentional. No findings. is success. Park pre-existing / residual host gaps in Assessment, never as a numbered finding.
```

**B — README wording**

```
Review fixtures/review-sample/changes/readme-wording.diff against fixtures/review-sample/procedure/. Flag anything. Nits are fine.
```

**C — app-code clean (regression)**

```
Review fixtures/review-sample/changes/clean-rename.diff against fixtures/review-sample/src/. Be thorough.
```

**D — host-not-advertised residual**

```
Review fixtures/review-sample/changes/host-gap.diff against fixtures/review-sample/hook/. Be thorough. Flag anything. Cursor Cloud could own worktrees.
```

**E — plan-only**

```
Review this design spec: fixtures/review-sample/hook/docs/plan.md (and the wording change in fixtures/review-sample/changes/plan-only.diff). Is this a good plan? Be a critical reviewer.
```

**F — procedure clash (do not regress PR #11)**

```
Review fixtures/review-sample/changes/procedure-clash.diff against fixtures/review-sample/procedure/. Be thorough. The next agent will follow this playbook.
```

- [ ] **Step 2: Score each run**

For A/A2: did they write `No findings.`? Did they park High 2 in Assessment residual? Did they emit a numbered finding naming the extractor/hook claim miss? Record verbatim (expect designed idle / no live harness / residual habit).
For B/C: `No findings.` or invented nits?
For D: numbered finding, or residual-or-empty?
For E: `shape-*` stop, or grilled the plan?
For F: numbered finding naming both letters?

- [ ] **Step 3: Write the baseline file**

Create `docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md` using this shape (fill with real observations; do not leave “TBD”):

```markdown
# Review advertised-path RED baseline

Date: 2026-08-22
Skills present: current review-changes / review-defects / gates.md **without** the advertised-path letter

Fresh `generalPurpose` subagents. Each prompt included a hard ban on `docs/superpowers/**`. Workspace: skills repo root. Linked supersuit: ~/.cursor/skills (fallback ~/.cursor/skill-src/supersuit/skills). No fixture edits.

## Scenario A — advertised-path miss

Prompt: (quote)

Observed:
- Said `No findings.`? **Yes/No**
- Numbered finding naming extractor/hook claim miss? **Yes/No**
- Parked in Assessment residual? **Yes/No**
- Drop excuse (verbatim): ...
- Edited files? **Yes/No**

## Failures this increment must close

Fired:
- ...

Did not fire (still require):
- ...
```

Leave a `## GREEN` stub heading; fill it after GREEN runs.

- [ ] **Step 4: Commit**

```bash
git add docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md
git commit -m "docs: record advertised-path RED baseline"
```

---

### Task 3: Write the advertised-path letter in `gates.md`

**Files:**
- Modify: `skills/engineering/review-changes/gates.md`

**Interfaces:**
- Consumes: spec “New rule” section; RED drop excuses from Task 2
- Produces: authoritative advertised-path letter. App-code six gates unchanged. Procedure-file letter unchanged.

If RED revealed an extra drop excuse, add one sentence here — do not wait for the leaf.

- [ ] **Step 1: Amend the opening drop line**

Change:

```markdown
Flag a finding only when **all six** are true. If any gate is shaky, **drop**. When in doubt about impact, drop — except a demonstrated unsatisfiable pair in a procedure file (see Procedure files).
```

to:

```markdown
Flag a finding only when **all six** are true. If any gate is shaky, **drop**. When in doubt about impact, drop — except a demonstrated unsatisfiable pair in a procedure file (see Procedure files) or a this-PR advertised-path miss (see Advertised paths).
```

Do not rewrite gate 4 or gate 5 in the six-gate list.

- [ ] **Step 2: Append this section after `## Procedure files` (keep every existing section)**

```markdown
## Advertised paths

App-code gates stay tight except this class. Do not stretch the Procedure files rule onto `hooks.json` or ordinary docs.

**Residual** = the host has not advertised a capability yet (example: native-worktree). At most one Assessment residual line. Never a numbered finding.

**Finding** = this change’s own hook, header, or extractor cannot do what it claims.

Example: this PR registers a Stop hook and `HOST_EXEC` claims the host auto-executes via Stop, but `_extract_handoff` reads `id` / `from` / `on` while Stop stdin is `session_id` / `stop_hook_active`. Designed idle-when-no-handoff does **not** cover “this PR’s only registered Stop hook can never have a handoff.”

Gate 4: hook/tool stdin shape and the extractor in this comparison are the call path. Live harness eval is not required.

“No live harness eval” / “it might fail in production” is not a drop for that class. Do not park that class in Assessment residual.

All six gates can be true:

1. Correctness of the advertised path (the hook, header, or extractor cannot do what this change claims).
2. Discrete and actionable (name the claim and the stdin/extractor miss; file:line).
3. Introduced by this change.
4. Demonstrable from the hook/tool stdin shape and the extractor in this comparison. This is the call path. Live harness eval is not required.
5. Concrete bad outcome: the advertised auto-exec never runs for the victim of the claim. Designed idle-when-no-handoff does not cover a hook that can never see a handoff.
6. The author would probably fix it if they knew.

Still **DROP**: wording nits, speculative “might break” with no this-PR advertised path, pre-existing host gaps (at most one Assessment residual line), plan/spec with no procedure or advertised-path diff (still out of family → `shape-*`).

“When in doubt, drop” still applies to ordinary app code. It does **not** authorize dropping a this-PR advertised-path miss, and it does **not** authorize inventing findings for host-not-advertised residuals.
```

- [ ] **Step 3: Commit**

```bash
git add skills/engineering/review-changes/gates.md
git commit -m "feat(skill): flag this-PR advertised-path misses"
```

---

### Task 4: Align the leaf so it cannot contradict `gates.md`

**Files:**
- Modify: `skills/engineering/review-defects/SKILL.md`

**Interfaces:**
- Consumes: the same letter as Task 3
- Produces: hard rules / procedure / rationalizations / Failures that agree

Do **not** add a classify table. Do **not** paste a second, different six-gate list. Do **not** add output-contract sections. Do **not** add a drop-list / trace phrase.

- [ ] **Step 1: After the Procedure files letter, add the same advertised-path letter**

Also amend the intro drop line to:

```markdown
When in doubt, drop — except a demonstrated unsatisfiable pair in a procedure file or a this-PR advertised-path miss.
```

Then add:

```markdown
**Advertised paths** (same letter as `gates.md`; do not weaken it):

App-code gates stay tight except this class. Do not stretch the Procedure files rule onto `hooks.json` or ordinary docs.

**Residual** = the host has not advertised a capability yet (example: native-worktree). At most one Assessment residual line. Never a numbered finding.

**Finding** = this change’s own hook, header, or extractor cannot do what it claims.

Example: this PR registers a Stop hook and `HOST_EXEC` claims the host auto-executes via Stop, but `_extract_handoff` reads `id` / `from` / `on` while Stop stdin is `session_id` / `stop_hook_active`. Designed idle-when-no-handoff does **not** cover “this PR’s only registered Stop hook can never have a handoff.”

Gate 4: hook/tool stdin shape and the extractor in this comparison are the call path. Live harness eval is not required.

“No live harness eval” / “it might fail in production” is not a drop for that class. Do not park that class in Assessment residual.

All six gates can be true:

1. Correctness of the advertised path (the hook, header, or extractor cannot do what this change claims).
2. Discrete and actionable (name the claim and the stdin/extractor miss; file:line).
3. Introduced by this change.
4. Demonstrable from the hook/tool stdin shape and the extractor in this comparison. This is the call path. Live harness eval is not required.
5. Concrete bad outcome: the advertised auto-exec never runs for the victim of the claim. Designed idle-when-no-handoff does not cover a hook that can never see a handoff.
6. The author would probably fix it if they knew.

Still **DROP**: wording nits, speculative “might break” with no this-PR advertised path, pre-existing host gaps (at most one Assessment residual line), plan/spec with no procedure or advertised-path diff (still out of family → `shape-*`).

“When in doubt, drop” still applies to ordinary app code. It does **not** authorize dropping a this-PR advertised-path miss, and it does **not** authorize inventing findings for host-not-advertised residuals.
```

- [ ] **Step 2: Amend procedure step 3**

Change procedure step 3 to also name the advertised-path class:

```markdown
3. Apply every gate in `gates.md` to each candidate. Drop if any is shaky — except a demonstrated unsatisfiable pair in a procedure file or a this-PR advertised-path miss. When a procedure file is in the file list, apply the Procedure files letter. When this change’s own hook, header, or extractor advertises a path, apply the Advertised paths letter. Live harness eval is not required for that class. Do not require application runtime for a procedure-file pair.
```

- [ ] **Step 3: Add rationalization rows and Failures**

Add these rows (plus any verbatim excuse from Task 2 that is not already listed):

```markdown
| “Designed idle-when-no-handoff covers this” | Idle is for no handoff. An extractor that can never see this hook’s stdin is a finding. |
| “No live harness eval” | Gate 4 for this class is stdin shape + extractor. Live eval is not required. |
| “It might fail in production” | Not a drop when this PR advertised the path. Demonstrate the claim miss or, if there is no advertised path, drop. |
| “Park it in Assessment residual” | Residual is host-not-advertised. A this-PR advertised-path miss is a numbered finding. |
| “hooks.json is a procedure file / unsatisfiable pair” | Do not stretch that rule onto `hooks.json` or ordinary docs. Use the advertised-path letter. |
| “Host has not advertised native-worktree — finding” | Residual-or-empty. Never a numbered finding. |
```

Add to Failures:

```markdown
- Dropping a this-PR advertised-path miss (hook / header / extractor cannot do what it claims)
- Parking that class in Assessment residual
- Stretching the procedure-file rule onto `hooks.json` or ordinary docs
- Numbering a host-not-advertised capability gap
```

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/review-defects/SKILL.md
git commit -m "fix(skill): keep review-defects aligned with advertised-path gates"
```

---

### Task 5: GREEN verification + baseline GREEN section

**Files:**
- Modify: `docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md`

**Interfaces:**
- Consumes: skills from Tasks 3–4, fixture from Task 1, RED notes from Task 2
- Produces: GREEN pass/fail notes; REFACTOR the letter if a loophole fires

- [ ] **Step 1: Confirm fixture parents are unpatched**

```bash
git diff -- fixtures/review-sample/hook fixtures/review-sample/procedure fixtures/review-sample/src
```

Expected: no diff.

- [ ] **Step 2: Launch GREEN subagents** (same A–F prompts as Task 2, **plus** this prefix)

```
Read skills/engineering/review-changes/SKILL.md first. Follow it end to end, including sibling handoff (read sibling SKILL.md from that file’s directory, not cwd). HARD BAN: Do not read docs/superpowers/**. Do not edit any files.
```

Treat each stored diff as the named-patch comparison. Do not require a dirty git tree.

- [ ] **Step 3: Pass criteria**

| Scenario | Pass |
|---|---|
| A | At least one `[P#]` finding. Paragraph names the extractor/hook claim miss (`id`/`from`/`on` vs `session_id`/`stop_hook_active`, and `HOST_EXEC` / Stop). Cite overlaps the new extractor or header lines. Not `No findings.` Not parked only in Assessment residual. |
| A2 | Same as A under drop pressure (“no live harness” / residual habit). SURVIVED. |
| B | `No findings.` No numbered README wording finding. No file edits. |
| C | User-facing findings section is exactly `No findings.` No invented app-code nits. |
| D | Residual-or-empty. **No** numbered finding for host-not-advertised `native-worktree`. |
| E | `shape-*` stop; no Findings/Assessment/Close envelope; no numbered finding |
| F | At least one `[P#]` finding naming both Path letters. Do not regress PR #11. |

If A or A2 writes `No findings.` or parks High 2 only in Assessment residual, that is a **failed GREEN**. REFACTOR: add the verbatim excuse to the rationalizations table, then re-run A/A2.

If D invents a numbered host-gap finding, tighten Residual. Re-run D.

If C invents a finding, the app-code gates were loosened. Revert that loosening.

If F drops the procedure clash, the PR #11 letter was broken. Restore it.

- [ ] **Step 4: Fill `## GREEN` in the baseline file** with said_no_findings / named_claim_miss / parked_residual / edited_files / verbatim.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md
git add skills/engineering/review-changes/gates.md skills/engineering/review-defects/SKILL.md
git commit -m "docs: record advertised-path GREEN results"
```

---

## Self-review

**Spec coverage:** advertised-path definition, residual vs finding, same letter in gates + leaf, router unchanged, gate 4 stdin/extractor reading, no live harness, do not park residual, do not stretch procedure-file, DROP list, app-code not loosened, no new skill, fixture + RED/GREEN, catalog unchanged, supersuit note — each has a task.

**Placeholders:** none. Fixture diffs and skill letters are inlined.

**Type consistency:** empty strings `No findings.` and `Nothing to review.`; stop `shape-*`; advertised-path = this-PR hook/header/extractor claim miss; residual = host-not-advertised; plugin stays `0.6.0`.
