#!/usr/bin/env python3

# Lab 1 Solution: Create Your First Python Script

import datetime
import os

print("=== Lab 1: Basic Script ===")

# Display your name
print("Name: Student Name")

# Display current date and time
current_time = datetime.datetime.now()
print(f"Current date and time: {current_time}")

# Display current working directory
current_dir = os.getcwd()
print(f"Current directory: {current_dir}")

# List files in current directory
print("Files in directory:")
files = os.listdir('.')
for file in files:
    print(f"  - {file}")

print("Lab 1 completed!")




