# debug-sample

Tiny cart-total helper used to test the debug skill family.

Bug under test: `cartTotal` in `src/total.js` applies tax to the pre-discount
subtotal instead of the post-discount amount. `src/total.test.js` fails until
that is fixed.

```bash
node --test fixtures/debug-sample/src/total.test.js
```

Do not fix the bug during RED baseline runs. GREEN may fix it only when following
`debug-root-cause` after investigation.
