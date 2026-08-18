-- Fixture schema for work-sizing mixed-turn tests.
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  stripe_cust_id TEXT NOT NULL,
  email TEXT NOT NULL
);
