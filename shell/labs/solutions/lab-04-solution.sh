#!/bin/bash

# Lab 4 Solution: Control Logic

echo "=== Lab 4: Control Logic ==="

# Get number from argument
number=$1

# Validate input
if [ -z "$number" ]; then
    echo "Error: Please provide a number"
    exit 1
fi

# Check if number is positive, negative, or zero
if [ "$number" -gt 0 ]; then
    echo "The number is positive"
elif [ "$number" -lt 0 ]; then
    echo "The number is negative"
else
    echo "The number is zero"
fi

# For loop to count from 1 to number
echo "Counting from 1 to $number:"
for i in $(seq 1 $number); do
    echo "  $i"
done

# While loop for countdown
echo "Countdown from $number:"
counter=$number
while [ $counter -gt 0 ]; do
    echo "  Countdown: $counter"
    counter=$((counter - 1))
done

echo "Lab 4 completed!"





