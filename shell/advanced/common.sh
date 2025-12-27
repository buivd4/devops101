#!/bin/bash

###############################################################################
# Common Utilities for Linux System Manager Scripts
# 
# This file contains shared functions and configuration used by all
# system management scripts.
#
# Source this file in your scripts:
#   source "$(dirname "$0")/common.sh"
###############################################################################

# Prevent multiple sourcing - but ensure functions are always available
if [[ -z "${LINUX_SYSTEM_MANAGER_COMMON_SOURCED:-}" ]]; then
    export LINUX_SYSTEM_MANAGER_COMMON_SOURCED=1
    
    # Color codes for output
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m' # No Color
    
    # Configuration
    readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    readonly LOG_DIR="${SCRIPT_DIR}/logs"
    readonly REPORT_DIR="${SCRIPT_DIR}/reports"
    readonly BACKUP_DIR="${SCRIPT_DIR}/backups"
    readonly MAX_LOG_AGE_DAYS=30
    readonly DISK_USAGE_THRESHOLD=80
    readonly MEMORY_USAGE_THRESHOLD=85
    readonly CPU_USAGE_THRESHOLD=80
fi

# Initialize directories - always define, even if already sourced
# Use parameter expansion with defaults to handle cases where variables might not be set
init_directories() {
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local log_dir="${LOG_DIR:-${script_dir}/logs}"
    local report_dir="${REPORT_DIR:-${script_dir}/reports}"
    local backup_dir="${BACKUP_DIR:-${script_dir}/backups}"
    mkdir -p "${log_dir}" "${report_dir}" "${backup_dir}"
}

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local log_dir="${LOG_DIR:-${script_dir}/logs}"
    local log_file="${log_dir}/system-manager-$(date '+%Y-%m-%d').log"
    
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${log_file}"
}

# Print colored output
# Use parameter expansion with defaults to handle cases where variables might not be set
print_info() {
    local blue="${BLUE:-}"
    local nc="${NC:-}"
    echo -e "${blue}[INFO]${nc} $*"
}

print_success() {
    local green="${GREEN:-}"
    local nc="${NC:-}"
    echo -e "${green}[SUCCESS]${nc} $*"
}

print_warning() {
    local yellow="${YELLOW:-}"
    local nc="${NC:-}"
    echo -e "${yellow}[WARNING]${nc} $*"
}

print_error() {
    local red="${RED:-}"
    local nc="${NC:-}"
    echo -e "${red}[ERROR]${nc} $*"
}

# Check if running as root (for certain operations)
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_warning "Some operations may require root privileges"
        return 1
    fi
    return 0
}

