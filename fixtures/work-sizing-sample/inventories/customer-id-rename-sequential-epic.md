# Epic: Rename customer external id (sequence-first)

Outcome: `stripe_cust_id` is gone; every read and write uses `customer_external_id`.

## Feature inventory (priority = expand-contract sequence)

1. **Add customer_external_id column** — Expand-contract: new column exists beside the old one. Priority 1.
2. **Dual-write both columns** — Writes keep old and new in sync. Priority 2.
3. **Backfill existing rows** — Copy `stripe_cust_id` into `customer_external_id`. Priority 3.
4. **Cut reads to customer_external_id** — Shoppers and jobs stop reading `stripe_cust_id`. Priority 4.
5. **Drop stripe_cust_id** — Column and fixture field removed. Priority 5.
