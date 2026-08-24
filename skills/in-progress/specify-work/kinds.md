# Specify kinds

Shared letter for `specify-work` and `write-*`. Those skills are
**REQUIRED** to follow this file. If wording here conflicts with a
`SKILL.md` summary, **this file wins**.

## Two kinds

| Kind | What it is | Where it lives | What it may change |
|---|---|---|---|
| **Requirement** | A product fact users can perceive (example: a later-feature they named) | `write-spec` **MVP In** or **Later-features Out** | Grain and inventory. If it is in MVP In, size-work may pick a larger level. If it is in Out, it must not become an inventory child. |
| **Standard** | A quality or workflow constraint (example: ISP, SOLID, stacked PRs) | `write-spec` **Standards** as **labels only**; seams in `write-design`; workflow in `write-plan` | The **plan** (and labels on the spec). **Never** bumps a feature to an epic. **Never** appears as a size-work inventory child. |

size-work must still refuse a class list even if the spec is full of
SOLID labels. This family must not hand size-work a class inventory.

## Class lists

Class and interface **cuts** are **not** requirements and **not**
inventory. Producing them is `write-design`’s job **after grain**.
`write-design` **derives** steps and cuts from the sized work. A user
class list is a **hint**, not required inventory and not a substitute
for that derivation.

**Stop** (point at `write-spec` → `size-work`; do not treat cuts as
stories, features, or tasks) only when:

- the **ask is the class list as the work** (no product outcome to
  sharpen; classes/providers are the request), or
- `write-design` or `write-plan` would run **before grain exists**.

**Before grain**, `write-spec` on a mixed dump **separates**. It emits
a class-free spec (no cuts). It does **not** abort. Do not treat
“classes appear in the dump” as “stop, do not write the spec.”
**After grain**, a re-sent mixed dump is `write-design` (see Compose
order), not a second spec.

**No grain** for `write-design` / `write-plan` is the same stop even
when they did not dump a class list. “Design this story/feature after
grain” still requires grain; it is not a bypass. After grain,
`write-design` does not wait for a class list.

Every `write-design` cut states, as **short notes** (not test code,
not a plan, not size-work stories):

- **Error / failure** states that cut owns. Each cut’s error
  note includes an in-cut error type (or enum), not an
  `errors/` folder. Greenfield colocate; house still wins if
  the repo already has `errors/`.
- **How that cut is tested** — what is faked vs real.

Do not wait for a class list. Do not pull Out requirements in to
“prove” error paths. Do not emit 2–5 minute steps.

Failure: a cut has interface + first impl but no error note and
no test note. Failure: an error note that omits an in-cut
error type (or enum).

Every cut’s **interface + first implementation** names the
**job**. A reader who has only the file map — no design prose —
must know what the cut does.

Role + adapter is fine. TypeScript-style is fine.

**Named types:** If In, a cut, or the File map names a
non-primitive collaborator or data type, that name must
exist as a class, type, interface, or enum in the **owning
cut**. Language picks the shape (TS type is fine for an
anemic DTO). Primitive / array / tuple of primitives do not
spawn a type. Not a new cut unless it has interface + first
impl + error/test notes.

RED: poetry / vibe / cute one-word names (`Here`, `Place`,
`TodayBoard`, `ComposeToday`, `Till`, `Gold`).

One responsibility per file; files that change together live
together; split by job, not layer. **File map** owns the
tree (greenfield colocate-by-cut vs existing-repo house).
Type and function names follow the house when a repo already
has a pattern; type names stay consistent across tasks.
A user class list remains a hint.

## Open decisions

`write-spec` **infers** unanswered external or product choices. Do
not require the dump to name them.

Apply the visibility ladder **without a cut prerequisite**. Gate on
the **outcome / MVP In**, not on cuts. `write-spec` does not wait
for `write-design` cuts. “No cuts yet” is not a reason to omit an
Open decision.

If making the outcome true would use an external service, vendor,
library, or product option the dump did not settle, pick the most
visible option that still fits:

1. **Spike** (Open decisions → size-work `shape-task`) — default
   when unclear. Use when we would not write the implementation
   (vendor/API), more than one reasonable option exists, or the
   choice can change **later** cuts, auth, data shape, or tests.
   An external service with no vendor in the dump is this class
   unless demoted below. Example: which external vendor/API.
2. **Explained decision** — only if one standard/free default is a
   no-brainer **and** the pick does not change grain or later
   cuts. Write the pick and why in Open decisions. Not a spike.
   Not silent. A **stack** pick (language / bundler / test runner /
   page vs framework) is usually this class.
3. **Silent** — only if the choice is forced by an already-stated
   stack or is the only legal option. Never silent on an external
   vendor/API.

If unclear, take the more visible option: spike > explanation >
silent.

“Cuts” in the spike/demote lines means **the later design would
change**, not “cuts must already exist.” An agent may **demote** an
external vendor/API from spike to explained
pick only if they name the default and say why a later spike would
not change those future cuts. External, not our code, stays a
spike unless demoted that way.

A spike is **not** a one-liner (“pick a vendor/API”). Each Open
decision spike lists **real options** (at least two when more than
one reasonable vendor or product exists) with:

- short pros / cons
- compare / contrast
- whether **each** option would change MVP In / Out, grain, later
  cuts, auth, data shape, or tests. If it would not, say so.

`write-spec` lists visibility **and** those options under Open
decisions. size-work would shape a spike as a separate
`shape-task` (this family does not edit size-work). `write-plan`
lists that spike **first**, with the same options / impact — not
a one-liner. It must not swallow the spike into a production
implementation PR.

**Approaches ≠ spike options.** Approaches (next section) are ways
to build. Spike options are unsettled external or product choices
(vendor / API). Do not paste the stack bake-off into the spike.
Do not paste vendor options into Approaches as a substitute for
this ladder. Naming a vendor inside an Approaches pick does not
make it silent or a default-without-ladder.

## Approaches

`write-spec` compares **how we build** the Outcome / MVP In. This
is not inventory. This is not cuts. This is not Path. This is not
a reason to auto-continue into design or plan. Do not grill.

Required section: **2–3 real alternatives**, trade-offs, then a
recommended pick and why. Alternatives are **stack / architecture**
(language, bundler, test runner, page vs framework) — not the
vendor list from Open decisions. When the dump did not settle a
stack, the pick includes how we build.

Compose with **Open decisions** (do not duplicate that ladder
here):

- The stack pick is usually an **explained** decision: name it,
  say why, on Open decisions. It is not a substitute for the
  vendor / API spike.
- The vendor / API stays a **spike** unless demoted with a named
  default **and** why later cuts would not change.
- Failure: silent on stack while inferring a vendor
  spike.
- Failure: Approaches swallows the vendor into a silent or
  default-without-ladder pick.

Still stop. Point at `size-work`. Do not invoke it.

## After a spike pick

When a spike pick lands (the user names a vendor, or a later turn
says “use this vendor”), take **one** leaf. Do not auto-continue
this loop in one turn.

Apply **in this order**. Do not read the unlabeled table as a
second vote on a named leaf.

1. **Stale** — the pick would change Outcome / In / Out, or would
   change grain. Impact **wins**. `write-spec`. Stop. Point at
   `size-work`. Even if they said “design” or “plan.” This family
   does not edit size-work. Do not keep designing or planning on
   the old spec.
2. **Not stale, and they named only one document.** User label
   **wins**. “plan this” → `write-plan`. “design this” →
   `write-design`. Do **not** override a named leaf with “next
   unfinished,” “no design yet, so write-design,” or “only cuts,
   so write-design.”
3. **Not stale, and they did not name only one document** (mixed
   ask, or just the pick). Then this table:

| Impact of the pick | Leaf |
|---|---|
| Only cuts / seams / errors | `write-design` (after grain still exists) |
| Only sequence / files / PR split | `write-plan` |
| Nothing material | Note that. Take the next unfinished leaf (`write-design` if no design yet, else `write-plan`). |

The table is only step 3. It does not apply when step 1 or step 2
already named the leaf.

Do not swallow the pick into a production PR. Do not add bake-off
runner code or a 2–5 minute TDD novel.

## After write-spec

The spec is a feature-shaped outcome plus In / Out / approaches /
spikes-with-options / labels. It is not an epic. It is not a class
inventory. It is not a Path. size-work reads requirements in
In/Out, not Standards, not providers, not Approaches.

size-work inventory is **3–9** user stories (**five OK**). This
family must not assert one story, and must not treat five as
over-split. Fail epic. Fail class / provider children.

## File map

`write-plan` emits a **File map** after Spike and before the
stacked-PR list: exact paths to create or modify, and what each
file is responsible for. Paths and names follow **this design’s
cut names**.

**Existing repo → match the house.** A tree already on disk
(`lib/`, `tests/`, flat `src/`, function modules, classes) is
the convention. GREEN if the File map copies the repo’s
existing test root, naming, and FP vs OO. RED **only** if
the plan invents a second convention (colocate on a
`tests/` house, or distant `tests/` on a colocated house).
Example of inventing: `src/Port/Provider/` +
classes against a `tests/` + function-module house. Do
**not** fail house-style `tests/` or flat `src` on an
existing-repo prompt.

**Greenfield / no house → colocate by cut.** Capability / cut
folder first, then port + first impl together. Tests sit next
to the file they cover — not a distant `tests/` tree. Not a
mandatory `domain/` / `ports/` / `adapters/` / `views/` tree.
Not a flat `src/*.ts` dump.

Do not require one nest spelling. Acceptable **on greenfield**
(shape only — invented generic names, not a fixture list):

- `src/Port/Provider/`
- `src/Port/PortProvider/`
- `src/PortProvider/`

```
src/Port/Provider/Port.ts
src/Port/Provider/FirstImpl.ts
src/Port/Provider/Port.test.ts
src/Port/Provider/FirstImpl.test.ts
```

Existing repo → match `lib/` + `tests/` + function-modules
(or whatever tree is on disk). Do not rewrite it to the
greenfield nests.

Same shape for each cut on greenfield. Job names on the types
or functions, not `Here` / `Place` / `TodayBoard` / `Till` /
`Gold`. Follow house type / function names when a tree
already exists.

**Named types** and **in-cut errors:** if In, a cut, or this
File map names a non-primitive, that name exists as a class,
type, interface, or enum in the **owning cut**. Each cut’s
error note includes an in-cut error type (or enum), not an
`errors/` folder. Greenfield colocate; house still wins if
the repo already has `errors/`. Primitive / array / tuple
of primitives do not spawn a type.

RED (greenfield / no house): all cuts dumped in `src/*.ts`
with every cut in one directory.
RED (greenfield / no house): requiring hexagonal folder
names as the only legal tree.
RED (greenfield / no house): requiring a distant `tests/`
tree.
RED (greenfield / no house): one dump folder that mixes
every cut.
RED (greenfield / no house): owned error types in `errors/`
when the house does not already use `errors/`.
RED (greenfield / no house): a named non-primitive with no
class / type / interface / enum in the owning cut.
RED (greenfield / no house): omitting an in-cut error type
(or enum).
RED (existing repo): inventing a second convention
(colocate on a `tests/` house, or distant `tests/` on a
colocated house).

Scaffold (`package.json`, `vite.config`, `index.html`) can sit at
the page cut / composition PR, not inside every port folder.

Keep the writing-plans line in spirit: files that change together
live together; split by responsibility, not by technical layer.

Each stacked PR then names the files it touches.

Spike still first as a `shape-task` (options + impact, not a
one-liner). Do not swallow it.

Do not add bite-size TDD steps, complete test / impl code blocks,
or an execution handoff.

Cheap self-review: no TBD; file-map paths match the PRs;
signatures / names match the design cuts; named types and
in-cut error types sit with the cut on greenfield; house
still wins if the repo already has `errors/`; colocate by
cut when greenfield; **follow the house** when a tree
already exists.

Failure: stacked PRs and no paths. Failure: the plan becomes a
2–5 minute code novel. Failure (greenfield): flat `src/*.ts`
dump with every cut in one directory. Failure (greenfield):
hexagonal `domain/ports/adapters/views` as the only legal
tree. Failure (greenfield): distant `tests/` tree. Failure
(greenfield): one dump folder that mixes every cut
(mixed-cut map). Failure (greenfield): error types in
`errors/` when the house does not already use `errors/`.
Failure (greenfield): a named non-primitive with no class /
type / interface / enum in the owning cut. Failure
(greenfield): omitting an in-cut error type (or enum).
Failure (existing repo): inventing a
second convention (colocate on a `tests/` house, or distant
`tests/` on a colocated house).

## Compose order

```
write-spec → size-work → write-design → write-plan
```

Grain means a spec was already consumed. One leaf this turn. User
label wins when they name **only one** document, except **After a
spike pick** step 1 (stale). Step 2 is that user-label win. Step 3
is the unlabeled table only.

| When | Ask | Leaf |
|---|---|---|
| **Before grain** | spec+design+plan, or a mixed dump | `write-spec`. Separate. Do not abort on classes. Stop. Point at size-work. |
| **After grain** | spec+design+plan, a re-sent mixed dump, or design+plan | `write-design` first, then hand back. Do **not** re-run `write-spec` unless they explicitly asked to rewrite the spec or change In/Out, **or** a just-landed spike pick would change Outcome / In / Out or grain. |
| **After grain** | spec only (explicit rewrite / In/Out change) | `write-spec` |
| **After grain** | plan only | `write-plan` (unless a just-landed pick would stale In/Out — then `write-spec`) |
| **Spike pick landed** | stale (Outcome / In / Out / grain) | `write-spec`. Wins over “design” / “plan.” |
| **Spike pick landed** | not stale; they named only one document | That leaf. Do not override with “next unfinished.” |
| **Spike pick landed** | not stale; mixed ask or just the pick | Unlabeled table in **After a spike pick** step 3 |

## Rationalizations

| Excuse | Reality |
|---|---|
| “SOLID is in the spec, so this is an epic” | Labels do not bump grain. |
| “I’ll list a class as a story so size-work can sequence it” | Cuts are not inventory. Design after grain. |
| “They didn’t name classes, so write-design cannot run” | Derive cuts from the sized work. |
| “Stacked PRs are required, so they are children” | Standard → plan, not inventory. |
| “The later-feature is how we prove ISP, so it is MVP” | If it is later, it stays Out. |
| “They asked for spec, design, and plan together” **before grain** | `write-spec`. Separate the dump. Hand back. Point at size-work. |
| “They asked for spec, design, and plan together” **after grain** (or re-sent the mixed dump) | `write-design` first. Hand back. Do not re-run `write-spec` unless they asked to rewrite In/Out or a pick would stale it. |
| “Standards are required this turn, so I should design them” | Labels on the spec. Design after grain. |
| “Classes appear in the dump, so I must stop” | Before grain, separate. Do not abort. After grain, that is not a `write-spec` turn. |
| “Design this — no grain, no class list, so proceed” | No grain. Stop. Same letter as write-plan. |
| “They asked for design and plan after grain, so take the later leaf” | `write-design` first. Hand back. Do not skip to `write-plan`. |
| “The dump didn’t say the service is still open, so no spike” | Infer. Do not require the dump to name the choice. |
| “I’ll stay silent; they’ll pick a vendor/API later” | Never silent on an external vendor/API. Spike unless demoted. |
| “That vendor is obvious, so I won’t mention it” | Explained decision only if you name the default and say why a later spike would not change those future cuts. Otherwise spike. |
| “No cuts yet, so the ladder does not apply” | False. Infer from the outcome. “No cuts yet” is not a reason to omit. |
| “Approaches already picked a vendor, so the spike can be a one-liner” | Approaches ≠ spike options. Vendor stays a spike with real options unless demoted. |
| “Stack vs React is a spike option” | That is Approaches (ways to build). Spike options are vendor / product choices. |
| “Spike is ‘pick a vendor/API’” | List real options, pros/cons, and impact. |
| “They named a vendor and said design, so write-design” | If the pick would change In/Out or grain, `write-spec` then point at size-work. Do not design on a stale spec. |
| “Vendor settled and they said plan this, but there is no design yet, so write-design” | False when the pick is not stale. User label wins. `write-plan` derives cuts the same way `write-design` would. |
| “The pick landed, so spec then size then design this turn” | One leaf. Do not auto-continue that loop. |
| “Approaches picked a stack, so continue to design” | Close. Point at `size-work`. |
| “Cuts have interface and impl; errors wait for the plan” | The error note includes an in-cut error type (or enum) now. |
| “The note is enough; the type waits for impl” | The note includes the type. |
| “I’ll put all failures in errors/” | Greenfield colocate. House still wins if the repo already has `errors/`. |
| “It’s just a string on the page” | If In, a cut, or the File map names it, it exists in the owning cut. |
| “I’ll invent extra domain types to be complete” | Primitive / array / tuple of primitives do not spawn a type. Type what In names. |
| “Stacked PRs imply the paths” | Emit a File map with exact paths before the PR list. |
| “Writing-plans uses 2–5 minute TDD steps” | This family’s plan unit is a stacked PR + File map, not a code novel. |
| “Here / Place is shorter” | Fail cute one-word cuts. Name the job. |
| “domain/ports/adapters is how hexagonal works” | Not the only legal tree. Greenfield: colocate by cut. House: match the house. |
| “src/*.ts is simpler” | Greenfield: fail a flat dump. Existing flat-src house: match it. |
| “Tests live in tests/” | Greenfield: tests sit next to the file. Existing repo: match the house. Do not fail `tests/` when that is the house. |
| “Colocate-by-cut always wins” | Only when there is no house. Colocate on a `tests/` house, or distant `tests/` on a colocated house, is a second convention. |
| “Every port folder needs package.json” | Scaffold sits at the page cut / composition PR. |

## Failures

- Standard listed as an inventory child, or used to bump feature → epic
- Class / provider list or derived cuts handed to size-work as children
- `write-design` waiting for a class list, or copying a dump’s list as the design
- Out requirement pulled into MVP In during design or plan
- Spike swallowed into a production PR
- Omitting an inferred external/API spike because the dump did not name it as open
- Omitting an inferred external spike because cuts do not exist yet
- Silent on an external vendor/API
- Spike that only says “pick a vendor/API” (no options / no impact)
- Approaches silent on stack while inferring a vendor spike
- Approaches swallows the vendor into a silent or default-without-ladder pick
- After a pick that would change In/Out or grain, continuing to `write-design` or `write-plan` without re-running `write-spec`
- Non-stale pick + “plan this” taken as `write-design` because no design exists yet, or because the unlabeled table said “only cuts” / “next unfinished”
- Auto-continuing the after-pick loop (spec → size → design) in one turn
- A cut with interface + first impl but no error note and no test note
- Error notes that omit an in-cut error type (or enum)
- A name in In / a cut / the File map with no class / type / interface / enum in the owning cut
- Cute / poetry cut names (`Here`, `Place`, `TodayBoard`, `ComposeToday`, `Till`, `Gold` as the only names)
- Plan with stacked PRs and no paths
- File map is a flat `src/*.ts` dump with every cut in one directory (greenfield / no house)
- File map requires `domain/` / `ports/` / `adapters/` / `views/` as the only tree (greenfield / no house)
- File map requires a distant `tests/` tree (greenfield / no house)
- File map is one dump folder that mixes every cut (mixed-cut map)
- File map puts owned error types in `errors/` (greenfield / no house, and the house does not already use `errors/`)
- File map names a non-primitive with no class / type / interface / enum in the owning cut
- File map omits an in-cut error type (or enum)
- File map invents a second convention on an existing-repo prompt (colocate on a `tests/` house, or distant `tests/` on a colocated house)
- 2–5 minute step list / code novel as the plan contract
- Aborting `write-spec` because a mixed dump mentioned classes
- Auto-continue spec → design → plan because the dump named all three
- `write-design` or `write-plan` running before grain
- After grain, taking `write-plan` when design is in the ask (and no stale-spec pick)
- After grain, re-running `write-spec` on a mixed dump / spec+design+plan unless they asked to rewrite In/Out or a pick would stale it
