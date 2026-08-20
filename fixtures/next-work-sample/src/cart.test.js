const assert = require("assert");
const { cartTotal } = require("./cart");

assert.strictEqual(cartTotal([{ qty: 2, price: 10 }], 0), 21.6);
assert.strictEqual(cartTotal([{ qty: 2, price: 10 }], 0.1), 19.44);
console.log("cart.test.js ok");
