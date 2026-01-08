#!/usr/bin/env python3

# Example 5: Functions
# Demonstrates function definition and usage

# Simple function
def greet(name):
    """Print a greeting message."""
    print(f"Hello, {name}!")

greet("Mission Control")

# Function with return value
def calculate_fuel_remaining(start_fuel, used_fuel):
    """Calculate remaining fuel."""
    return start_fuel - used_fuel

remaining = calculate_fuel_remaining(1000, 250)
print(f"Remaining fuel: {remaining} liters")

# Function with default parameters
def launch_countdown(seconds=10):
    """Perform a launch countdown."""
    for i in range(seconds, 0, -1):
        print(f"{i}...")
    print("Launch!")

print("\nDefault countdown:")
launch_countdown()

print("\nCustom countdown:")
launch_countdown(5)

# Function with multiple return values
def get_mission_info():
    """Get mission information."""
    name = "lunar-mission"
    status = "ready"
    crew_size = 3
    return name, status, crew_size

mission_name, status, crew_size = get_mission_info()
print(f"\nMission: {mission_name}")
print(f"Status: {status}")
print(f"Crew size: {crew_size}")

# Lambda function (anonymous function)
square = lambda x: x ** 2
print(f"\nSquare of 5: {square(5)}")

# Using map with lambda
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x**2, numbers))
print(f"Squared numbers: {squared}")




