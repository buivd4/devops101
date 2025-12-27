#!/bin/bash

###############################################################################
# Log Cleanup and Rotation - Use Case Script
# 
# This script automates log management tasks:
# - Removes old log files beyond retention period
# - Rotates systemd journal logs
# - Cleans up application-specific log directories
# - Reports space freed
#
# Usage:
#   ./cleanup-logs.sh
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
    
    print_info "Starting log cleanup and rotation..."
    
    local cleaned_count=0
    local total_freed=0
    
    # Common log directories
    local log_dirs=(
        "/var/log"
        "/var/log/apache2"
        "/var/log/nginx"
        "/var/log/syslog"
        "${HOME}/.local/share/logs"
    )
    
    for log_dir in "${log_dirs[@]}"; do
        if [[ ! -d "$log_dir" ]]; then
            continue
        fi
        
        print_info "Processing logs in: ${log_dir}"
        
        # Find and remove old log files
        while IFS= read -r -d '' log_file; do
            if [[ -f "$log_file" ]]; then
                local file_age=$(find "$log_file" -type f -mtime +${MAX_LOG_AGE_DAYS} 2>/dev/null)
                if [[ -n "$file_age" ]]; then
                    local file_size=$(stat -f%z "$log_file" 2>/dev/null || stat -c%s "$log_file" 2>/dev/null || echo 0)
                    print_info "Removing old log: $(basename "$log_file")"
                    rm -f "$log_file"
                    cleaned_count=$((cleaned_count + 1))
                    total_freed=$((total_freed + file_size))
                fi
            fi
        done < <(find "$log_dir" -type f \( -name "*.log" -o -name "*.log.*" \) -print0 2>/dev/null || true)
    done
    
    # Rotate journal logs if systemd is available
    if command -v journalctl &>/dev/null; then
        print_info "Rotating systemd journal logs..."
        journalctl --vacuum-time="${MAX_LOG_AGE_DAYS}d" &>/dev/null || true
    fi
    
    local freed_mb=$((total_freed / 1024 / 1024))
    print_success "Log cleanup completed: ${cleaned_count} files removed, ~${freed_mb}MB freed"
    log "INFO" "Log cleanup: ${cleaned_count} files removed, ${freed_mb}MB freed"
}

# Run main function
main "$@"

