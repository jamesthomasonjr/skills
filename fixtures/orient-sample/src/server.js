const http = require("http");
const { processOrder } = require("./orders");

function handleCheckout(req, res) {
  let raw = "";
  req.on("data", (chunk) => {
    raw += chunk;
  });
  req.on("end", () => {
    try {
      const order = JSON.parse(raw || "{}");
      const result = processOrder(order);
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify(result));
    } catch (err) {
      res.writeHead(400, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: err.message }));
    }
  });
}

const server = http.createServer((req, res) => {
  if (req.method === "POST" && req.url === "/checkout") {
    handleCheckout(req, res);
    return;
  }
  res.writeHead(404);
  res.end();
});

if (require.main === module) {
  server.listen(3000);
}

module.exports = { handleCheckout, server };
