---
description: High-level takeaways distilled from Lacy runtime traces.
---
# Runtime insights

Source index: [[MEMORY/SESSIONS/session-logs/runtime-index.yaml]]

## Distilled takeaways

- The runtime matured from brittle bootstrap behavior into a mostly stable API + dashboard pair.
- The dominant failures are dependency and socket issues, not business-logic failures.
- The health and panel paths are the most reliable signals of a good launch.
- Websocket support is still incomplete or intentionally absent; its 501s are informational.
- Duplicate starts are the main source of noisy logs and should be prevented at the launcher boundary.

## Bottom line

When the environment is correct and only one instance is active, the runtime comes up cleanly and stays usable.
