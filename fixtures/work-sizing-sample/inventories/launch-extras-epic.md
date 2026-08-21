# Epic: Coupons launch extras

Outcome: A shopper can apply a named coupon before pay.

Constraints already frozen:
- A coupon is `code + percent + max_redemptions`. Do not reopen.
- Help-center EN FAQ copy is final.
- Hiring banner copy is final: "We're hiring."
- French FAQ lives only in `docs/fr/faq.md`. Hiring banner lives only in `marketing/landing.html`. They share no schema, API, or event with checkout or with each other.

## Feature inventory (priority = shopper value)

1. **Apply coupon at checkout** — Shopper enters a code at checkout and the discount applies. Priority 1.
2. **Admin coupon management** — Merchant creates and retires coupons. Priority 2.
3. **French help-center FAQ** — Translate the frozen EN FAQ into `docs/fr/faq.md`. Priority 3.
4. **Hiring banner** — Static banner on `marketing/landing.html`. Priority 4.
5. **Receipt coupon line** — After purchase, the receipt shows the coupon and amount saved. Priority 5.
