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

### Script Development with uv and PEP 723
When creating standalone Python scripts, use PEP 723 inline metadata:
- Start scripts with `#!/usr/bin/env -S uv run --script` shebang
- Use `# /// script` metadata block for dependencies:
```python
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "requests<3",
#   "rich",
# ]
# ///
```
- Keep dependencies minimal and use version constraints
- Make scripts executable with `chmod +x script_name`
- Scripts can be run directly (`./script_name`) or with `uv run script_name`
- This creates disposable virtual environments automatically