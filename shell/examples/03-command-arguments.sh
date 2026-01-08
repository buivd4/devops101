#!/bin/bash

# Example 3: Command Line Arguments
# Demonstrates how to use command line arguments

# $0 is the script name
# $1, $2, $3, etc. are the arguments
# $# is the number of arguments
# $@ is all arguments

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Number of arguments: $#"
echo "All arguments: $@"

# Using first argument as mission name
if [ -n "$1" ]; then
    mission_name=$1
    echo "Mission name: $mission_name"
else
    echo "Error: Please provide a mission name as argument"
    exit 1
fi





