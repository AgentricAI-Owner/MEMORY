---
description: Practical fixes and known-good responses for recurring runtime issues.
---
# Runtime troubleshooting

Source index: [[MEMORY/SESSIONS/session-logs/runtime-index.yaml]]

## Known fixes

- If `fastapi` is missing, repair the Python environment before starting the API.
- If `email.base64mime` is missing, verify the launcher is using the intended interpreter/runtime bundle.
- If the dashboard fails with WinError 10048, another process is already holding the port; stop the duplicate instance first.
- If the API fails with WinError 10013, treat it as a socket bind permission/conflict problem and check for a running listener.
- `GET /ws` returning 501 is expected on the current surface; do not treat it as a crash.
- `GET /favicon.ico` returning 404 is a cosmetic browser request and can be ignored or fixed later.

## Operating rule

Prefer one launcher instance, one API listener, and one dashboard listener at a time.
