#!/bin/bash

# Lab 8 Solution: Uninstall Jenkins Script

echo "=== Lab 8: Uninstall Jenkins ==="

# Get optional argument for data removal
REMOVE_DATA="${1:-keep-data}"

# Function to detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
    elif [ -f /etc/redhat-release ]; then
        OS=$(cat /etc/redhat-release | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
        OS_VERSION=$(cat /etc/redhat-release | grep -oE '[0-9]+' | head -1)
    else
        echo "Error: Cannot detect operating system"
        exit 1
    fi
    
    # Normalize OS names
    case "$OS" in
        ubuntu|debian)
            OS_TYPE="debian"
            ;;
        rhel|centos|fedora|rocky|almalinux)
            OS_TYPE="redhat"
            ;;
        *)
            echo "Error: Unsupported operating system: $OS"
            echo "Supported OS: Ubuntu, Debian, RHEL, CentOS, Fedora"
            exit 1
            ;;
    esac
    
    echo "Detected OS: $OS $OS_VERSION"
}

# Function to check if Jenkins is installed
check_jenkins_installed() {
    if command -v jenkins &> /dev/null; then
        return 0
    fi
    
    # Check if jenkins package is installed
    if [ "$OS_TYPE" = "debian" ]; then
        if dpkg -l | grep -q "^ii.*jenkins"; then
            return 0
        fi
    else
        if rpm -qa | grep -q "^jenkins"; then
            return 0
        fi
    fi
    
    return 1
}

# Function to stop and disable Jenkins service
stop_jenkins_service() {
    if command -v systemctl &> /dev/null; then
        if systemctl is-active --quiet jenkins 2>/dev/null || systemctl is-enabled --quiet jenkins 2>/dev/null; then
            echo "Stopping Jenkins service..."
            sudo systemctl stop jenkins
            if [ $? -ne 0 ]; then
                echo "Warning: Failed to stop Jenkins service (may already be stopped)"
            fi
            
            echo "Disabling Jenkins service..."
            sudo systemctl disable jenkins
            if [ $? -ne 0 ]; then
                echo "Warning: Failed to disable Jenkins service"
            fi
            
            echo "Jenkins service stopped and disabled"
        else
            echo "Jenkins service is not running or enabled"
        fi
    else
        echo "Warning: systemctl not found, skipping service management"
    fi
}

# Function to remove Jenkins package on Debian/Ubuntu
remove_jenkins_debian() {
    echo "Removing Jenkins package..."
    
    if check_jenkins_installed; then
        sudo apt remove -y jenkins
        if [ $? -ne 0 ]; then
            echo "Error: Failed to remove Jenkins package"
            exit 1
        fi
        
        # Also purge to remove configuration files
        sudo apt purge -y jenkins
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to purge Jenkins configuration files"
        fi
        
        # Clean up any remaining dependencies
        sudo apt autoremove -y
        echo "Jenkins package removed successfully"
    else
        echo "Jenkins package is not installed"
    fi
}

# Function to remove Jenkins package on RHEL/CentOS/Fedora
remove_jenkins_redhat() {
    echo "Removing Jenkins package..."
    
    if check_jenkins_installed; then
        if command -v dnf &> /dev/null; then
            sudo dnf remove -y jenkins
        else
            sudo yum remove -y jenkins
        fi
        
        if [ $? -ne 0 ]; then
            echo "Error: Failed to remove Jenkins package"
            exit 1
        fi
        
        echo "Jenkins package removed successfully"
    else
        echo "Jenkins package is not installed"
    fi
}

# Function to remove Jenkins repository files on Debian/Ubuntu
remove_repository_debian() {
    echo "Removing Jenkins repository files..."
    
    local removed=0
    
    # Remove repository list file
    if [ -f /etc/apt/sources.list.d/jenkins.list ]; then
        sudo rm -f /etc/apt/sources.list.d/jenkins.list
        removed=1
    fi
    
    # Remove GPG keyring
    if [ -f /etc/apt/keyrings/jenkins-keyring.asc ]; then
        sudo rm -f /etc/apt/keyrings/jenkins-keyring.asc
        removed=1
    fi
    
    if [ $removed -eq 1 ]; then
        # Update package list
        sudo apt update
        echo "Repository files removed"
    else
        echo "Repository files not found"
    fi
}

# Function to remove Jenkins repository files on RHEL/CentOS/Fedora
remove_repository_redhat() {
    echo "Removing Jenkins repository files..."
    
    if [ -f /etc/yum.repos.d/jenkins.repo ]; then
        sudo rm -f /etc/yum.repos.d/jenkins.repo
        echo "Repository file removed"
    else
        echo "Repository file not found"
    fi
}

# Function to remove Jenkins data directory and user
remove_jenkins_data() {
    echo "Removing Jenkins data directory..."
    
    if [ -d /var/lib/jenkins ]; then
        sudo rm -rf /var/lib/jenkins
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to remove Jenkins data directory"
        else
            echo "Jenkins data directory removed"
        fi
    else
        echo "Jenkins data directory not found"
    fi
    
    echo "Removing Jenkins user and group..."
    
    # Remove jenkins user if it exists
    if id jenkins &>/dev/null; then
        sudo userdel jenkins
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to remove jenkins user"
        else
            echo "Jenkins user removed"
        fi
    else
        echo "Jenkins user not found"
    fi
    
    # Remove jenkins group if it exists
    if getent group jenkins &>/dev/null; then
        sudo groupdel jenkins
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to remove jenkins group"
        else
            echo "Jenkins group removed"
        fi
    else
        echo "Jenkins group not found"
    fi
}

# Main execution
detect_os

# Check if Jenkins is installed
if ! check_jenkins_installed; then
    echo "Jenkins is not installed on this system"
    exit 0
fi

# Handle data removal option
if [ "$REMOVE_DATA" = "remove-data" ]; then
    echo "WARNING: This will remove all Jenkins data including jobs, configurations, and plugins!"
    read -p "Are you sure you want to continue? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Uninstallation cancelled"
        exit 0
    fi
    echo "Jenkins data will be completely removed"
else
    echo "Jenkins data will be kept at /var/lib/jenkins"
fi

# Stop Jenkins service
stop_jenkins_service

# Remove Jenkins package based on OS type
if [ "$OS_TYPE" = "debian" ]; then
    remove_jenkins_debian
    remove_repository_debian
elif [ "$OS_TYPE" = "redhat" ]; then
    remove_jenkins_redhat
    remove_repository_redhat
fi

# Remove data if requested
if [ "$REMOVE_DATA" = "remove-data" ]; then
    remove_jenkins_data
    echo ""
    echo "Jenkins uninstalled completely! (All data removed)"
else
    echo ""
    echo "Jenkins uninstalled successfully! (Data preserved at /var/lib/jenkins)"
fi

echo "Lab 8 completed!"


