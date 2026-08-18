const assert = require("assert");
const { processOrder } = require("./orders");

assert.deepStrictEqual(
  processOrder({ items: [{ sku: "a", qty: 2, price: 10 }] }),
  { subtotal: 20, discount: 0, total: 21.6 }
);

assert.deepStrictEqual(
  processOrder({ items: [{ sku: "a", qty: 2, price: 10 }], coupon: "SAVE10" }),
  { subtotal: 20, discount: 2, total: 19.44 }
);

assert.throws(() => processOrder({ items: [] }), /non-empty/);
assert.throws(() => processOrder({ items: [{ sku: "a", qty: 0, price: 10 }] }), /qty/);
assert.throws(() => processOrder({ items: [{ sku: "a", qty: 1, price: 10 }], coupon: "NOPE" }), /unknown coupon/);

console.log("orders.test.js ok");
