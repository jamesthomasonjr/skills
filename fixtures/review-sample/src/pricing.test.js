const assert = require("assert");
const { priceCart } = require("./pricing");

assert.deepStrictEqual(priceCart([{ qty: 2, price: 10 }], 0), {
  subtotal: 20,
  discount: 0,
  total: 21.6,
});

assert.deepStrictEqual(priceCart([{ qty: 2, price: 10 }], 0.1), {
  subtotal: 20,
  discount: 2,
  total: 19.44,
});

assert.throws(() => priceCart([], 0), /non-empty/);

console.log("pricing.test.js ok");
