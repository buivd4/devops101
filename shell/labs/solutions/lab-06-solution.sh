#!/bin/bash

# Lab 6 Solution: Complete Project - System Information Script

echo "=== Lab 6: Complete Project ==="

# Define functions
function show_info() {
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
}

function show_disk() {
    echo "=== Disk Usage ==="
    df -h
}

function show_memory() {
    echo "=== Memory Usage ==="
    if command -v free &> /dev/null; then
        free -h
    else
        # macOS alternative
        vm_stat | head -10
    fi
}

function show_users() {
    echo "=== Logged-in Users ==="
    who
}

function show_all() {
    show_info
    echo ""
    show_disk
    echo ""
    show_memory
    echo ""
    show_users
}

# Main logic with case statement
if [ $# -eq 0 ]; then
    echo "Usage: $0 {info|disk|memory|users|all}"
    exit 1
fi

command=$1
case "$command" in
    info)
        show_info
        ;;
    disk)
        show_disk
        ;;
    memory)
        show_memory
        ;;
    users)
        show_users
        ;;
    all)
        show_all
        ;;
    *)
        echo "Error: Unknown command: $command"
        echo "Usage: $0 {info|disk|memory|users|all}"
        exit 1
        ;;
esac

echo "Lab 6 completed!"





