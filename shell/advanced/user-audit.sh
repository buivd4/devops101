#!/bin/bash

###############################################################################
# User Account Audit - Use Case Script
# 
# This script performs security-focused user account auditing:
# - Lists all system users
# - Identifies users with shell access
# - Checks for users with root privileges
# - Shows recent login history
#
# Usage:
#   ./user-audit.sh
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
    
    print_info "Performing user account audit..."
    
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local report_dir="${REPORT_DIR:-${script_dir}/reports}"
    local audit_file="${report_dir}/user-audit-$(date '+%Y%m%d-%H%M%S').txt"
    
    {
        echo "=== User Account Audit Report ==="
        echo "Generated: $(date)"
        echo ""
        
        echo "--- All Users ---"
        if [[ -f /etc/passwd ]]; then
            awk -F: '{printf "%-15s UID:%-6s GID:%-6s %s\n", $1, $3, $4, $7}' /etc/passwd
        fi
        echo ""
        
        echo "--- Users with Shell Access ---"
        grep -E '/bin/(bash|sh|zsh)$' /etc/passwd | awk -F: '{print $1}' | sort
        echo ""
        
        echo "--- Users with Root Privileges (sudo) ---"
        if [[ -f /etc/sudoers ]]; then
            local sudo_users=$(grep -E '^[^#].*ALL.*NOPASSWD' /etc/sudoers 2>/dev/null)
            if [[ -n "$sudo_users" ]]; then
                echo "$sudo_users"
            else
                echo "No passwordless sudo users found"
            fi
        fi
        echo ""
        
        echo "--- Recently Logged In Users ---"
        if command -v last &>/dev/null; then
            last -n 10 2>/dev/null || echo "Last command not available"
        else
            echo "Last command not available on this system"
        fi
        
    } | tee "${audit_file}"
    
    print_success "User audit report saved to: ${audit_file}"
    log "INFO" "User audit completed"
}

# Run main function
main "$@"

