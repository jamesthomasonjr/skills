# Parked eval — checkout page

GREEN must match this card unless the specify-work letters themselves force a change (they must not).

Second-domain novel for job names + colocate-by-cut. Not a
size-work scorecard. Stories stay journeys. A class name used
as a story is RED. Do not invent Fibonacci or UI/ADR letters.

After `write-spec`, grain exists (`shape-feature`, not epic).
Do not invoke `size-work` from this family.

| Slot | Value |
|---|---|
| Grain | `shape-feature` (not epic). After grain, next is `write-design` (then `write-plan`). Do not invoke. |
| Inventory | User-journey stories for charging a card once and showing a receipt. Fail epic. Fail class / provider children. |
| Out | Saved cards; refunds; subscriptions |
| Separate | `shape-task` spike for which payment processor (decision brief, not a production story, not swallowed) |
| After grain | Class / ISP / stacked-PR work — not inventory |

Design names are **agent-chosen** and must **name the job**.
GREEN scores synonym job names, not one token.
`CardCharger` + `StripeCardCharger`, `PaymentClient` +
`StripePaymentClient`, `ChargeGateway` + `BraintreeChargeGateway`
(or equivalent) GREEN. Requiring one of those strings as the
only token RED. Fail cute / poetry-only names (`Till`, `Gold`,
`TodayTill`, `ComposeCharge`).

File map scores **colocate by cut**, not a weather Location
tree: capability folder first, port + first impl together,
tests next to the file. Acceptable nests:
`Capability/Provider/`, `Capability/CapabilityProvider/`,
`CapabilityProvider/`. Fail a flat `src/*.ts` dump. Fail
requiring hexagonal `domain/` / `ports/` / `adapters/` /
`views/` as the only legal tree. Fail a distant `tests/` tree.

Do not treat this file as a user prompt. The input dump is
`charge-dump.md`. Scorer letters: `eval-letters.md`.
GREEN prompts must not open this file, `weather-eval.md`, or
`eval-letters.md`.
