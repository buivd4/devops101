#!/bin/bash

# Lab 6: Complete Project - System Information Script
#
# Instructions:
# Create a comprehensive script that:
#
# 1. Accepts a command as first argument (info, disk, memory, users, or all)
# 2. Uses functions for each operation:
#    - show_info: Display system information (hostname, OS, kernel)
#    - show_disk: Display disk usage
#    - show_memory: Display memory usage
#    - show_users: Display logged-in users
#    - show_all: Display all information
#
# 3. If no argument provided, show usage message
# 4. Use proper error handling
# 5. Format output nicely with headers
#
# Example Output:
# 
# $ ./lab-06-complete-project.sh
# Usage: ./lab-06-complete-project.sh {info|disk|memory|users|all}
#
# $ ./lab-06-complete-project.sh info
# === System Information ===
# Hostname: mycomputer.local
# OS: Darwin
# Kernel: 21.1.0
# Architecture: arm64
#
# $ ./lab-06-complete-project.sh disk
# === Disk Usage ===
# Filesystem      Size   Used  Avail Capacity  Mounted on
# /dev/disk3s1   500Gi  200Gi  300Gi    40%    /
#
# $ ./lab-06-complete-project.sh memory
# === Memory Usage ===
#               total        used        free      shared  buff/cache   available
# Mem:           16Gi        8Gi        4Gi        512Mi        4Gi        7Gi
#
# $ ./lab-06-complete-project.sh users
# === Logged-in Users ===
# johndoe  console  Dec 28 10:30
#
# $ ./lab-06-complete-project.sh all
# === System Information ===
# Hostname: mycomputer.local
# OS: Darwin
# Kernel: 21.1.0
# Architecture: arm64
#
# === Disk Usage ===
# Filesystem      Size   Used  Avail Capacity  Mounted on
# /dev/disk3s1   500Gi  200Gi  300Gi    40%    /
#
# === Memory Usage ===
#               total        used        free      shared  buff/cache   available
# Mem:           16Gi        8Gi        4Gi        512Mi        4Gi        7Gi
#
# === Logged-in Users ===
# johndoe  console  Dec 28 10:30
#
# $ ./lab-06-complete-project.sh invalid
# Error: Unknown command: invalid
# Usage: ./lab-06-complete-project.sh {info|disk|memory|users|all}

echo "=== Lab 6: Complete Project ==="

# Your code here

echo "Lab 6 completed!"
