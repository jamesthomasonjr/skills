const TAX_RATE = 0.08;

function cartTotal(items, couponRate) {
  let subtotal = 0;
  for (var i = 0; i < items.length; i++) {
    subtotal += items[i].qty * items[i].price;
  }
  var discount = couponRate ? subtotal * couponRate : 0;
  return Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
}

module.exports = { cartTotal, TAX_RATE };
