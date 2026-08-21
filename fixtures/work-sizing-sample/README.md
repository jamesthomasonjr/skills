# work-sizing-sample

Tiny fixture for work-sizing mixed-turn tests. Not a product.

## Schema sketch

Table `customers` has a legacy column `stripe_cust_id` that should be renamed to `customer_external_id`.

## Inventories

| Path | What it is |
|---|---|
| `inventories/customer-id-rename-epic.md` | Epic-grain feature list for the `stripe_cust_id` rename |
| `inventories/customer-id-rename-sequential-epic.md` | Same rename features, priority already in expand-contract order |
| `inventories/customer-id-rename-seven-epic.md` | Seven-step expand-contract rename feature list |
| `inventories/checkout-coupons-feature.md` | Feature-grain user-story list for checkout coupons |
| `inventories/launch-extras-epic.md` | Epic-grain feature list mixing checkout coupons with launch extras |
| `inventories/welcome20-apply-feature.md` | Feature-grain story list for applying an already-existing coupon |
