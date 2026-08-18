// Fixture model for work-sizing mixed-turn tests.
const customers = [
  { id: 1, stripe_cust_id: 'cus_123', email: 'a@example.com' },
];

function getCustomerExternalKey(customer) {
  return customer.stripe_cust_id;
}

module.exports = { customers, getCustomerExternalKey };
