#!/bin/bash

# Example 8: File Operations
# Demonstrates file and directory operations

# Check if file exists
file_path=$1

if [ -z "$file_path" ]; then
    echo "Usage: $0 <file-path>"
    exit 1
fi

# File tests
if [ -f "$file_path" ]; then
    echo "$file_path is a regular file"
fi

if [ -d "$file_path" ]; then
    echo "$file_path is a directory"
fi

if [ -r "$file_path" ]; then
    echo "$file_path is readable"
fi

if [ -w "$file_path" ]; then
    echo "$file_path is writable"
fi

if [ -x "$file_path" ]; then
    echo "$file_path is executable"
fi

# File information
if [ -f "$file_path" ]; then
    echo "File size: $(wc -c < "$file_path") bytes"
    echo "Line count: $(wc -l < "$file_path")"
fi





