# Feature: Apply WELCOME20 at checkout

Outcome: A shopper can apply WELCOME20 at checkout before pay.

Constraints already frozen:
- WELCOME20 already exists in production. Do not create coupons.
- A coupon is `code + percent + max_redemptions`. Do not reopen.

## User-story inventory (priority = shopper value)

1. **Apply WELCOME20 at checkout** — As a shopper, I want to enter WELCOME20 at checkout so that I get the discount before I pay. Priority 1.
2. **Show savings on the summary** — As a shopper, I want to see how much I saved so that I trust the total. Priority 2.
3. **Discount line on the receipt email** — As a shopper, I want the receipt to show the discount so that I have a record. Priority 3.
4. **Redemption analytics event** — As a merchant, I want a redemption event so that I can see WELCOME20 working. Priority 4.
5. **French help-center FAQ** — As a shopper, I want the frozen EN FAQ in French so that I can read it. Priority 5.
