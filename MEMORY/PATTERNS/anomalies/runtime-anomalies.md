---
description: Recurring runtime anomalies distilled from Lacy bootstrap and launch traces.
---
# Runtime anomalies

Source index: [[MEMORY/SESSIONS/session-logs/runtime-index.yaml]]

## Repeating anomalies

- Missing Python dependencies early in the lifecycle (`fastapi`, `email.base64mime`) caused fallback behavior or import failures.
- Duplicate launcher invocations produced duplicated log lines and overlapping startup sequences.
- Socket contention showed up as WinError 10048 and WinError 10013 during API or dashboard binding.
- `GET /ws` repeatedly returned 501, indicating the websocket endpoint is not implemented on the current surface.
- `GET /favicon.ico` returned 404 on several browser smoke tests; this is cosmetic, not operational.

## Pattern note

Most anomalies are startup- and environment-related rather than core runtime logic failures.
