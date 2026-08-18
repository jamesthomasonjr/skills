---
name: catch-me-up
description: >-
  Router for codebase orientation. Use when the user wants to onboard,
  catch me up on a repo, explain a file/module/class/function, walk through
  a symbol, or asks how a feature works. Classifies depth, selects Catch Me Up
  modes, and hands off. Read-only; does not implement.
---

# Catch Me Up

Build the **user’s** mental model. Do not implement. Do not write files.

This skill does **not** produce the briefing and does **not** walk call graphs. Resolve, classify, pick modes, hand off.

Then read the matching depth `SKILL.md` and [modes.md](modes.md) and work as that skill.

## Hard rules

- Read-only. No edits, no inline comments, no onboarding docs, no journals.
- Mixed turn (“explain this, then change it”): the depth skill finishes the briefing, then **hand back**. Do not implement. **Do not edit in this turn even if the user already asked for a change** — that message is the briefing, not an implement go-ahead. They must send a **new message** after the briefing. Do not discard the change request.
- If you cannot point at a claim, say so.

## 1. Cheap resolve

Run a named-target resolve **before** choosing a depth when the user named a symbol or path.

Allowed in **one** pass:

- One path glob for a named file/folder. Search `**/<name>` (e.g. `**/src/orders.js`), not a non-recursive cwd-only `orders.js`.
- One symbol search (exact identifier) for a named `X`.

Not allowed here: reading bodies to explain them, sampling 3–5 key files, git log, following imports.

| Result | Depth |
|---|---|
| Path to a file or directory | `orient-module` |
| Type / class / module symbol | `orient-module` |
| Function or method symbol | `orient-function` |
| Hits of more than one kind | ask once which they meant |
| Journey phrase, no code locus (“how does checkout work?”) | `orient-repo` **targeted** |
| Zero hits, or a bare name you did not resolve | **ambiguous** — ask once for a path, symbol, or depth. Do not guess `orient-module`. |

“What does `X` do?” is not a depth signal. Resolve `X`, then classify.

## 2. Classify

| Signal | Depth |
|---|---|
| “onboard me”, “catch me up on this repo”, “how is this project structured”, no target named | `orient-repo` **onboard** |
| Resolved file, folder, module, or type | `orient-module` |
| Resolved function or method | `orient-function` |
| Journey, no resolved locus | `orient-repo` **targeted** |
| Journey plus a resolved entry module | `orient-module` at that entry; Feature Trace required |
| Ambiguous after resolve | ask once, then continue |

## 3. Modes

Six modes: Architecture, Convention, Feature Trace, Syntax / API, Testing, History.

**Onboard** (`orient-repo` and no target or journey): ask every time:

> Which modes? Architecture / Convention / Feature Trace / Syntax / Testing / History
> (You can pick several. I’ll stay read-only and brief you.)

If they pick Feature Trace and have not named a journey: one top-level listing plus README/manifest glance, **offer** 1–3 candidate entry paths (CLI, HTTP, test runner). Do not walk them.

**Targeted** (named symbol, path, or journey): infer. Do **not** show the menu. User may add modes. User may not turn off a required lens this turn.

| Depth | Inferred modes |
|---|---|
| repo targeted journey | Feature Trace **required, stays on** + Architecture + Testing. Convention / Syntax / History only if asked or needed. |
| module/class/file | Architecture (local) + Convention + Syntax. Feature Trace required and stays on if they asked “how does it work”. Testing/History only if asked or needed. |
| function | Syntax + Testing. History only if the body is otherwise inexplicable. |

## 4. Hand off

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../orient-repo/SKILL.md` means “next to this skill,” i.e. the `orient-repo` folder that sits beside `catch-me-up`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/orient-*/SKILL.md` does not exist.

If a cwd-relative Read of `../orient-repo/SKILL.md` misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the depth skill by name.

- [../orient-repo/SKILL.md](../orient-repo/SKILL.md)
- [../orient-module/SKILL.md](../orient-module/SKILL.md)
- [../orient-function/SKILL.md](../orient-function/SKILL.md)
- [modes.md](modes.md)

Pass: depth, target path/symbol, onboard vs targeted, selected/inferred modes, mixed-turn change request if any.

Then follow that depth skill. Do not keep a second briefing procedure here.
