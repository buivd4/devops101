#!/usr/bin/env python3

# Example 6: File Operations
# Demonstrates reading from and writing to files

import os

# Writing to a file
mission_log = "mission_log.txt"

with open(mission_log, 'w') as f:
    f.write("Mission Log\n")
    f.write("=" * 40 + "\n")
    f.write("Mission: Lunar Exploration\n")
    f.write("Status: In Progress\n")
    f.write("Crew: Alice, Bob, Charlie\n")

print(f"Created file: {mission_log}")

# Reading from a file
print("\nReading file contents:")
with open(mission_log, 'r') as f:
    content = f.read()
    print(content)

# Reading line by line
print("Reading line by line:")
with open(mission_log, 'r') as f:
    for line in f:
        print(f"  {line.strip()}")

# Appending to a file
with open(mission_log, 'a') as f:
    f.write("Update: All systems operational\n")
    f.write("Time: 14:30:00\n")

print("\nFile after appending:")
with open(mission_log, 'r') as f:
    print(f.read())

# Check if file exists
if os.path.exists(mission_log):
    file_size = os.path.getsize(mission_log)
    print(f"\nFile exists. Size: {file_size} bytes")
else:
    print(f"\nFile {mission_log} does not exist")




