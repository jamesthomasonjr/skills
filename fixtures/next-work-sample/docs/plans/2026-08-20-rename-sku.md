# Rename sku to product_code

Goal: rename the `sku` field to `product_code` in this cart fixture.

Done when:

- The plan’s name is the work item; no other features are in scope.
- Callers and tests use `product_code` if that field exists.
- No other cart behavior changes.
