## Python

### Programming Style
- Always provide the most modern, Pythonic implementation
- Always write complete docs strings
- Always use type hints
- Follow pep8
- Always use type hints
    - Write in `strict` mode
    - No use of `Any`

### Tools
- Use `ruff` for formatting and linting in place of black, flake8, and isort
- Use `mypy` for type checking
    - Always lint in `--strict` mode
- Use `pytest` for all testing
- Use `uv` for everything package related
- `uv run SCRIPT.PY`: Run the Python script using uv
- `uv add PACKAGE`: Add a package
    - Avoid doing `uv pip`