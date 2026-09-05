---
name: review-spawn-seats
description: >-
  Internal spawn helper for defect-first review. Use when review-changes
  needs gatherers or announced seats started in fresh contexts, on a host
  with nested Task tools or on one that only launches CloudAgents.
  Returns full dumps for the announced set or a named HARNESS-STOP. Does
  not choose the pack, build seeds, review, or verify. Read-only.
disable-model-invocation: true
---

# Review spawn seats

Start the slots `review-changes` already announced, each in a fresh
context, on whichever primitive this host actually has. Hand back one
dump per announced slot, or one named HARNESS-STOP. Nothing else.

This is the same review family on either back end. `cloud-seat` is an
**invocation mode** of `review-changes`, not a sibling product. There is
no `review-changes-cloud`, no `review-changes-light`, no second pack
table here. Same packs, same seeds, same gates, same HARNESS-STOP.

## Inputs (from the router, already built)

- The **announced set for this call**: the slots the router hands in this helper call only. The router makes separate calls — gatherer slots (`review-gather-pr`, `review-gather-design`, `review-gather-onboard` minus any product-skip the router already applied), then the pack’s parallel seat slots, then `review-intent` alone after the reconstruct blob. Seats that ran in an earlier or later call are not this call’s set and are not missing from it.
- **Seed bytes** per slot, built by the router:
  - **comparison-seed** — announced comparison, comparison command, file list, mixed-turn fix request if any, optional focus phrase. Every gatherer and every parallel seat gets these same bytes. Checklist additionally gets the user-named file when the caller named one.
  - **intent-seed** — comparison-seed plus the PR-body and design-excerpt products (when nonempty), commit message / procedure context when present, and the reconstruct blob `review-blind` emitted. Built after blind returns. Intent only.
- **Harness facts** — observable predicates about this host (below).

Each child window is that slot’s seed bytes plus that slot’s own `SKILL.md` (a specialist Reads its own playbook in its own window). Nothing from the parent window.

## Pick the back end from harness facts

| Harness fact | Back end |
|---|---|
| **Task-nest fact true**: this host exposes a nested Task / subagent tool that opens a fresh context **and** the child can load that slot’s `SKILL.md` | **A: Task nest** — one fresh child per slot |
| Task-nest fact false (no nested Task tool, or the Task child cannot load the slot skill); this host exposes a CloudAgent launch primitive | **B: CloudAgent fan** — one CloudAgent per slot |
| Task-nest fact false and no CloudAgent launch primitive | **HARNESS-STOP** — name that, return no dumps |

**Task-nest fact** = a nested Task / subagent tool that opens a fresh context **and** the child can load that slot’s `SKILL.md` (plugin install or an equivalent readable install path). If the Task tool exists but the child cannot load the slot skill (unloadable install), the Task-nest fact is **false** → use CloudAgent fan when that launch primitive is present, else HARNESS-STOP. Do not nest into unloadable children. Do not infer unloadable from the words “Grok”, “Medium”, or “cloud” — probe (e.g. the plugin catalog missing the family, or a probe Read of the seat `SKILL.md` path failing for a child).

Facts are what the host advertises in this session: a tool in the tool list, a launch primitive that accepts a prompt and returns a handle, a child that can Read the slot skill. Probe them. Do not infer them.

Not a fact: a product, bot, model, or tier word in the request — “Grok”, “Grok Bot”, “quick”, “light”, “Medium”, “small”, “cloud”, “local”. Picking Task or CloudAgent from any of those is **wrong-primitive**. A host that mentions Grok may have a Task tool whose children load the skill; a host that says nothing may lack one. Check the tool list and the child’s install, not the wording.

When the Task-nest fact is true, nest. Do not prefer CloudAgent because it “runs in parallel anyway”. When the fact is false and the launch primitive is present, fan. A Task tool whose children cannot load the skill is not a nest — it HARNESS-STOPs on every slot and never exercises the CloudAgent path. Do not review inline on either miss.

## Back end A: Task nest

- Only when the Task-nest fact is true: the child can load the slot’s `SKILL.md`. A child that cannot Read it is an unloadable install, not a nest.
- One fresh child per slot. Child prompt = that slot’s seed bytes + the instruction to Read its own `SKILL.md`.
- Parallel slots (gatherers together; then blind + announced specialists together) dispatch in one batch. Take every child’s dump back.
- `review-intent` dispatches only after the blind dump is back and the router has handed over the intent-seed. Do not dispatch it earlier with a placeholder.

## Back end B: CloudAgent fan

- One CloudAgent per slot. Agent prompt = that slot’s seed bytes + the instruction to Read its own `SKILL.md` (the same skill install the parent uses, or the skill text inlined as procedure). Each agent’s window starts empty apart from that prompt.
- Parallel slots launch as a batch and are awaited as a batch. A launch that is rejected, errors, times out before starting, or returns no dump is a **spawn-fail** for that slot.
- `review-intent` launches only after the blind agent’s dump is back and the intent-seed exists. CloudAgents being able to run concurrently is not a reason to launch intent with blind. Blind stays comparison-only; intent still waits on the blob.

## Return contract

**Announced set = the slots handed in this helper call only.** The router hands gatherers, then the parallel seats, then intent as separate calls; a full return for this call’s slots is GREEN even when other announced seats ran in an earlier or later call. A partial return among *this* call’s slots is RED.

Return exactly one of:

1. **Full dumps** — one dump per slot handed in this call, the whole set, in slot order. A gatherer dump is its product or **empty**. A seat dump is its candidate list (blind: plus the reconstruct blob as a separate product). Return them byte-for-byte; do not summarize, trim, dedupe, or judge.
2. **HARNESS-STOP** — one or two sentences naming the slot that could not start and the primitive that failed (`no nested Task tool`, `CloudAgent launch rejected for review-blind`, `neither Task nor CloudAgent launch on this host`). Return no dumps with it — not the ones that did start.

Never a subset. Never “five of six, checklist did not come back.” If any slot handed in this call did not start or did not return, the whole call is HARNESS-STOP. The router stops on it; `review-verify` never sees a partial set.

## This helper does not

1. **Own pack policy.** It does not add, drop, or re-order announced slots. It does not re-announce `core` because a seat failed, because the host lacks Task, or because CloudAgents are expensive. It does not read the caller’s words at all. The router chose the pack once; the helper spawns what it was handed.
2. **Return partially.** All dumps for this call’s slots or a named stop. A partial list is RED even when the missing slot “would have been `No candidates.`”. Intent absent from the parallel-seat call is not partial — it belongs to the next call.
3. **Pick from synonyms.** Back end comes from harness facts only. “Grok” / “quick” / “Medium” / “cloud” never choose a primitive, and never decide that a child can or cannot load the skill.
4. **Build seeds.** It receives comparison-seed and intent-seed bytes already built. It does not fetch the PR body, design excerpt, blob, or file list itself. It does not add “helpful context” to a seed. It does not copy a playbook into blind or a blob into a specialist.
5. **Run verify.** `review-verify` Follows in the parent on the returned dumps. The helper never spawns a verify child, never applies `gates.md`, never writes Findings / Assessment / Follow-ups, never writes `No findings.`

## Rationalizations

| Excuse | Reality |
|---|---|
| “No Task tool here — review inline so seats still ran” | Check for a CloudAgent launch primitive. Present → fan. Absent → HARNESS-STOP. Inline is never a back end. |
| “No Task tool — announce `core` so there are fewer seats to fan” | Pack policy is the router’s, chosen once. A harness miss changes the back end or stops the run. It never thins the pack. |
| “Caller mentioned Grok Bot, so this must be the CloudAgent path” | Probe the tool list and the child’s install. A Task tool whose children load the skill is a Task nest, whatever the bot is called. |
| “They said quick / Medium — nest with Task, it is lighter” | Tier words are not harness facts. Task-nest fact false → fan or stop. |
| “The Task tool is right there — nest, even if the child’s plugin catalog is empty” | A child that cannot load the slot `SKILL.md` is an unloadable install. Task-nest fact is false. CloudAgent launch present → fan. Absent → HARNESS-STOP. Never nest into unloadable children. |
| “It is Grok / Medium / cloud, so the children probably cannot load skills — fan” | Unloadable is probed, not inferred. Check the plugin catalog or Read the seat `SKILL.md` path from a child. Skills loadable + Task present → nest; fanning from the word is wrong-primitive. |
| “CloudAgents run in parallel anyway — launch intent with blind” | Intent waits on the reconstruct blob on every back end. Launch it after blind returns. |
| “Regression’s CloudAgent never came back — hand verify the six that did” | Partial return is RED. Named HARNESS-STOP, no dumps. |
| “The missing seat would have been `No candidates.` anyway” | An announced list that never existed is never-seen (#31). Stop. |
| “Intent is not in this return, so the parallel-seat call is partial” | Announced set is per call. Intent is handed in its own call after the blob. Six of six parallel seats back is a full return. |
| “Drop the failed seat; it was not core” | Announced is announced. Dropping mid-run is the router’s RED, and the helper does not own the set. |
| “Add the PR body to the comparison-seed so cloud seats have context” | Seeds arrive built. Adding to them is a leak into blind and every specialist. |
| “Spawn a verify CloudAgent too, so the whole review is isolated” | Verify Follows in the parent. Isolation is not its duty. The helper never spawns it. |
| “Write `No findings.` for the seat that did not start” | Fabricated dump. HARNESS-STOP only. |

## Red flags

- Choosing Task vs CloudAgent from “Grok”, “quick”, “light”, “Medium”, “small”, “cloud”, or the model name
- Nesting Task children that cannot load the slot `SKILL.md` (unloadable install) instead of fanning CloudAgents or stopping
- Declaring the install unloadable from a product or tier word instead of probing the plugin catalog or a child Read
- Reviewing inline when neither primitive is present, or when one launch fails
- Returning fewer dumps than the slots handed in this call without a HARNESS-STOP
- Returning dumps alongside a HARNESS-STOP
- Re-announcing `core`, dropping a slot, or adding a slot
- Launching `review-intent` with blind, or with a placeholder blob
- Fetching the PR body / design excerpt / blob / playbook to “complete” a seed
- Spawning `review-verify`, applying `gates.md`, or writing any envelope line
