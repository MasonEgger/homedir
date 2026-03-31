## Error Handling

- Trust internal code. Don't wrap everything in try/catch "just in case."
- Validate at system boundaries: user input, external APIs, file I/O, network calls.
- Fail fast and loud. Let errors propagate rather than silently swallowing them.
- Use specific exception types, not generic catches. Handle what you can recover from, let the rest bubble up.
- Don't add fallbacks or defaults for scenarios that shouldn't happen - if it happens, we want to know.
