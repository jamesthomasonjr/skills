const { describe, it } = require("node:test");
const assert = require("node:assert/strict");
const { getDevicePosition } = require("../../lib/geo/position");

describe("getDevicePosition", () => {
  it("returns a lat/lon pair", () => {
    assert.deepEqual(getDevicePosition(), { lat: 0, lon: 0 });
  });
});
