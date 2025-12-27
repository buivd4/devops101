#!/bin/bash

###############################################################################
# System Health Check - Use Case Script
# 
# This script performs a comprehensive system health check including:
# - CPU usage monitoring
# - Memory usage analysis
# - Disk space monitoring
# - Load average checks
# - Network connectivity tests
# - Critical service status
#
# Usage:
#   ./health-check.sh
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

# Verify required functions are available
if ! declare -f init_directories >/dev/null 2>&1; then
    echo "Error: init_directories function not found after sourcing common.sh" >&2
    exit 1
fi

# Main function
main() {
    init_directories
    
    print_info "Starting comprehensive system health check..."
    local script_dir="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    local report_dir="${REPORT_DIR:-${script_dir}/reports}"
    local report_file="${report_dir}/health-check-$(date '+%Y%m%d-%H%M%S').txt"
    
    {
        echo "=== System Health Check Report ==="
        echo "Generated: $(date)"
        echo "Hostname: $(hostname)"
        echo "Uptime: $(uptime)"
        echo ""
        
        # CPU Usage
        echo "--- CPU Information ---"
        local cpu_usage=""
        local cpu_threshold="${CPU_USAGE_THRESHOLD:-80}"
        
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS - try multiple methods
            if command -v sysctl &>/dev/null; then
                # Get CPU load from sysctl (works without special permissions)
                local cpu_count=$(sysctl -n hw.ncpu 2>/dev/null)
                local load_avg=$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}')
                if [[ -n "${cpu_count}" && -n "${load_avg}" && "${cpu_count}" =~ ^[0-9]+$ && "${load_avg}" =~ ^[0-9.]+$ ]]; then
                    cpu_usage=$(awk "BEGIN {printf \"%.1f\", ($load_avg / $cpu_count) * 100}" 2>/dev/null)
                fi
            fi
            # If sysctl didn't work, try ps (less accurate)
            if [[ -z "${cpu_usage}" || "${cpu_usage}" == "" ]]; then
                cpu_usage=$(ps aux 2>/dev/null | awk 'NR>1 {sum+=$3} END {printf "%.1f", sum}' 2>/dev/null)
            fi
        elif command -v top &>/dev/null; then
            # Linux
            cpu_usage=$(timeout 2 top -bn1 2>/dev/null | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
        fi
        
        if [[ -n "${cpu_usage}" && "${cpu_usage}" =~ ^[0-9.]+$ ]]; then
            echo "CPU Usage: ${cpu_usage}%"
            if command -v bc &>/dev/null && (( $(echo "${cpu_usage} > ${cpu_threshold}" | bc -l 2>/dev/null) )); then
                print_warning "High CPU usage detected: ${cpu_usage}%"
            else
                print_success "CPU usage is normal: ${cpu_usage}%"
            fi
        else
            echo "CPU Usage: Unable to determine (may require additional permissions)"
        fi
        echo ""
        
        # Memory Usage
        echo "--- Memory Information ---"
        local mem_total=""
        local mem_used=""
        local mem_available=""
        local mem_percent=""
        local mem_threshold="${MEMORY_USAGE_THRESHOLD:-85}"
        
        if [[ "$(uname)" == "Darwin" ]]; then
            # macOS - use vm_stat
            local pages_free=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
            local pages_active=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
            local pages_inactive=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
            local pages_wired=$(vm_stat | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
            local pages_speculative=$(vm_stat | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
            
            local total_pages=$((pages_free + pages_active + pages_inactive + pages_wired + pages_speculative))
            local used_pages=$((pages_active + pages_inactive + pages_wired))
            
            if [[ -n "${total_pages}" && $total_pages -gt 0 ]]; then
                mem_percent=$(awk "BEGIN {printf \"%.2f\", ($used_pages / $total_pages) * 100}")
                local page_size=$(vm_stat | grep "page size" | awk '{print $8}')
                local total_bytes=$((total_pages * page_size))
                local used_bytes=$((used_pages * page_size))
                local free_bytes=$((pages_free * page_size))
                
                mem_total=$(numfmt --to=iec-i --suffix=B $total_bytes 2>/dev/null || echo "$((total_bytes / 1024 / 1024 / 1024))GB")
                mem_used=$(numfmt --to=iec-i --suffix=B $used_bytes 2>/dev/null || echo "$((used_bytes / 1024 / 1024 / 1024))GB")
                mem_available=$(numfmt --to=iec-i --suffix=B $free_bytes 2>/dev/null || echo "$((free_bytes / 1024 / 1024 / 1024))GB")
            fi
        elif command -v free &>/dev/null; then
            # Linux
            local mem_info=$(free -h | grep Mem)
            mem_total=$(echo $mem_info | awk '{print $2}')
            mem_used=$(echo $mem_info | awk '{print $3}')
            mem_available=$(echo $mem_info | awk '{print $7}')
            mem_percent=$(free | grep Mem | awk '{printf("%.2f", $3/$2 * 100.0)}')
        fi
        
        if [[ -n "${mem_total}" ]]; then
            echo "Total Memory: ${mem_total}"
            echo "Used Memory: ${mem_used}"
            echo "Available Memory: ${mem_available}"
            if [[ -n "${mem_percent}" ]]; then
                echo "Memory Usage: ${mem_percent}%"
                if command -v bc &>/dev/null && (( $(echo "${mem_percent} > ${mem_threshold}" | bc -l 2>/dev/null) )); then
                    print_warning "High memory usage detected: ${mem_percent}%"
                else
                    print_success "Memory usage is normal: ${mem_percent}%"
                fi
            fi
        else
            echo "Memory Information: Unable to determine"
        fi
        echo ""
        
        # Disk Usage
        echo "--- Disk Usage ---"
        local disk_threshold="${DISK_USAGE_THRESHOLD:-80}"
        df -h | grep -E '^/dev/' | while read -r line; do
            local filesystem=$(echo $line | awk '{print $1}')
            local usage=$(echo $line | awk '{print $5}' | sed 's/%//')
            local mount_point=$(echo $line | awk '{print $6}')
            
            echo "${filesystem} on ${mount_point}: ${usage}% used"
            
            if [[ -n "${usage}" && "${usage}" =~ ^[0-9]+$ ]] && [[ $usage -gt $disk_threshold ]]; then
                print_warning "Disk usage on ${mount_point} is above threshold: ${usage}%"
            fi
        done
        echo ""
        
        # Load Average
        echo "--- Load Average ---"
        local load_avg=$(uptime | awk -F'load average:' '{print $2}')
        echo "Load Average:${load_avg}"
        echo ""
        
        # Network Connectivity
        echo "--- Network Connectivity ---"
        if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
            print_success "Internet connectivity: OK"
        else
            print_error "Internet connectivity: FAILED"
        fi
        echo ""
        
        # System Services
        echo "--- Critical Services Status ---"
        local services=("sshd" "docker" "nginx" "apache2" "mysql" "postgresql")
        for service in "${services[@]}"; do
            if systemctl is-active --quiet "$service" 2>/dev/null; then
                echo "✓ ${service}: Running"
            elif systemctl list-unit-files 2>/dev/null | grep -q "^${service}"; then
                echo "✗ ${service}: Not running"
            fi
        done
        
    } | tee "${report_file}"
    
    print_success "Health check completed. Report saved to: ${report_file}"
    log "INFO" "Health check completed"
}

# Run main function
main "$@"

