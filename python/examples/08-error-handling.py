#!/usr/bin/env python3

# Example 8: Error Handling
# Demonstrates try/except blocks and error handling

# Basic try/except
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Error: Cannot divide by zero!")

# Multiple exception types
try:
    number = int("abc")
    result = 10 / number
except ValueError as e:
    print(f"Value error: {e}")
except ZeroDivisionError as e:
    print(f"Division error: {e}")

# Try/except/else/finally
def divide_numbers(a, b):
    try:
        result = a / b
    except ZeroDivisionError:
        print("Cannot divide by zero!")
        return None
    except TypeError:
        print("Invalid input type!")
        return None
    else:
        print(f"Division successful: {result}")
        return result
    finally:
        print("Division operation completed")

print("\nDividing 10 by 2:")
divide_numbers(10, 2)

print("\nDividing 10 by 0:")
divide_numbers(10, 0)

# Raising exceptions
def check_fuel_level(fuel):
    if fuel < 100:
        raise ValueError(f"Fuel level too low: {fuel}. Minimum required: 100")
    return fuel

try:
    check_fuel_level(50)
except ValueError as e:
    print(f"\nFuel check failed: {e}")

# Using assert
def validate_crew_size(size):
    assert size > 0, "Crew size must be positive"
    assert size <= 10, "Crew size cannot exceed 10"
    return size

try:
    validate_crew_size(15)
except AssertionError as e:
    print(f"\nAssertion error: {e}")




