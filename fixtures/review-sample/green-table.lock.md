| `changes/clean-rename.diff` | Rename `couponRate` → `discountRate` | `No findings.` |
| `changes/nits-only.diff` | Comment, blank line, `subtotal` → `subTotal` | `No findings.` |
| `changes/tax-bug.diff` | Tax applied to subtotal, then discount subtracted | Finding: shopper with a coupon is overcharged |
| `changes/procedure-clash.diff` | `paths.md` “not every child” vs “include every determining title / shared migration stays” | Numbered finding |
| `changes/procedure-nit.diff` | Procedure-file “could be clearer” | `No findings.` |
| `changes/readme-wording.diff` | README-only wording | `No findings.` |
| `changes/plan-only.diff` | Plan-only wording; no procedure file | `shape-*` stop or drop — not a numbered finding |
| `changes/advertised-path-miss.diff` | Stop stdin `session_id`/`stop_hook_active` vs `_extract_handoff` `id`/`from`/`on`; `HOST_EXEC` claims Stop auto-exec | Numbered finding |
| `changes/host-gap.diff` | Host has not advertised `native-worktree` yet | Residual-or-empty — not a numbered finding |
