---
paths:
  - "**/*test*"
  - "**/test*/**"
  - "**/tests/**"
  - "**/conftest.py"
---

## Testing

- Tests MUST cover the functionality being implemented.
- NEVER ignore test output - logs often contain CRITICAL information.
- Test YOUR application logic, not frameworks/libraries.
- DO NOT test trivial code (getters, setters, simple assignments).
- Test behavior and outcomes, not implementation details.
- When uncertain: "Am I testing MY code's logic, or verifying that a library works?"
- Module-level mutable state (dicts, lists, caches) needs an `autouse` fixture that clears it between tests. Write the fixture during RED, not as a REFACTOR afterthought.
