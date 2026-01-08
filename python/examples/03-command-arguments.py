#!/usr/bin/env python3

# Example 3: Command Line Arguments
# Demonstrates how to use command line arguments

import sys

# sys.argv is a list containing command-line arguments
# sys.argv[0] is the script name
# sys.argv[1], sys.argv[2], etc. are the arguments

print(f"Script name: {sys.argv[0]}")
print(f"Number of arguments: {len(sys.argv) - 1}")

# Access arguments
if len(sys.argv) > 1:
    print(f"First argument: {sys.argv[1]}")
if len(sys.argv) > 2:
    print(f"Second argument: {sys.argv[2]}")

# All arguments (excluding script name)
all_arguments = sys.argv[1:]
print(f"All arguments: {all_arguments}")

# Using first argument as mission name
if len(sys.argv) > 1:
    mission_name = sys.argv[1]
    print(f"Mission name: {mission_name}")
else:
    print("Error: Please provide a mission name as argument")
    sys.exit(1)




