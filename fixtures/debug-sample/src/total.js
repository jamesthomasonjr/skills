function cartTotal(items, couponRate, taxRate) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("items must be a non-empty array");
  }
  const subtotal = items.reduce((sum, item) => sum + item.qty * item.price, 0);
  const discount = subtotal * (couponRate || 0);
  const afterDiscount = subtotal - discount;
  const tax = afterDiscount * (taxRate || 0);
  return Math.round((afterDiscount + tax) * 100) / 100;
}

module.exports = { cartTotal };
