#!/usr/bin/env python3

# Example 2: Variables in Python
# Demonstrates variable declaration and usage

# Simple variable assignment
mission_name = "lunar-mission"
rocket_type = "falcon-9"

# Using variables
print(f"Mission name: {mission_name}")
print(f"Rocket type: {rocket_type}")

# Different data types
fuel_amount = 1000  # Integer
temperature = -273.15  # Float
is_ready = True  # Boolean
crew = ["Alice", "Bob", "Charlie"]  # List

print(f"Fuel amount: {fuel_amount} liters")
print(f"Temperature: {temperature}°C")
print(f"Is ready: {is_ready}")
print(f"Crew members: {crew}")

# Dictionary (key-value pairs)
mission_data = {
    "mission_name": mission_name,
    "rocket_type": rocket_type,
    "fuel_amount": fuel_amount,
    "is_ready": is_ready
}

print(f"Mission data: {mission_data}")

# Type checking
print(f"Type of mission_name: {type(mission_name)}")
print(f"Type of fuel_amount: {type(fuel_amount)}")
print(f"Type of is_ready: {type(is_ready)}")




