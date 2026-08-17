const COUPONS = {
  SAVE10: 0.1,
};

function processOrder(order) {
  if (!order || !Array.isArray(order.items) || order.items.length === 0) {
    throw new Error("order.items must be a non-empty array");
  }

  let subtotal = 0;
  for (const item of order.items) {
    if (typeof item.qty !== "number" || item.qty <= 0) {
      throw new Error("qty must be a positive number");
    }
    if (typeof item.price !== "number" || item.price < 0) {
      throw new Error("price must be a non-negative number");
    }
    subtotal += item.qty * item.price;
  }

  let discount = 0;
  if (order.coupon) {
    const rate = COUPONS[order.coupon];
    if (rate == null) {
      throw new Error("unknown coupon");
    }
    discount = subtotal * rate;
  }

  const total = Math.round((subtotal - discount) * 1.08 * 100) / 100;
  return { subtotal, discount, total };
}

module.exports = { processOrder, COUPONS };
