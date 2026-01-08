#!/bin/bash

# Example 4: Control Logic (if/else, loops)
# Demonstrates conditional statements and loops

# If/else statement
number=$1

if [ -z "$number" ]; then
    echo "Error: Please provide a number"
    exit 1
fi

if [ "$number" -gt 10 ]; then
    echo "$number is greater than 10"
elif [ "$number" -eq 10 ]; then
    echo "$number is equal to 10"
else
    echo "$number is less than 10"
fi

# While loop
counter=1
echo "Counting from 1 to 5:"
while [ $counter -le 5 ]; do
    echo "Counter: $counter"
    counter=$((counter + 1))
done

# For loop
echo "Iterating over a list:"
for planet in mercury venus earth mars; do
    echo "Planet: $planet"
done

# Case statement
case "$2" in
    start)
        echo "Starting mission..."
        ;;
    stop)
        echo "Stopping mission..."
        ;;
    status)
        echo "Checking status..."
        ;;
    *)
        echo "Unknown command: $2"
        ;;
esac





