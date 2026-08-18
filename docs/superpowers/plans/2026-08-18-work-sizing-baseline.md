# Work sizing family RED baseline

Date: 2026-08-18
Skills present: none (`size-work` / `shape-*` must not exist)

Five fresh `generalPurpose` subagents. Each prompt was the user sentence plus a hard ban on reading `docs/superpowers/**` and on inventing these skills. Workspace: skills repo root. No application files edited.

## Scenario A — initiative

Prompt: `We need to become the default payments platform for mid-market SaaS: billing, payouts, fraud, and global tax. Break this down so we can plan the next year.`

Observed:
- Grain: company/initiative — correct direction.
- Full spec? **No.**
- Children: four “pillars” + shared “spine,” labeled programs/workstreams — **not an epic inventory**.
- Deep H1/H2/H3 sequencing and ICP strategy — **more than one-level decomposition**.
- Given/When/Then? **No.**
- Files edited? **No.**
- Verbatim: "These are not “platform chores”; they are the product." / "That is enough to allocate teams and dates; it is not enough to start building without a later, narrower spec per program."

## Scenario B — feature

Prompt: `Add coupon codes at checkout for our storefront. Break this into work we can spec later.`

Observed:
- Grain: feature — correct.
- Full spec? **No.**
- Children: nine units mixing checkout UX, admin, and “platform/integrity” chores — **not a clean user-story inventory** (no As a / I want / so that).
- Given/When/Then? **No.**
- Files edited? **No.**
- Verbatim: "Treat the whole thing as one feature; each item below is a unit you can design independently."

## Scenario C — user story

Prompt: `As a shopper, I want to apply a coupon code at checkout so that I get the discount before I pay. Give me enough context that a future agent can write a spec.`

Observed:
- Grain: user story — correct.
- Produced a strong **spec-ready briefing** (intent, open decisions, constraints, suggested spec shape) without writing the spec — **desired shape already**.
- Explored `fixtures/orient-sample` for context.
- Did not implement.
- Skills must still **contract** this shape so thinner replies cannot pass.

## Scenario D — ambiguous epic vs feature

Prompt: `Rebuild our notifications system. Size this work.`

Observed:
- Called it large/unbounded; listed themes to clarify.
- **Did not ask the user to choose a level** (initiative vs epic vs feature).
- No child inventory at any official grain.
- Files edited? **No.**
- Verbatim: "the honest size is **large and unbounded**: many independent workstreams, not one PR."

## Scenario E — task + mixed turn

Prompt: `Rename the legacy stripe_cust_id column to customer_external_id across the codebase, then start doing it.`

Observed:
- Treated as task-sized; **no fake user story**.
- Searched repo; column absent → refused to invent a DB. **Did not implement.**
- Mixed-turn implement pressure **did not fire** (no target code). GREEN needs a fixture with `stripe_cust_id` so hand-back can be tested under real edit temptation.
- Files edited? **No.**

## Failures this family must close

Fired:

- **Initiative → programs + multi-horizon plan, not epic inventory.** A.
- **Feature → mixed story/task list without user-story statements.** B.
- **Ambiguous rebuild → no level ask.** D.
- **Over-decomposition in one turn** (initiative sequencing past epics). A.

Did not fire (still require):

- Spec/plan at initiative or epic grain.
- Skipping levels (initiative → stories).
- Fake user story for a pure chore.
- Mixed-turn implement when editable target exists.
- Thin story brief with no problem/context/acceptance sketch (C was already good).

## GREEN

Skills present: size-work, shape-initiative, shape-epic, shape-feature, shape-story, shape-task, levels.md

Fixture: `fixtures/work-sizing-sample/` with `stripe_cust_id`. Five fresh subagents instructed to read `size-work` first and follow handoff.

### A — initiative

- classified_level: initiative; shape-initiative
- child_grain: epics (5); no features/stories under initiative
- has_horizon_plan: **no** (RED had H1/H2/H3)
- has_full_spec: no; files edited: no
- Pass.

### B — feature

- shape-feature; child_grain: stories (7)
- every_child_has_user_story_statement: **yes**
- has_bare_platform_tasks_as_children: **no** (RED mixed platform chores in)
- has_full_spec / GWT catalog: no
- Pass.

### C — user story

- shape-story; problem_context + acceptance_sketch: yes
- has_full_spec: no; suggested_next_step_named: yes (`/speckit.specify`)
- implemented / files edited: no
- Pass.

### D — ambiguous

- ambiguous epic vs feature; asked_user_to_choose: **yes**; started_shaping: **no**
- Pass (closes RED “no level ask”).

### E — task + mixed turn

- shape-task; fake_user_story: no
- inspected fixture; implemented_or_edited: **no**; handed_back_for_new_message: **yes**
- files_edited_paths: none
- Pass.

### F — known bug with locus (enrichment)

- Prompt shape: known TypeError locus in `processOrder`
- → `shape-task`; no fake story; no story inventory
- Pass (PR #3 verification).

### G — vague bug (enrichment)

- Prompt: “Something's broken in checkout sometimes”
- → out of family; diagnosing/triage handoff; no shaping
- Pass (PR #3 verification).

### H — spike without explicit time box (enrichment)

- Prompt: “Spike: Should we store coupon redemptions in Postgres or Redis?”
- → `shape-task` spike flavor; proposed time box; done-when = decision
- Pass (PR #3 verification).

### I — foggy research (enrichment)

- Prompt: “Research notifications”
- → out of family; wayfinder/research/grill handoff
- Pass (PR #3 verification).

### J — intermittent with named locus (precedence)

- Prompt: “auth.test.ts is flaky sometimes”
- → `shape-task` (locus wins over intermittent→diagnosing)
- Pass.

### K — thin As-a without locus (precedence)

- Prompt: As-a + “checkout … broken sometimes” with no locus
- → out of family; diagnosing wins over `shape-story`
- Pass.

## GREEN verdict

Scenarios A–E passed on the original family. Enrichment scenarios F–I passed on PR #3. Precedence scenarios J–K passed with the overlapping-bug / Task-definition fix.
