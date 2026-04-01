---
paths:
  - "**/*.py"
  - "**/alembic/**"
  - "**/migrations/**"
---

## Database (Python)

1. **SQLAlchemy 2.0 generic types** - always use parameterized generics: `sessionmaker[Session]`, `scoped_session[Session]`, not bare `sessionmaker`. Mypy strict mode requires them.
2. **Session cleanup in tests** - SQLAlchemy test fixtures that create engines must use `yield` + `engine.dispose()` for teardown. Python 3.14+ raises `ResourceWarning` for connections left to garbage collection.
3. **Inline test engines** - when creating engines outside fixtures (e.g., error-path tests), wrap in `try/finally` with `engine.dispose()`.
4. **Session context pattern** - use `with session_factory() as session:` for automatic `close()` on exit. Call `session.commit()` explicitly; uncommitted work rolls back when the session closes.
