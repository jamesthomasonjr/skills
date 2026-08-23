# Write-spec blob — weather page (size-work input)

Not user thought-process. This is a already-sharpened `write-spec`
output. Size this. Do not re-run `write-spec`. Do not treat
`eval-letters.md` or `docs/superpowers/**` as the product.

**Outcome** — A single page shows today’s weather for the user’s
current location.

**MVP In**
- Today’s conditions for the device / browser location
- One page

**Later-features Out**
- 3-day, 7-day, and 10-day forecasts
- Location from a URL query

**Approaches**
1. TypeScript + Vite + Vitest + a static page — small, no framework.
2. React + Vite + Vitest — components if the page grows.
3. Next.js — heavier than a single page needs.
Recommended: (1). Stack pick is **explained**, not a spike.

**Open decisions**
- **Spike:** which weather API. Options: Open-Meteo (no key; forecast
  fields may be thinner) vs OpenWeatherMap (key; richer fields).
  Either can change later cuts, auth, and tests. Not demoted — no
  named default that would leave later cuts unchanged.

**Standards** — `SOLID`, `ISP`, `stacked PRs` (labels only).

**Close** — `size-work` next. Not invoked.
