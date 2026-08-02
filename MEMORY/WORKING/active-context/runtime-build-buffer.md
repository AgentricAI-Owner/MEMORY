---
description: Temporary working buffer for the current Lacy memory build.
---
# Runtime build buffer

This file captures transient build context for the LACY-MEMORY fabric.

## Current build state
- Memory fabric directories are present under `MEMORY/`.
- Canonical runtime artifacts exist under `MEMORY/DOCUMENTATION/agents/Lacy/`.
- Runtime logs have been indexed into `MEMORY/SESSIONS/session-logs/runtime-index.yaml`.
- Derived summaries, anomalies, milestones, and backlinks are in place.

## Purpose
- Track short-lived build context.
- Hold scratch notes while the memory fabric is being assembled.
- Avoid duplicating canonical artifacts elsewhere.
