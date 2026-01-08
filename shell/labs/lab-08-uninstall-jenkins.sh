#!/bin/bash

# Lab 8: Uninstall Jenkins Script
#
# Instructions:
# Create a shell script that completely uninstalls Jenkins from the system.
#
# Requirements:
#
# 1. Auto-detect the operating system type:
#    - Ubuntu/Debian (detect via /etc/os-release)
#    - RHEL/CentOS/Fedora (detect via /etc/os-release or /etc/redhat-release)
#    - Exit with error if OS is not supported
#
# 2. Accept an optional argument to control data removal:
#    - No argument or "keep-data": Keep Jenkins data directory (/var/lib/jenkins)
#    - "remove-data": Remove Jenkins data directory completely
#    - Display a warning before removing data
#
# 3. Stop and disable Jenkins service:
#    - Stop Jenkins service using systemctl
#    - Disable Jenkins service from starting on boot
#    - Check if service exists before attempting to stop it
#
# 4. Remove Jenkins package:
#    - Ubuntu/Debian: Use 'apt remove' or 'apt purge'
#    - RHEL/CentOS/Fedora: Use 'yum remove' or 'dnf remove'
#    - Check if Jenkins is installed before attempting removal
#
# 5. Remove Jenkins repository files:
#    - Ubuntu/Debian: Remove /etc/apt/sources.list.d/jenkins.list and /etc/apt/keyrings/jenkins-keyring.asc
#    - RHEL/CentOS/Fedora: Remove /etc/yum.repos.d/jenkins.repo
#    - Only remove if files exist
#
# 6. Optionally remove Jenkins data and user:
#    - If "remove-data" argument provided:
#      * Remove /var/lib/jenkins directory
#      * Remove jenkins user and group (if they exist)
#    - If "keep-data" or no argument:
#      * Keep /var/lib/jenkins directory
#      * Keep jenkins user and group
#
# 7. Use proper error handling throughout
# 8. Display informative messages for each step
#
# Example Output:
# 
# $ ./lab-08-uninstall-jenkins.sh
# === Lab 8: Uninstall Jenkins ===
# Detected OS: Ubuntu 22.04
# Jenkins data will be kept at /var/lib/jenkins
# Stopping Jenkins service...
# Jenkins service stopped and disabled
# Removing Jenkins package...
# Jenkins package removed successfully
# Removing Jenkins repository files...
# Repository files removed
# Jenkins uninstalled successfully! (Data preserved)
#
# $ ./lab-08-uninstall-jenkins.sh remove-data
# === Lab 8: Uninstall Jenkins ===
# Detected OS: CentOS 8
# WARNING: This will remove all Jenkins data including jobs, configurations, and plugins!
# Are you sure you want to continue? (yes/no): yes
# Stopping Jenkins service...
# Jenkins service stopped and disabled
# Removing Jenkins package...
# Jenkins package removed successfully
# Removing Jenkins repository files...
# Repository files removed
# Removing Jenkins data directory...
# Removing Jenkins user and group...
# Jenkins uninstalled completely! (All data removed)
#
# $ ./lab-08-uninstall-jenkins.sh
# === Lab 8: Uninstall Jenkins ===
# Detected OS: Ubuntu 22.04
# Jenkins is not installed on this system
#
# $ ./lab-08-uninstall-jenkins.sh
# Error: Unsupported operating system: macOS
# Supported OS: Ubuntu, Debian, RHEL, CentOS, Fedora

echo "=== Lab 8: Uninstall Jenkins ==="

# Your code here

echo "Lab 8 completed!"


