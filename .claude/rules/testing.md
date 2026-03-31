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
