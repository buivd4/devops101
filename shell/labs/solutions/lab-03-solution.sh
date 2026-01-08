#!/bin/bash

# Lab 3 Solution: Command Line Arguments

echo "=== Lab 3: Command Line Arguments ==="

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide at least one argument"
    exit 1
fi

# Get arguments
name=$1
greeting=$2

# Use default greeting if second argument is missing
if [ -z "$greeting" ]; then
    greeting="Hello"
fi

# Display the greeting
echo "${greeting}, ${name}!"

echo "Lab 3 completed!"





