#!/usr/bin/env python3

# Lab 6 Solution: Complete Project - Mission Control System

import sys
import os
from datetime import datetime

def validate_crew_size(size):
    """Validate crew size is between 1 and 10."""
    if size < 1 or size > 10:
        raise ValueError(f"Crew size must be between 1 and 10, got {size}")
    return size

def calculate_fuel_requirement(crew_size):
    """Calculate fuel requirement based on crew size."""
    base_fuel = 1000
    fuel_per_person = 800
    return base_fuel + (crew_size * fuel_per_person)

def perform_system_checks():
    """Perform system checks and return status."""
    systems = ["engines", "navigation", "communication", "life_support"]
    status = {}
    for system in systems:
        status[system] = "operational"
    return status

def create_mission_log(mission_name, crew_size, fuel_required, systems_status):
    """Create and write mission log to file."""
    log_filename = "mission_log.txt"
    
    with open(log_filename, 'w') as f:
        f.write("=" * 50 + "\n")
        f.write("MISSION CONTROL SYSTEM LOG\n")
        f.write("=" * 50 + "\n\n")
        f.write(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Mission: {mission_name}\n")
        f.write(f"Crew size: {crew_size}\n")
        f.write(f"Fuel required: {fuel_required} liters\n\n")
        f.write("System Status:\n")
        for system, status in systems_status.items():
            f.write(f"  - {system}: {status}\n")
        f.write("\nAll systems operational. Mission ready!\n")
    
    return log_filename

print("=== Mission Control System ===")

# Validate command line arguments
if len(sys.argv) < 3:
    print("Error: Please provide mission name and crew size")
    print("Usage: python3 lab-06-solution.py <mission_name> <crew_size>")
    sys.exit(1)

mission_name = sys.argv[1]

try:
    crew_size = int(sys.argv[2])
    validate_crew_size(crew_size)
except ValueError as e:
    print(f"Error: {e}")
    sys.exit(1)

# Calculate fuel requirement
fuel_required = calculate_fuel_requirement(crew_size)

# Perform system checks
systems_status = perform_system_checks()

# Print mission information
print(f"Mission: {mission_name}")
print(f"Crew size: {crew_size}")
print(f"Fuel required: {fuel_required} liters")
print("Systems: All operational")

# Create mission log
try:
    log_file = create_mission_log(mission_name, crew_size, fuel_required, systems_status)
    print(f"\nMission log created: {log_file}")
except Exception as e:
    print(f"Error creating mission log: {e}")
    sys.exit(1)

print("Mission log created successfully!")




