#!/bin/bash

###############################################################################
# Disk Cleanup - Use Case Script
# 
# This script automates disk space cleanup:
# - Cleans package manager caches (APT, YUM, DNF)
# - Removes old temporary files
# - Cleans Docker resources
# - Reports cleanup statistics
#
# Usage:
#   ./disk-cleanup.sh
#
# Note: Some operations may require root privileges
#
# Author: DevOps Automation Team
# Version: 1.0.0
###############################################################################

set -euo pipefail

# Source common utilities
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! source "${_SCRIPT_DIR}/common.sh"; then
    echo "Error: Failed to source common.sh from ${_SCRIPT_DIR}" >&2
    exit 1
fi

# Main function
main() {
    init_directories
    
    print_info "Starting disk cleanup operation..."
    
    local freed_space=0
    
    # Clean package cache (if root)
    if [[ $EUID -eq 0 ]]; then
        if command -v apt-get &>/dev/null; then
            print_info "Cleaning APT package cache..."
            apt-get clean -y &>/dev/null || true
            apt-get autoclean -y &>/dev/null || true
        elif command -v yum &>/dev/null; then
            print_info "Cleaning YUM package cache..."
            yum clean all &>/dev/null || true
        elif command -v dnf &>/dev/null; then
            print_info "Cleaning DNF package cache..."
            dnf clean all &>/dev/null || true
        fi
    else
        print_warning "Skipping package cache cleanup (requires root privileges)"
    fi
    
    # Clean temporary files
    print_info "Cleaning temporary files..."
    local temp_dirs=("/tmp" "/var/tmp" "${HOME}/.cache")
    
    for temp_dir in "${temp_dirs[@]}"; do
        if [[ -d "$temp_dir" ]]; then
            local files_before=$(find "$temp_dir" -type f 2>/dev/null | wc -l)
            find "$temp_dir" -type f -atime +7 -delete 2>/dev/null || true
            local files_after=$(find "$temp_dir" -type f 2>/dev/null | wc -l)
            local removed=$((files_before - files_after))
            if [[ $removed -gt 0 ]]; then
                print_info "Removed ${removed} old files from ${temp_dir}"
            fi
        fi
    done
    
    # Clean Docker if available
    if command -v docker &>/dev/null; then
        print_info "Cleaning Docker resources..."
        docker system prune -f &>/dev/null || true
    fi
    
    print_success "Disk cleanup completed"
    log "INFO" "Disk cleanup completed"
}

# Run main function
main "$@"

