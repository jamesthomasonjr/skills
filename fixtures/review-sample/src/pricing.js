const TAX_RATE = 0.08;

function unusedFormatCents(n) {
  return n.toFixed(2);
}

function priceCart(items, couponRate) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("items must be a non-empty array");
  }

  let subtotal = 0;
  for (const item of items) {
    if (typeof item.qty !== "number" || item.qty <= 0) {
      throw new Error("qty must be a positive number");
    }
    if (typeof item.price !== "number" || item.price < 0) {
      throw new Error("price must be a non-negative number");
    }
    subtotal += item.qty * item.price;
  }

  let discount = 0;
  if (couponRate) {
    discount = subtotal * couponRate;
  }

  const total = Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
  return { subtotal, discount, total };
}

module.exports = { priceCart, TAX_RATE };
