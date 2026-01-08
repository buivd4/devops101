#!/bin/bash

# Lab 5 Solution: Functions

echo "=== Lab 5: Functions ==="

# Create calculate_area function
function calculate_area() {
    local length=$1
    local width=$2
    local area=$((length * width))
    echo $area
}

# Create check_even function
function check_even() {
    local num=$1
    if [ $((num % 2)) -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Create display_info function
function display_info() {
    local name=$1
    local age=$2
    echo "Name: $name, Age: $age"
}

# Test functions
area=$(calculate_area 5 3)
echo "Area of rectangle (5x3): $area"

check_even 4
if [ $? -eq 0 ]; then
    echo "4 is even"
else
    echo "4 is odd"
fi

display_info "Alice" 25

echo "Lab 5 completed!"





