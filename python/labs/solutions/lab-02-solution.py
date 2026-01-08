#!/usr/bin/env python3

# Lab 2 Solution: Variables and Data Types

print("=== Lab 2: Variables ===")

# Create variables for the mission
mission_name = "mars-exploration"
fuel_amount = 5000
temperature = -195.5
is_ready = True
crew = ["Alice", "Bob", "Charlie", "David"]

# Create mission_data dictionary
mission_data = {
    "mission_name": mission_name,
    "fuel_amount": fuel_amount,
    "temperature": temperature,
    "is_ready": is_ready,
    "crew": crew
}

# Print each variable and its type
print(f"Mission name: {mission_name} (type: {type(mission_name)})")
print(f"Fuel amount: {fuel_amount} (type: {type(fuel_amount)})")
print(f"Temperature: {temperature} (type: {type(temperature)})")
print(f"Is ready: {is_ready} (type: {type(is_ready)})")
print(f"Crew: {crew} (type: {type(crew)})")

# Print mission_data dictionary
print(f"\nMission data: {mission_data}")

print("Lab 2 completed!")




