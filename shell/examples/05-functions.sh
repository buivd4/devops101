#!/bin/bash

# Example 5: Functions in Shell Scripts
# Demonstrates function definition and usage

# Simple function
function greet() {
    echo "Hello, $1!"
}

# Function with return value (using echo)
function add() {
    echo $(( $1 + $2 ))
}

# Function with exit code
function check_file() {
    if [ -f "$1" ]; then
        echo "File $1 exists"
        return 0
    else
        echo "File $1 does not exist"
        return 1
    fi
}

# Function with local variables
function calculate() {
    local num1=$1
    local num2=$2
    local result=$((num1 * num2))
    echo "Result: $result"
}

# Calling functions
greet "World"
greet "Shell Scripting"

sum=$(add 5 3)
echo "Sum of 5 and 3: $sum"

check_file "/etc/passwd"
file_status=$?

calculate 4 7





