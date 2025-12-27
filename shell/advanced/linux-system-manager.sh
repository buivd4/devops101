#!/bin/bash

###############################################################################
# Linux System Manager - Main Wrapper Script
# 
# This is a convenience wrapper that calls individual use case scripts.
# Each use case is now in its own separate file for better modularity.
#
# Usage:
#   ./linux-system-manager.sh [command]
#
# Commands:
#   health-check      - Perform comprehensive system health check
#   cleanup-logs      - Rotate and clean old log files
#   disk-cleanup      - Clean up disk space
#   service-status    - Check status of critical services
#   user-audit        - Audit user accounts and permissions
#   backup-config     - Backup system configuration files
#   full-report       - Generate comprehensive system report
#
# Note: You can also run individual scripts directly:
#   ./health-check.sh
#   ./cleanup-logs.sh
#   etc.
#
# Author: DevOps Automation Team
# Version: 2.0.0
###############################################################################

set -euo pipefail

# Get script directory (temporary, before sourcing common.sh)
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common utilities for colored output
source "${_SCRIPT_DIR}/common.sh"

###############################################################################
# Main Function
###############################################################################
main() {
    if [[ $# -eq 0 ]]; then
        echo "Linux System Manager - DevOps Automation Tool"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  health-check      Perform comprehensive system health check"
        echo "  cleanup-logs      Rotate and clean old log files"
        echo "  disk-cleanup      Clean up disk space"
        echo "  service-status    Check status of critical services"
        echo "  user-audit        Audit user accounts and permissions"
        echo "  backup-config     Backup system configuration files"
        echo "  full-report       Generate comprehensive system report"
        echo ""
        echo "Examples:"
        echo "  $0 health-check"
        echo "  $0 cleanup-logs"
        echo "  $0 full-report"
        echo ""
        echo "Note: You can also run individual scripts directly:"
        echo "  ./health-check.sh"
        echo "  ./cleanup-logs.sh"
        exit 0
    fi
    
    local command=$1
    shift
    
    local script_file="${_SCRIPT_DIR}/${command}.sh"
    
    if [[ ! -f "$script_file" ]]; then
        print_error "Unknown command: ${command}"
        echo "Run '$0' without arguments to see usage"
        exit 1
    fi
    
    # Execute the corresponding script
    bash "$script_file" "$@"
}

# Run main function
main "$@"

