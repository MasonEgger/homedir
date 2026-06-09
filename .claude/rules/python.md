---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/requirements*.txt"
  - "**/*.j2"
  - "**/*.jinja"
  - "**/*.jinja2"
---

## Python work → load the `python` skill

You are touching Python code or config. **Before writing, editing, or reviewing it, invoke the `python` skill** (Skill tool, name `python` — from the `mmegger-plugins` marketplace). That skill is the single source of truth for Python standards: strict typing, ruff/mypy/pytest/nox, uv workflows, and idioms.

Do not work from remembered Python rules — load the skill so the current standards apply. This file is only a pointer; it intentionally holds no standards of its own (they live in the skill).
