---
name: python-development
description: My python development style and philosophies. This skill should be used whenever writing ANY python code.
---

# Python Development Standards Skill

## Overview
This skill provides comprehensive Python development standards and best practices, emphasizing modern Pythonic code, type safety, and streamlined tooling with `uv`. Use this skill when writing Python code, setting up Python projects, or advising on Python development workflows.

## Core Principles

### Code Quality Standards
Always write Python code that adheres to these non-negotiable standards:

1. **Modern Pythonic Implementation**: Use the latest Python idioms and features appropriate for the target Python version
2. **Complete Documentation**: Every function, class, and module must have comprehensive docstrings
3. **Strict Type Hints**: All code must include type hints with no use of `Any`
4. **PEP 8 Compliance**: Follow PEP 8 style guidelines for all code

### Type Checking Configuration
When using `mypy`, always configure for strict mode:
- Enable `--strict` mode
- No `Any` types allowed
- All function signatures must be fully typed
- All variables must be typed when not inferrable

## Toolchain

### Essential Tools
Use this modern Python toolchain:

- **`ruff`**: All-in-one formatter and linter (replaces black, flake8, and isort)
- **`mypy`**: Type checking in `--strict` mode
- **`pytest`**: All testing needs
- **`nox`**: Test automation across environments
- **`uv`**: All package and dependency management
- **`just`**: Alternative to make, put common development, testing, and build commands in here. Primary runner for the project

### uv Commands
Use these `uv` commands for package management:

- `uv run SCRIPT.py` - Run Python scripts with automatic environment management
- `uv add PACKAGE` - Add dependencies to your project
- **Avoid**: `uv pip` commands - use `uv add` instead

## Script Development with PEP 723

For standalone Python scripts, use PEP 723 inline metadata for self-contained, reproducible scripts.
ONLY use this when the user CLEARLY STATES they are building a script or command line tool.

### Script Structure
```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "requests<3",
#   "rich",
# ]
# ///

"""
Script description here.
"""

def main() -> None:
    """Main function implementation."""
    pass

if __name__ == "__main__":
    main()
```

### PEP 723 Best Practices
- Start with the shebang: `#!/usr/bin/env -S uv run --script`
- Include `# /// script` metadata block immediately after shebang
- Specify minimum Python version in `requires-python`
- List dependencies with appropriate version constraints
- Keep dependencies minimal
- Make scripts executable: `chmod +x script_name.py`
- Scripts can run directly (`./script_name.py`) or via `uv run script_name.py`
- `uv` creates disposable virtual environments automatically

## Package and Module Structure

### Import Standards
Always use absolute imports, never relative imports:
```python
# WRONG - Don't use relative imports
from .module import something
from ..parent import other_thing

# CORRECT - Always use absolute imports
from my_package.module import something
from my_package.parent import other_thing
```

### Module Organization
- Include `__init__.py` in every package and subpackage directory
- Use absolute imports throughout the codebase
- Organize code into logical module hierarchies

## Testing Standards

### Test Framework
- Use `pytest` for all testing needs
- Use `nox` to automate testing across Python versions and environments
- Write comprehensive test suites with clear test names
- Include docstrings in test functions explaining what is being tested

### Test Organization
```python
def test_function_name_should_do_something() -> None:
    """Test that function_name correctly handles X scenario."""
    # Arrange
    input_data = setup_test_data()
    
    # Act
    result = function_name(input_data)
    
    # Assert
    assert result == expected_output
```

## Documentation Standards

### Docstring Format
Use comprehensive docstrings for all public interfaces. These should use RST that is formatted for use with Sphinx
:
```python
def process_data(data: list[str], threshold: int = 10) -> dict[str, int]:
    """
    Process a list of strings and count occurrences above threshold.
    
    Args:
        data: List of strings to process
        threshold: Minimum count to include in results (default: 10)
    
    Returns:
        Dictionary mapping strings to their counts, filtered by threshold
    
    Raises:
        ValueError: If threshold is negative
    
    Examples:
        >>> process_data(["a", "a", "b"], threshold=2)
        {"a": 2}
    """
    pass
```

### Doctest Integration
Use `doctest` to provide executable examples in docstrings:
```python
def calculate_average(numbers: list[float]) -> float:
    """
    Calculate the arithmetic mean of a list of numbers.
    
    Args:
        numbers: List of numeric values to average
    
    Returns:
        The arithmetic mean of the input numbers
    
    Raises:
        ValueError: If the input list is empty
    
    Examples:
        >>> calculate_average([1.0, 2.0, 3.0])
        2.0
        >>> calculate_average([10.0, 20.0])
        15.0
        >>> calculate_average([5.0])
        5.0
        >>> calculate_average([])
        Traceback (most recent call last):
            ...
        ValueError: Cannot calculate average of empty list
    """
    if not numbers:
        raise ValueError("Cannot calculate average of empty list")
    return sum(numbers) / len(numbers)
```

#### Doctest Best Practices
- Include 2-4 representative examples in function docstrings
- Show both typical use cases and edge cases
- Demonstrate expected exceptions using `Traceback` format
- Keep examples simple and focused on the function's behavior
- Use `...` to elide lengthy traceback details
- Run doctests as part of your test suite: `pytest --doctest-modules`
- Place complex test scenarios in separate test files, not doctests

#### Running Doctests
```bash
# Run doctests for a single module
python -m doctest module_name.py -v

# Run doctests with pytest
pytest --doctest-modules

# Add to nox session for automated testing
@nox.session
def doctests(session):
    session.run("pytest", "--doctest-modules", "src/")
```

#### When to Use Doctests

**Use doctests for:**
- Simple, clear examples that illustrate function behavior
- Quick sanity checks for straightforward functions
- Documentation that doubles as verification

**Avoid doctests for:**
- Complex test scenarios (use pytest instead)
- Tests requiring extensive setup or fixtures
- Tests with external dependencies or side effects

## When to Use This Skill

Apply these standards when:
- Writing any Python code
- Setting up new Python projects
- Reviewing or refactoring existing Python code
- Creating Python scripts or utilities
- Building Python packages or libraries
- Configuring Python development environments
- Advising on Python best practices

## Quick Reference Checklist

Before delivering Python code, verify:
- Type hints on all functions and variables
- Comprehensive docstrings
- PEP 8 compliant formatting
- Using `ruff` for linting/formatting
- Using `mypy --strict` for type checking
- Using `pytest` for tests
- Using `uv` for package management
- Absolute imports (no relative imports)
- PEP 723 metadata for standalone scripts
- No `Any` type hints