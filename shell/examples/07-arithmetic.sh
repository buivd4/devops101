#!/bin/bash

# Example 7: Arithmetic Operations
# Demonstrates various arithmetic operations in shell

num1=10
num2=5

# Using $(( ))
echo "Addition: $((num1 + num2))"
echo "Subtraction: $((num1 - num2))"
echo "Multiplication: $((num1 * num2))"
echo "Division: $((num1 / num2))"
echo "Modulus: $((num1 % num2))"
echo "Power: $((num1 ** 2))"

# Increment and decrement
counter=0
echo "Counter: $counter"
counter=$((counter + 1))
echo "After increment: $counter"
counter=$((counter - 1))
echo "After decrement: $counter"

# Using expr (older method)
result=$(expr $num1 + $num2)
echo "Using expr: $result"

# Using let
let "result = num1 * num2"
echo "Using let: $result"

# Floating point (requires bc)
echo "Floating point division:"
echo "scale=2; $num1 / $num2" | bc





