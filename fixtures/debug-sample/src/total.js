function cartTotal(items, couponRate, taxRate) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("items must be a non-empty array");
  }
  const subtotal = items.reduce((sum, item) => sum + item.qty * item.price, 0);
  const discount = subtotal * (couponRate || 0);
  // BUG: tax applied to pre-discount subtotal
  const tax = subtotal * (taxRate || 0);
  return Math.round((subtotal - discount + tax) * 100) / 100;
}

module.exports = { cartTotal };
