#!/bin/bash

# Example 2: Variables in Shell Scripts
# Demonstrates variable declaration and usage

# Simple variable assignment
mission_name="lunar-mission"
rocket_type="falcon-9"

# Using variables
echo "Mission name: $mission_name"
echo "Rocket type: $rocket_type"

# Variable with command substitution
current_date=$(date)
echo "Current date: $current_date"

# Using curly braces for variable clarity
echo "Status of launch: ${mission_name}_status"

# Environment variable
echo "Current user: $USER"
echo "Home directory: $HOME"





