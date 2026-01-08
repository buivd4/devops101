#!/usr/bin/env python3

# Lab 4 Solution: Control Logic

print("=== Lab 4: Control Logic ===")

fuel_level = 85

# Fuel level check
if fuel_level > 80:
    print("Fuel level: Excellent")
elif fuel_level > 60:
    print("Fuel level: Good")
elif fuel_level > 40:
    print("Fuel level: Moderate")
else:
    print("Warning: Low fuel!")

# Countdown using for loop
print("\nCountdown:")
for i in range(10, 0, -1):
    print(f"{i}...", end=" ")
print("Launch!")

# Crew list iteration
crew = ["Alice", "Bob", "Charlie"]
print("\nCrew members:")
for member in crew:
    print(f"  - {member}")

# System checks with while loop
print("\nSystem checks:")
systems = ["engines", "navigation", "communication", "life_support"]
checked_systems = []
while len(checked_systems) < len(systems):
    system = systems[len(checked_systems)]
    checked_systems.append(system)
    print(f"  ✓ {system} - OK")

print("\nAll systems operational!")

print("Lab 4 completed!")




