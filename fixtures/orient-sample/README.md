# orient-sample

Tiny checkout service used to test the codebase-orientation skill family.

There is one journey: a client `POST`s JSON to `/checkout`, `handleCheckout` in `src/server.js` reads the body, and `processOrder` in `src/orders.js` prices the cart.

This is not a real product. Do not add features during orientation tests.
