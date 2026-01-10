#!/usr/bin/env python3

# Lab 7: System Monitoring Script
# 
# Instructions:
# Create a system monitoring script that:
# 1. Continuously monitors CPU and Memory usage of the operating system
# 2. Checks every 5 seconds (use time.sleep(5))
# 3. When Memory usage > 80% OR CPU utilization > 80%, log to monitoring.log file
# 4. Log format: [timestamp] WARNING: CPU Usage: XX%, Memory Usage: XX%
# 5. Use functions to organize your code
# 6. Handle errors appropriately (e.g., when CPU/memory can't be determined)
# 7. Handle KeyboardInterrupt to gracefully stop monitoring
#
# Use platform and subprocess modules to get system information
# For Linux: Use 'free' command for memory, 'top -bn1' for CPU
# For macOS: Use 'vm_stat' for memory, 'sysctl vm.loadavg' for CPU
# You can also try using psutil library if available (optional enhancement)
#
# Example Usage:
#   python3 lab-07-monitoring.py
#
# Example Output (when threshold exceeded):
# === System Monitoring Started ===
# Monitoring CPU and Memory usage...
# Press Ctrl+C to stop
#
# [2024-01-15 14:30:45] WARNING: CPU Usage: 85.23%, Memory Usage: 82.15%
#
# Example monitoring.log file content:
# [2024-01-15 14:30:45] WARNING: CPU Usage: 85.23%, Memory Usage: 82.15%
# [2024-01-15 14:30:50] WARNING: CPU Usage: 88.50%, Memory Usage: 81.20%

import subprocess
import time
from datetime import datetime

print("=== System Monitoring Started ===")
print("Monitoring CPU and Memory usage...")
print("Press Ctrl+C to stop\n")

# Your code here
# TODO: Create get_cpu_usage() function to get CPU usage percentage
# TODO: Create get_memory_usage() function to get Memory usage percentage
# TODO: Create log_to_file() function to log warnings to monitoring.log
# TODO: Create main monitoring loop that:
#   - Runs continuously (while True)
#   - Gets CPU and Memory usage
#   - Checks if either > 80%
#   - Logs to file if threshold exceeded
#   - Waits 5 seconds before next check
#   - Handles KeyboardInterrupt gracefully
# TODO: Implement error handling for cases where CPU/memory can't be determined
# TODO: Call main monitoring loop

print("Monitoring stopped!")
