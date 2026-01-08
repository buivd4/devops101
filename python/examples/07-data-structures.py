#!/usr/bin/env python3

# Example 7: Data Structures
# Demonstrates lists, tuples, dictionaries, and sets

# Lists (mutable, ordered)
crew = ["Alice", "Bob", "Charlie"]
print("Crew list:", crew)
crew.append("David")  # Add item
print("After adding David:", crew)
crew.remove("Bob")  # Remove item
print("After removing Bob:", crew)

# Tuples (immutable, ordered)
coordinates = (10.5, 20.3, 30.7)
print(f"\nCoordinates tuple: {coordinates}")
print(f"X coordinate: {coordinates[0]}")

# Dictionaries (mutable, key-value pairs)
mission_data = {
    "name": "lunar-mission",
    "status": "ready",
    "fuel": 1000,
    "crew": ["Alice", "Charlie", "David"]
}
print(f"\nMission data dictionary: {mission_data}")
print(f"Mission name: {mission_data['name']}")
mission_data["launch_date"] = "2025-01-15"  # Add new key
print(f"Updated mission data: {mission_data}")

# Sets (mutable, unordered, unique elements)
system_checks = {"engine", "navigation", "communication"}
print(f"\nSystem checks set: {system_checks}")
system_checks.add("life_support")
print(f"After adding life_support: {system_checks}")

# Set operations
completed_checks = {"engine", "navigation"}
remaining = system_checks - completed_checks
print(f"Remaining checks: {remaining}")

# List comprehensions
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
even_squares = [x**2 for x in numbers if x % 2 == 0]
print(f"\nEven numbers squared: {even_squares}")

# Dictionary comprehensions
crew_roles = {name: f"Astronaut-{i+1}" for i, name in enumerate(crew)}
print(f"Crew roles: {crew_roles}")




