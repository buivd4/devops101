#!/bin/bash

###############################################################################
# Configuration Backup - Use Case Script
# 
# This script backs up important system configuration files:
# - Network configuration
# - System configuration files
# - Service configuration files
# - Creates timestamped archive
#
# Usage:
#   ./backup-config.sh
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
    
    print_info "Backing up system configuration files..."
    
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local backup_dir="${BACKUP_DIR:-${script_dir}/backups}"
    local backup_timestamp=$(date '+%Y%m%d-%H%M%S')
    local backup_path="${backup_dir}/config-backup-${backup_timestamp}"
    mkdir -p "${backup_path}"
    
    # Important configuration files to backup
    local config_files=(
        "/etc/hosts"
        "/etc/resolv.conf"
        "/etc/fstab"
        "/etc/crontab"
        "/etc/ssh/sshd_config"
        "/etc/nginx/nginx.conf"
        "/etc/apache2/apache2.conf"
        "/etc/docker/daemon.json"
    )
    
    local backed_up=0
    
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            local dest_file="${backup_path}$(echo "$config_file" | sed 's/\//_/g')"
            if cp "$config_file" "$dest_file" 2>/dev/null; then
                print_info "Backed up: ${config_file}"
                backed_up=$((backed_up + 1))
            else
                print_warning "Could not backup: ${config_file}"
            fi
        fi
    done
    
    # Create archive
    if [[ $backed_up -gt 0 ]]; then
        cd "${backup_dir}"
        tar -czf "config-backup-${backup_timestamp}.tar.gz" "config-backup-${backup_timestamp}" 2>/dev/null
        rm -rf "config-backup-${backup_timestamp}"
        print_success "Configuration backup completed: ${backed_up} files backed up"
        print_info "Backup archive: ${backup_dir}/config-backup-${backup_timestamp}.tar.gz"
        log "INFO" "Configuration backup: ${backed_up} files"
    else
        print_warning "No configuration files were backed up"
    fi
}

# Run main function
main "$@"

