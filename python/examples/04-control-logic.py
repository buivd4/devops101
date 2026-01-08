#!/usr/bin/env python3

# Example 4: Control Logic
# Demonstrates conditional statements and loops

# If/else statements
fuel_level = 85

if fuel_level > 90:
    print("Fuel level: Excellent")
elif fuel_level > 70:
    print("Fuel level: Good")
elif fuel_level > 50:
    print("Fuel level: Moderate")
else:
    print("Fuel level: Low - Warning!")

# For loops
print("\nCounting down:")
for i in range(10, 0, -1):
    print(f"{i}...")

print("Launch!")

# While loops
print("\nWaiting for systems check...")
count = 0
while count < 5:
    count += 1
    print(f"Check {count} complete")

print("All systems ready!")

# Iterating over lists
crew = ["Alice", "Bob", "Charlie"]
print("\nCrew members:")
for member in crew:
    print(f"  - {member}")

# List comprehension
numbers = [1, 2, 3, 4, 5]
squared = [x**2 for x in numbers]
print(f"\nNumbers: {numbers}")
print(f"Squared: {squared}")

# Dictionary iteration
mission_status = {
    "engines": "ready",
    "navigation": "ready",
    "communication": "checking"
}

print("\nMission status:")
for system, status in mission_status.items():
    print(f"  {system}: {status}")




