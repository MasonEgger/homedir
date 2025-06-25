# Development Guidelines for Claude

## Core Philosophy
- Code should be minimalistic. The least amount of code required to do the job

## Python

### Programming Style
- Always provide the most modern, Pythonic implementation
- Always write complete docs strings
- Always use type hints

### Style
- Follow pep8
- Use ruff for formatting and linting in place of black, flake8, and isort
- Always use type hints, and use strict type hinting.
    - No use of `Any`

### Python packaging
- Use uv for everything package related
- uv run SCRIPT.PY: Run the Python script using uv
- uv add PACKAGE: Add a package
- Avoid doing `uv pip`
- Use `pytest` for all testing

## Development Workflow

### TDD Process - THE FUNDAMENTAL PRACTICE

**CRITICAL**: TDD is not optional. Every feature, every bug fix, every change MUST follow this process:

Follow Red-Green-Refactor strictly:

1. **Red**: Write a failing test for the desired behavior. NO PRODUCTION CODE until you have a failing test.
2. **Green**: Write the MINIMUM code to make the test pass. Resist the urge to write more than needed.
3. **Refactor**: Assess the code for improvement opportunities. If refactoring would add value, clean up the code while keeping tests green. If the code is already clean and expressive, move on.

**Common TDD Violations to Avoid:**

- Writing production code without a failing test first
- Writing multiple tests before making the first one pass
- Writing more production code than needed to pass the current test
- Skipping the refactor assessment step when code could be improved
- Adding functionality "while you're there" without a test driving it

**Remember**: If you're typing production code and there isn't a failing test demanding that code, you're not doing TDD.

#### TDD Example Workflow

```python
"""
Order Processing System - Python TDD Example

This module demonstrates Test-Driven Development (TDD) practices following
the Red-Green-Refactor cycle for order processing functionality.
"""

import pytest
from typing import List
from dataclasses import dataclass


@dataclass
class OrderItem:
    """Represents a single item in an order."""
    price: float
    quantity: int


@dataclass
class Order:
    """Represents a customer order with items and shipping cost."""
    items: List[OrderItem]
    shipping_cost: float


@dataclass
class ProcessedOrder:
    """Represents a processed order with calculated totals."""
    items: List[OrderItem]
    shipping_cost: float
    total: float


# Step 1: Red - Start with the simplest behavior
def test_should_calculate_total_with_shipping_cost():
    """Test that order total includes items and shipping cost."""
    order = Order(
        items=[OrderItem(price=30, quantity=1)],
        shipping_cost=5.99
    )

    processed = process_order(order)

    assert processed.total == 35.99
    assert processed.shipping_cost == 5.99


# Step 2: Green - Minimal implementation
def process_order(order: Order) -> ProcessedOrder:
    """Process an order with basic total calculation."""
    items_total = sum(item.price * item.quantity for item in order.items)

    return ProcessedOrder(
        items=order.items,
        shipping_cost=order.shipping_cost,
        total=items_total + order.shipping_cost
    )


# Step 3: Red - Add test for free shipping behavior
class TestOrderProcessing:
    """Test suite for order processing functionality."""
    
    def test_should_calculate_total_with_shipping_cost(self):
        """Test that order total includes items and shipping cost."""
        order = Order(
            items=[OrderItem(price=30, quantity=1)],
            shipping_cost=5.99
        )

        processed = process_order(order)

        assert processed.total == 35.99
        assert processed.shipping_cost == 5.99

    def test_should_apply_free_shipping_for_orders_over_50(self):
        """Test that orders over £50 qualify for free shipping."""
        order = Order(
            items=[OrderItem(price=60, quantity=1)],
            shipping_cost=5.99
        )

        processed = process_order_with_free_shipping(order)

        assert processed.shipping_cost == 0
        assert processed.total == 60


# Step 4: Green - NOW we can add the conditional because both paths are tested
def process_order_with_free_shipping(order: Order) -> ProcessedOrder:
    """Process an order with free shipping logic."""
    items_total = sum(item.price * item.quantity for item in order.items)
    
    shipping_cost = 0 if items_total > 50 else order.shipping_cost

    return ProcessedOrder(
        items=order.items,
        shipping_cost=shipping_cost,
        total=items_total + shipping_cost
    )


# Step 5: Add edge case tests to ensure 100% behavior coverage
class TestOrderProcessingComplete:
    """Complete test suite with edge cases."""
    
    def test_should_calculate_total_with_shipping_cost(self):
        """Test that order total includes items and shipping cost."""
        order = Order(
            items=[OrderItem(price=30, quantity=1)],
            shipping_cost=5.99
        )

        processed = process_order_final(order)

        assert processed.total == 35.99
        assert processed.shipping_cost == 5.99

    def test_should_apply_free_shipping_for_orders_over_50(self):
        """Test that orders over £50 qualify for free shipping."""
        order = Order(
            items=[OrderItem(price=60, quantity=1)],
            shipping_cost=5.99
        )

        processed = process_order_final(order)

        assert processed.shipping_cost == 0
        assert processed.total == 60

    def test_should_charge_shipping_for_orders_exactly_at_50(self):
        """Test that orders exactly at £50 still charge shipping."""
        order = Order(
            items=[OrderItem(price=50, quantity=1)],
            shipping_cost=5.99
        )

        processed = process_order_final(order)

        assert processed.shipping_cost == 5.99
        assert processed.total == 55.99


# Step 6: Refactor - Extract constants and improve readability
FREE_SHIPPING_THRESHOLD = 50


def calculate_items_total(items: List[OrderItem]) -> float:
    """Calculate the total cost of all items in the order."""
    return sum(item.price * item.quantity for item in items)


def qualifies_for_free_shipping(items_total: float) -> bool:
    """Check if the order qualifies for free shipping based on items total."""
    return items_total > FREE_SHIPPING_THRESHOLD


def determine_shipping_cost(items_total: float, original_shipping_cost: float) -> float:
    """Determine the shipping cost based on whether free shipping applies."""
    if qualifies_for_free_shipping(items_total):
        return 0
    return original_shipping_cost


def process_order_final(order: Order) -> ProcessedOrder:
    """Process an order and calculate the final total including shipping."""
    items_total = calculate_items_total(order.items)
    shipping_cost = determine_shipping_cost(items_total, order.shipping_cost)

    return ProcessedOrder(
        items=order.items,
        shipping_cost=shipping_cost,
        total=items_total + shipping_cost
    )
```

### Refactoring - The Critical Third Step

Evaluating refactoring opportunities is not optional - it's the third step in the TDD cycle. After achieving a green state and committing your work, you MUST assess whether the code can be improved. However, only refactor if there's clear value - if the code is already clean and expresses intent well, move on to the next test.

#### What is Refactoring?

Refactoring means changing the internal structure of code without changing its external behavior. The public API remains unchanged, all tests continue to pass, but the code becomes cleaner, more maintainable, or more efficient. Remember: only refactor when it genuinely improves the code - not all code needs refactoring.

#### When to Refactor

- **Always assess after green**: Once tests pass, before moving to the next test, evaluate if refactoring would add value
- **When you see duplication**: But understand what duplication really means (see DRY below)
- **When names could be clearer**: Variable names, function names, or type names that don't clearly express intent
- **When structure could be simpler**: Complex conditional logic, deeply nested code, or long functions
- **When patterns emerge**: After implementing several similar features, useful abstractions may become apparent

**Remember**: Not all code needs refactoring. If the code is already clean, expressive, and well-structured, commit and move on. Refactoring should improve the code - don't change things just for the sake of change.

#### Refactoring Guidelines

##### 1. Commit Before Refactoring

Always commit your working code before starting any refactoring. This gives you a safe point to return to:

```bash
git add .
git commit -m "feat: add payment validation"
# Now safe to refactor
```

##### 2. Look for Useful Abstractions Based on Semantic Meaning

Create abstractions only when code shares the same semantic meaning and purpose. Don't abstract based on structural similarity alone - **duplicate code is far cheaper than the wrong abstraction**.

```python
# Similar structure, DIFFERENT semantic meaning - DO NOT ABSTRACT
def validate_payment_amount(amount: float) -> bool:
    """Validate payment amount for fraud prevention."""
    return 0 < amount <= 10000

def validate_transfer_amount(amount: float) -> bool:
    """Validate transfer amount for account limits."""
    return 0 < amount <= 10000

# These might have the same structure today, but they represent different
# business concepts that will likely evolve independently.
# Payment limits might change based on fraud rules.
# Transfer limits might change based on account type.
# Abstracting them couples unrelated business rules.

# Similar structure, SAME semantic meaning - SAFE TO ABSTRACT
def format_user_display_name(first_name: str, last_name: str) -> str:
    """Format user name for display."""
    return f"{first_name} {last_name}".strip()

def format_customer_display_name(first_name: str, last_name: str) -> str:
    """Format customer name for display."""
    return f"{first_name} {last_name}".strip()

def format_employee_display_name(first_name: str, last_name: str) -> str:
    """Format employee name for display."""
    return f"{first_name} {last_name}".strip()

# These all represent the same concept: "how we format a person's name for display"
# They share semantic meaning, not just structure
def format_person_display_name(first_name: str, last_name: str) -> str:
    """Format any person's name for display."""
    return f"{first_name} {last_name}".strip()

# Replace all call sites throughout the codebase:
# Before:
# user_label = format_user_display_name(user.first_name, user.last_name)
# customer_name = format_customer_display_name(customer.first_name, customer.last_name)
# employee_tag = format_employee_display_name(employee.first_name, employee.last_name)

# After:
# user_label = format_person_display_name(user.first_name, user.last_name)
# customer_name = format_person_display_name(customer.first_name, customer.last_name)
# employee_tag = format_person_display_name(employee.first_name, employee.last_name)

# Then remove the original functions as they're no longer needed
```

**Questions to ask before abstracting:**

- Do these code blocks represent the same concept or different concepts that happen to look similar?
- If the business rules for one change, should the others change too?
- Would a developer reading this abstraction understand why these things are grouped together?
- Am I abstracting based on what the code IS (structure) or what it MEANS (semantics)?

**Remember**: It's much easier to create an abstraction later when the semantic relationship becomes clear than to undo a bad abstraction that couples unrelated concepts.

##### 3. Understanding DRY - It's About Knowledge, Not Code

DRY (Don't Repeat Yourself) is about not duplicating **knowledge** in the system, not about eliminating all code that looks similar.

```python
# This is NOT a DRY violation - different knowledge despite similar code
def validate_user_age(age: int) -> bool:
    """Validate user age for legal requirements."""
    return 18 <= age <= 100

def validate_product_rating(rating: int) -> bool:
    """Validate product rating for review system."""
    return 1 <= rating <= 5

def validate_years_of_experience(years: int) -> bool:
    """Validate years of experience for job applications."""
    return 0 <= years <= 50

# These functions have similar structure (checking numeric ranges), but they
# represent completely different business rules:
# - User age has legal requirements (18+) and practical limits (100)
# - Product ratings follow a 1-5 star system
# - Years of experience starts at 0 with a reasonable upper bound
# Abstracting them would couple unrelated business concepts and make future
# changes harder. What if ratings change to 1-10? What if legal age changes?

# Another example of code that looks similar but represents different knowledge:
def format_user_display_name(user: User) -> str:
    """Format user name for display."""
    return f"{user.first_name} {user.last_name}".strip()

def format_address_line(address: Address) -> str:
    """Format address for display."""
    return f"{address.street} {address.number}".strip()

def format_credit_card_label(card: CreditCard) -> str:
    """Format credit card for display."""
    return f"{card.type} {card.last_four_digits}".strip()

# Despite the pattern "combine two strings with space and strip", these represent
# different domain concepts with different future evolution paths

# This IS a DRY violation - same knowledge in multiple places
class Order:
    """Order with total calculation."""
    
    def calculate_total(self) -> float:
        """Calculate order total."""
        items_total = sum(item.price for item in self.items)
        shipping_cost = 0 if items_total > 50 else 5.99  # Knowledge duplicated!
        return items_total + shipping_cost

class OrderSummary:
    """Order summary with shipping calculation."""
    
    def get_shipping_cost(self, items_total: float) -> float:
        """Get shipping cost for order."""
        return 0 if items_total > 50 else 5.99  # Same knowledge!

class ShippingCalculator:
    """Calculate shipping costs."""
    
    def calculate(self, order_amount: float) -> float:
        """Calculate shipping cost."""
        return 0 if order_amount > 50 else 5.99  # Same knowledge again!

# Refactored - knowledge in one place
FREE_SHIPPING_THRESHOLD = 50
STANDARD_SHIPPING_COST = 5.99

def calculate_shipping_cost(items_total: float) -> float:
    """Calculate shipping cost based on order total."""
    return 0 if items_total > FREE_SHIPPING_THRESHOLD else STANDARD_SHIPPING_COST

# Now all classes use the single source of truth
class Order:
    """Order with total calculation."""
    
    def calculate_total(self) -> float:
        """Calculate order total."""
        items_total = sum(item.price for item in self.items)
        return items_total + calculate_shipping_cost(items_total)
```

##### 4. Maintain External APIs During Refactoring

Refactoring must never break existing consumers of your code:

```python
# Original implementation
def process_payment(payment: Payment) -> ProcessedPayment:
    """Process a payment with validation and authorization."""
    # Complex logic all in one function
    if payment.amount <= 0:
        raise ValueError("Invalid amount")

    if payment.amount > 10000:
        raise ValueError("Amount too large")

    # ... 50 more lines of validation and processing

    return result

# Refactored - external API unchanged, internals improved
def process_payment(payment: Payment) -> ProcessedPayment:
    """Process a payment with validation and authorization."""
    _validate_payment_amount(payment.amount)
    _validate_payment_method(payment.method)

    authorized_payment = _authorize_payment(payment)
    captured_payment = _capture_payment(authorized_payment)

    return _generate_receipt(captured_payment)

# New internal functions - not exported (prefixed with _)
def _validate_payment_amount(amount: float) -> None:
    """Validate payment amount."""
    if amount <= 0:
        raise ValueError("Invalid amount")

    if amount > 10000:
        raise ValueError("Amount too large")

# Tests continue to pass without modification because external API unchanged
```

##### 5. Verify and Commit After Refactoring

**CRITICAL**: After every refactoring:

1. Run all tests - they must pass without modification
2. Run static analysis (linting, type checking) - must pass
3. Commit the refactoring separately from feature changes

```bash
# After refactoring
uv run pytest          # All tests must pass
uv run ruff check      # All linting must pass
uv run mypy .          # Type checking must be happy

# Only then commit
git add .
git commit -m "refactor: extract payment validation helpers"
```

#### Refactoring Checklist

Before considering refactoring complete, verify:

- [ ] The refactoring actually improves the code (if not, don't refactor)
- [ ] All tests still pass without modification
- [ ] All static analysis tools pass (linting, type checking)
- [ ] No new public APIs were added (only internal ones)
- [ ] Code is more readable than before
- [ ] Any duplication removed was duplication of knowledge, not just code
- [ ] No speculative abstractions were created
- [ ] The refactoring is committed separately from feature changes

#### Example Refactoring Session

```python
# After getting tests green with minimal implementation:
def test_calculates_total_with_items_and_shipping():
    """Test order total calculation."""
    order = {"items": [{"price": 30}, {"price": 20}], "shipping": 5}
    assert calculate_order_total(order) == 55

def test_applies_free_shipping_over_50():
    """Test free shipping for orders over £50."""
    order = {"items": [{"price": 30}, {"price": 25}], "shipping": 5}
    assert calculate_order_total(order) == 55

# Green implementation (minimal):
def calculate_order_total(order: dict) -> float:
    """Calculate order total with shipping."""
    items_total = sum(item["price"] for item in order["items"])
    shipping = 0 if items_total > 50 else order["shipping"]
    return items_total + shipping

# Commit the working version
# git commit -m "feat: implement order total calculation with free shipping"

# Assess refactoring opportunities:
# - The variable names could be clearer
# - The free shipping threshold is a magic number
# - The calculation logic could be extracted for clarity
# These improvements would add value, so proceed with refactoring:

FREE_SHIPPING_THRESHOLD = 50

def calculate_items_total(items: List[dict]) -> float:
    """Calculate total cost of items."""
    return sum(item["price"] for item in items)

def calculate_shipping(base_shipping: float, items_total: float) -> float:
    """Calculate shipping cost."""
    return 0 if items_total > FREE_SHIPPING_THRESHOLD else base_shipping

def calculate_order_total(order: dict) -> float:
    """Calculate order total with shipping."""
    items_total = calculate_items_total(order["items"])
    shipping = calculate_shipping(order["shipping"], items_total)
    return items_total + shipping

# Run tests - they still pass!
# Run linting - all clean!
# Run type checking - no errors!

# Now commit the refactoring
# git commit -m "refactor: extract order total calculation helpers"
```

##### Example: When NOT to Refactor

```python
# After getting this test green:
def test_should_apply_10_percent_discount():
    """Test discount calculation."""
    original_price = 100
    discounted_price = apply_discount(original_price, 0.1)
    assert discounted_price == 90

# Green implementation:
def apply_discount(price: float, discount_rate: float) -> float:
    """Apply discount to price."""
    return price * (1 - discount_rate)

# Assess refactoring opportunities:
# - Code is already simple and clear
# - Function name clearly expresses intent
# - Implementation is a straightforward calculation
# - No magic numbers or unclear logic
# Conclusion: No refactoring needed. This is fine as-is.

# Commit and move to the next test
# git commit -m "feat: add discount calculation"
```

### Commit Guidelines

- Each commit should represent a complete, working change
- Use conventional commits format:
  ```
  feat: add payment validation
  fix: correct date formatting in payment processor
  refactor: extract payment validation logic
  test: add edge cases for payment validation
  ```
- Include test changes with feature changes in the same commit

### Pull Request Standards

- Every PR must have all tests passing
- All linting and quality checks must pass
- Work in small increments that maintain a working state
- PRs should be focused on a single feature or fix
- Include description of the behavior change, not implementation details

## Working with Claude

### Expectations

When working with my code:

1. **ALWAYS FOLLOW TDD** - No production code without a failing test. This is not negotiable.
2. **Think deeply** before making any edits
3. **Understand the full context** of the code and requirements
4. **Ask clarifying questions** when requirements are ambiguous
5. **Think from first principles** - don't make assumptions
6. **Assess refactoring after every green** - Look for opportunities to improve code structure, but only refactor if it adds value
7. **Keep project docs current** - update them whenever you introduce meaningful changes

### Code Changes

When suggesting or making changes:

- **Start with a failing test** - always. No exceptions.
- After making tests pass, always assess refactoring opportunities (but only refactor if it adds value)
- After refactoring, verify all tests and static analysis pass, then commit
- Respect the existing patterns and conventions
- Maintain test coverage for all behavior changes
- Keep changes small and incremental
- Ensure all Python type hints are strict and complete
- Provide rationale for significant design decisions

**If you find yourself writing production code without a failing test, STOP immediately and write the test first.**

### Communication

- Be explicit about trade-offs in different approaches
- Explain the reasoning behind significant design decisions
- Flag any deviations from these guidelines with justification
- Suggest improvements that align with these principles
- When unsure, ask for clarification rather than assuming