#!/usr/bin/env python3

# Lab 3 Solution: Command Line Arguments

import sys

print("=== Lab 3: Command Line Arguments ===")

# Check if at least one argument is provided
if len(sys.argv) < 2:
    print("Error: Please provide a mission name as argument")
    sys.exit(1)

# Get mission name from first argument
mission_name = sys.argv[1]

# Get fuel amount from second argument if provided, otherwise use default
if len(sys.argv) > 2:
    fuel_amount = int(sys.argv[2])
else:
    fuel_amount = 1000

# Get status from third argument if provided, otherwise use default
if len(sys.argv) > 3:
    status = sys.argv[3]
else:
    status = "ready"

# Print all mission information
print(f"Mission name: {mission_name}")
print(f"Fuel amount: {fuel_amount}")
print(f"Status: {status}")

print("Lab 3 completed!")




