#!/bin/bash

# Lab 2 Solution: Working with Variables

echo "=== Lab 2: Variables ==="

# Create variables
favorite_color="blue"
favorite_number="42"
current_year=$(date +%Y)

# Display variables
echo "Favorite color: $favorite_color"
echo "Favorite number: $favorite_number"
echo "Current year: $current_year"

# Combine variables
combined_info="${favorite_color}_${favorite_number}"
echo "Combined: $combined_info"

# Use curly braces for clarity
echo "My favorite color is ${favorite_color} and my favorite number is ${favorite_number}"

echo "Lab 2 completed!"





