#!/bin/bash

###############################################################################
# Service Status Check - Use Case Script
# 
# This script checks the status of system services:
# - Lists all running systemd services
# - Identifies failed services
# - Generates service status report
#
# Usage:
#   ./service-status.sh
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
    
    print_info "Checking service status..."
    
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local report_dir="${REPORT_DIR:-${script_dir}/reports}"
    local services_file="${report_dir}/services-$(date '+%Y%m%d-%H%M%S').txt"
    
    {
        echo "=== Service Status Report ==="
        echo "Generated: $(date)"
        echo ""
        
        if command -v systemctl &>/dev/null; then
            echo "--- Systemd Services (Running) ---"
            systemctl list-units --type=service --state=running --no-pager | head -20
            echo ""
            
            echo "--- Failed Services ---"
            local failed_services=$(systemctl list-units --type=service --state=failed --no-pager)
            if [[ -n "$failed_services" ]]; then
                echo "$failed_services"
            else
                echo "No failed services found"
            fi
        else
            echo "Systemd not available on this system"
            echo ""
            echo "--- Alternative Service Check ---"
            if command -v service &>/dev/null; then
                service --status-all 2>/dev/null || echo "Service command output not available"
            fi
        fi
        
    } | tee "${services_file}"
    
    print_success "Service status report saved to: ${services_file}"
    log "INFO" "Service status check completed"
}

# Run main function
main "$@"

