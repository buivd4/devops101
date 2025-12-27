#!/bin/bash

###############################################################################
# Full System Report - Use Case Script
# 
# This script generates a comprehensive system report including:
# - System and hardware information
# - Disk and network information
# - Running processes
# - Installed packages
# - System load and events
#
# Usage:
#   ./full-report.sh
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
    
    print_info "Generating comprehensive system report..."
    
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local report_dir="${REPORT_DIR:-${script_dir}/reports}"
    local report_file="${report_dir}/full-report-$(date '+%Y%m%d-%H%M%S').txt"
    
    {
        echo "=========================================="
        echo "    COMPREHENSIVE SYSTEM REPORT"
        echo "=========================================="
        echo "Generated: $(date)"
        echo "Hostname: $(hostname)"
        echo "Kernel: $(uname -r)"
        echo "OS: $(uname -o)"
        echo ""
        
        echo "--- System Information ---"
        if [[ -f /etc/os-release ]]; then
            grep -E '^(NAME|VERSION|ID)=' /etc/os-release || true
        fi
        echo ""
        
        echo "--- Hardware Information ---"
        if command -v lscpu &>/dev/null; then
            echo "CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs || echo 'N/A')"
        fi
        echo "CPU Cores: $(nproc)"
        echo "Total Memory: $(free -h | grep Mem | awk '{print $2}')"
        echo ""
        
        echo "--- Disk Information ---"
        df -h
        echo ""
        
        echo "--- Network Interfaces ---"
        if command -v ip &>/dev/null; then
            ip addr show 2>/dev/null || echo "Network info not available"
        elif command -v ifconfig &>/dev/null; then
            ifconfig 2>/dev/null || echo "Network info not available"
        else
            echo "Network info not available"
        fi
        echo ""
        
        echo "--- Running Processes (Top 10 by CPU) ---"
        ps aux --sort=-%cpu 2>/dev/null | head -11 || echo "Process info not available"
        echo ""
        
        echo "--- Installed Packages Count ---"
        if command -v dpkg &>/dev/null; then
            echo "Debian/Ubuntu packages: $(dpkg -l | wc -l)"
        elif command -v rpm &>/dev/null; then
            echo "RPM packages: $(rpm -qa | wc -l)"
        else
            echo "Package manager not detected"
        fi
        echo ""
        
        echo "--- System Load ---"
        uptime
        echo ""
        
        echo "--- Recent System Events ---"
        if command -v journalctl &>/dev/null; then
            journalctl -n 20 --no-pager 2>/dev/null || echo "Journal logs not available"
        elif [[ -f /var/log/syslog ]]; then
            tail -20 /var/log/syslog 2>/dev/null || echo "System logs not available"
        else
            echo "System logs not available"
        fi
        
    } | tee "${report_file}"
    
    print_success "Full report generated: ${report_file}"
    log "INFO" "Full system report generated"
}

# Run main function
main "$@"

