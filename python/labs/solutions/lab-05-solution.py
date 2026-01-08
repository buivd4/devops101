#!/usr/bin/env python3

# Lab 5 Solution: Functions

print("=== Lab 5: Functions ===")

# Function to calculate remaining fuel
def calculate_fuel_remaining(start, used):
    """Calculate remaining fuel."""
    return start - used

# Function to check system status
def check_system_status(system_name):
    """Check and return system status."""
    return f"System '{system_name}' status: Operational"

# Function to get mission summary
def get_mission_summary():
    """Return mission summary as a tuple."""
    return ("lunar-mission", "active", 3)

# Lambda function to calculate square
square = lambda x: x ** 2

# Call functions and print results
remaining = calculate_fuel_remaining(1000, 250)
print(f"Remaining fuel: {remaining} liters")

system_status = check_system_status("engines")
print(system_status)

mission_name, status, crew_size = get_mission_summary()
print(f"Mission summary: ({mission_name}, {status}, {crew_size})")

result = square(7)
print(f"Square of 7: {result}")

print("Lab 5 completed!")




