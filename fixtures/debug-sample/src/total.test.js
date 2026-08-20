const { describe, it } = require("node:test");
const assert = require("node:assert/strict");
const { cartTotal } = require("./total");

describe("cartTotal", () => {
  it("applies tax after discount", () => {
    // items $100, 10% coupon, 8% tax → (100 - 10) * 1.08 = 97.2
    assert.equal(cartTotal([{ qty: 1, price: 100 }], 0.1, 0.08), 97.2);
  });
});
