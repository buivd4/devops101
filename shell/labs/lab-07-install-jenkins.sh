#!/bin/bash

# Lab 7: Install Jenkins Script (Latest Version)
#
# Instructions:
# Create a shell script that installs the latest Jenkins version following the
# official documentation: https://www.jenkins.io/doc/book/installing/linux/
#
# Requirements:
#
# 1. Auto-detect the operating system type:
#    - Ubuntu/Debian (detect via /etc/os-release)
#    - RHEL/CentOS/Fedora (detect via /etc/os-release or /etc/redhat-release)
#    - Exit with error if OS is not supported
#
# 2. Install dependencies based on OS:
#    - Ubuntu/Debian: Install Java 21 (openjdk-21-jre) and fontconfig
#    - RHEL/CentOS/Fedora: Install Java 21 (java-21-openjdk) and fontconfig
#    - Verify Java installation with 'java -version'
#
# 3. Add Jenkins repository and install Jenkins (latest/weekly release):
#    - Ubuntu/Debian: 
#      * Download GPG key to /etc/apt/keyrings/jenkins-keyring.asc
#      * Use weekly release repository: https://pkg.jenkins.io/debian
#      * GPG key URL: https://pkg.jenkins.io/debian/jenkins.io-2026.key
#    - RHEL/CentOS/Fedora:
#      * Download repository file to /etc/yum.repos.d/jenkins.repo
#      * Use weekly release repository: https://pkg.jenkins.io/redhat
#      * Import GPG key: https://pkg.jenkins.io/redhat/jenkins.io-2026.key
#      * Run 'systemctl daemon-reload' after installation
#
# 4. Start and enable Jenkins service using systemctl
# 5. Display initial admin password location
# 6. Use proper error handling throughout
# 7. Display informative messages for each step
#
# Example Output:
# 
# $ ./lab-07-install-jenkins.sh
# === Lab 7: Install Jenkins ===
# Detected OS: Ubuntu 22.04
# Installing dependencies...
# Installing Java 21...
# Verifying Java installation...
# openjdk 21.0.8 2025-07-15
# OpenJDK Runtime Environment (build 21.0.8+9-Debian-1)
# Adding Jenkins repository...
# Installing Jenkins (latest version)...
# Starting Jenkins service...
# Jenkins service started and enabled
# Jenkins installed successfully!
# Initial admin password location: /var/lib/jenkins/secrets/initialAdminPassword
#
# $ ./lab-07-install-jenkins.sh
# === Lab 7: Install Jenkins ===
# Detected OS: CentOS 8
# Installing dependencies...
# Installing Java 21 and fontconfig...
# Verifying Java installation...
# openjdk version "21.0.8"
# Adding Jenkins repository...
# Installing Jenkins (latest version)...
# Starting Jenkins service...
# Jenkins service started and enabled
# Jenkins installed successfully!
# Initial admin password location: /var/lib/jenkins/secrets/initialAdminPassword
#
# $ ./lab-07-install-jenkins.sh
# Error: Unsupported operating system: macOS
# Supported OS: Ubuntu, Debian, RHEL, CentOS, Fedora

echo "=== Lab 7: Install Jenkins ==="

# Your code here

echo "Lab 7 completed!"

