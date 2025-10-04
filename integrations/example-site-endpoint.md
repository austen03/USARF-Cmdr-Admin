# Website endpoint contract

Accept `POST application/json` with this shape:

```json
{
  "id": "CMDR-3c5e02a9-8c7a-4d89-9d3c-50a6b34d8b53",
  "command": "warn",
  "raw": "warn austen181 \"Reason here\"",
  "executor": "SomeAdmin",
  "executorUserId": 123456,
  "permissionLevel": 5,
  "args": { "player": "austen181", "reason": "Reason here" },
  "argsText": "```player=\"austen181\", reason=\"Reason here\"```",
  "resultText": "Warned austen181",
  "placeId": 0,
  "jobId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "serverTime": 1728000000
}
```

Return `200 OK` (JSON), optionally verify a bearer token via `Authorization` header. Store and display as you like.
