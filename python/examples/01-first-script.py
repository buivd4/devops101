#!/usr/bin/env python3

# Example 1: Your First Python Script
# This script demonstrates basic Python scripting

print("Hello, World!")
print("This is my first Python script")

# Import and use standard library modules
import datetime
import os

# Get current date and time
current_time = datetime.datetime.now()
print(f"Current date and time: {current_time}")

# Get current user
username = os.getenv('USER', 'Unknown')
print(f"Current user: {username}")




