curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -H "Content-Type: application/json" \
  --data-binary "@./tests/payloads/${1:-"simple"}_input.json"
