#!/bin/bash

# Lab 7 Solution: Install Jenkins Script (Latest Version)
# Following official documentation: https://www.jenkins.io/doc/book/installing/linux/

echo "=== Lab 7: Install Jenkins ==="

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

# Function to install Jenkins on Debian/Ubuntu (latest/weekly release)
install_jenkins_debian() {
    echo "Installing dependencies..."
    
    # Update package list
    sudo apt update
    if [ $? -ne 0 ]; then
        echo "Error: Failed to update package list"
        exit 1
    fi
    
    # Install Java 21 (required for latest Jenkins)
    echo "Installing Java 21..."
    sudo apt install -y fontconfig openjdk-21-jre
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Java 21"
        exit 1
    fi
    
    # Verify Java installation
    echo "Verifying Java installation..."
    java -version
    
    # Add Jenkins repository (weekly release for latest)
    echo "Adding Jenkins repository..."
    sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
        https://pkg.jenkins.io/debian/jenkins.io-2026.key
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download Jenkins GPG key"
        exit 1
    fi
    
    # Add Jenkins repository to sources list
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
        https://pkg.jenkins.io/debian binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
    if [ $? -ne 0 ]; then
        echo "Error: Failed to add Jenkins repository"
        exit 1
    fi
    
    # Update package list with Jenkins repository
    sudo apt update
    if [ $? -ne 0 ]; then
        echo "Error: Failed to update package list with Jenkins repository"
        exit 1
    fi
    
    # Install Jenkins (latest/weekly release)
    echo "Installing Jenkins (latest version)..."
    sudo apt install -y jenkins
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Jenkins"
        exit 1
    fi
}

# Function to install Jenkins on RHEL/CentOS/Fedora (latest/weekly release)
install_jenkins_redhat() {
    echo "Installing dependencies..."
    
    # Upgrade system packages
    if command -v dnf &> /dev/null; then
        sudo dnf upgrade -y
    else
        sudo yum upgrade -y
    fi
    if [ $? -ne 0 ]; then
        echo "Error: Failed to upgrade system packages"
        exit 1
    fi
    
    # Install Java 21 and fontconfig (required for latest Jenkins)
    echo "Installing Java 21 and fontconfig..."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y fontconfig java-21-openjdk
    else
        sudo yum install -y fontconfig java-21-openjdk
    fi
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Java 21 and fontconfig"
        exit 1
    fi
    
    # Verify Java installation
    echo "Verifying Java installation..."
    java -version
    
    # Add Jenkins repository (weekly release for latest)
    echo "Adding Jenkins repository..."
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
        https://pkg.jenkins.io/redhat/jenkins.repo
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download Jenkins repository file"
        exit 1
    fi
    
    # Import Jenkins GPG key
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2026.key
    if [ $? -ne 0 ]; then
        echo "Error: Failed to import Jenkins GPG key"
        exit 1
    fi
    
    # Install Jenkins (latest/weekly release)
    echo "Installing Jenkins (latest version)..."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y jenkins
    else
        sudo yum install -y jenkins
    fi
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Jenkins"
        exit 1
    fi
    
    # Reload systemd daemon
    sudo systemctl daemon-reload
}

# Function to start and enable Jenkins service
start_jenkins() {
    echo "Starting Jenkins service..."
    
    if command -v systemctl &> /dev/null; then
        # Enable Jenkins to start on boot
        sudo systemctl enable jenkins
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to enable Jenkins service"
        fi
        
        # Start Jenkins service
        sudo systemctl start jenkins
        if [ $? -ne 0 ]; then
            echo "Error: Failed to start Jenkins service"
            exit 1
        fi
        
        # Check Jenkins status
        echo "Checking Jenkins service status..."
        sudo systemctl status jenkins --no-pager -l
        
        echo "Jenkins service started and enabled"
    else
        echo "Warning: systemctl not found, cannot start Jenkins service"
    fi
}

# Main execution
detect_os

# Install Jenkins based on OS type
if [ "$OS_TYPE" = "debian" ]; then
    install_jenkins_debian
elif [ "$OS_TYPE" = "redhat" ]; then
    install_jenkins_redhat
fi

# Start Jenkins service
start_jenkins

# Display success message and password location
echo ""
echo "Jenkins installed successfully!"
echo "Initial admin password location: /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "To get the initial admin password, run:"
echo "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "Jenkins should be accessible at: http://localhost:8080"
echo ""
echo "Note: If Jenkins fails to start because port 8080 is in use, you can change the port by running:"
echo "  sudo systemctl edit jenkins"
echo "  Then add: [Service] Environment=\"JENKINS_PORT=8081\""

echo "Lab 7 completed!"
