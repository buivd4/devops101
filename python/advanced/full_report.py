#!/usr/bin/env python3

"""
Full System Report - Use Case Script

This script generates a comprehensive system report:
- System and hardware information
- Disk and network information
- Running processes (top 10 by CPU)
- Installed packages count
- System load and recent events

Usage:
    python3 full_report.py

Author: DevOps Automation Team
Version: 1.0.0
"""

import os
import platform
import socket
import subprocess
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    init_directories, print_info, print_success, log, REPORT_DIR,
    format_bytes
)


def get_system_info():
    """Get system information."""
    return {
        'hostname': socket.gethostname(),
        'system': platform.system(),
        'release': platform.release(),
        'version': platform.version(),
        'machine': platform.machine(),
        'processor': platform.processor(),
    }


def get_top_processes():
    """Get top 10 processes by CPU usage."""
    try:
        result = subprocess.run(
            ['ps', 'aux', '--sort=-%cpu'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n')
            return lines[:11]  # Header + 10 processes
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return []


def get_package_count():
    """Get count of installed packages."""
    package_counts = {}
    
    # Try different package managers
    commands = {
        'dpkg': ['dpkg', '-l'],
        'rpm': ['rpm', '-qa'],
        'pacman': ['pacman', '-Q'],
    }
    
    for pm_name, cmd in commands.items():
        try:
            result = subprocess.run(
                ['which', cmd[0]],
                capture_output=True,
                timeout=2
            )
            if result.returncode == 0:
                count_result = subprocess.run(
                    cmd,
                    capture_output=True,
                    text=True,
                    timeout=30
                )
                if count_result.returncode == 0:
                    # Count lines, subtract 1 for header if dpkg
                    lines = count_result.stdout.strip().split('\n')
                    count = len([l for l in lines if l.strip()])
                    if pm_name == 'dpkg':
                        count -= 5  # Skip header lines
                    package_counts[pm_name] = max(0, count)
        except (FileNotFoundError, subprocess.TimeoutExpired):
            continue
    
    return package_counts


def get_network_info():
    """Get network interface information."""
    try:
        result = subprocess.run(
            ['ip', 'addr', 'show'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            return result.stdout
    except (FileNotFoundError, subprocess.TimeoutExpired):
        # Try ifconfig as fallback
        try:
            result = subprocess.run(
                ['ifconfig'],
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                return result.stdout
        except (FileNotFoundError, subprocess.TimeoutExpired):
            pass
    return None


def main():
    """Main function."""
    init_directories()
    
    print_info("Generating comprehensive system report...")
    report_file = REPORT_DIR / f"full-report-{datetime.now().strftime('%Y%m%d-%H%M%S')}.txt"
    
    system_info = get_system_info()
    top_processes = get_top_processes()
    package_counts = get_package_count()
    network_info = get_network_info()
    
    # Import other modules for their functions
    from health_check import get_disk_usage, get_load_average, get_memory_info, get_cpu_usage
    
    with open(report_file, 'w') as f:
        f.write("=" * 60 + "\n")
        f.write("COMPREHENSIVE SYSTEM REPORT\n")
        f.write("=" * 60 + "\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        # System Information
        f.write("--- System Information ---\n")
        f.write(f"Hostname: {system_info['hostname']}\n")
        f.write(f"System: {system_info['system']}\n")
        f.write(f"Release: {system_info['release']}\n")
        f.write(f"Version: {system_info['version']}\n")
        f.write(f"Machine: {system_info['machine']}\n")
        f.write(f"Processor: {system_info['processor']}\n\n")
        
        # CPU and Memory
        f.write("--- CPU and Memory ---\n")
        cpu_usage = get_cpu_usage()
        if cpu_usage is not None:
            f.write(f"CPU Usage: {cpu_usage:.1f}%\n")
        
        mem_info = get_memory_info()
        if mem_info:
            f.write(f"Total Memory: {format_bytes(mem_info['total'])}\n")
            f.write(f"Used Memory: {format_bytes(mem_info['used'])}\n")
            f.write(f"Available Memory: {format_bytes(mem_info['free'])}\n")
            f.write(f"Memory Usage: {mem_info['percent']:.2f}%\n")
        f.write("\n")
        
        # Disk Usage
        f.write("--- Disk Usage ---\n")
        disk_info = get_disk_usage()
        for disk in disk_info:
            f.write(f"{disk['filesystem']:30} {disk['mount_point']:30} {disk['usage']:3}%\n")
        f.write("\n")
        
        # Load Average
        f.write("--- Load Average ---\n")
        load_avg = get_load_average()
        if load_avg:
            f.write(f"1min: {load_avg[0]}, 5min: {load_avg[1]}, 15min: {load_avg[2]}\n")
        f.write("\n")
        
        # Network Information
        f.write("--- Network Interfaces ---\n")
        if network_info:
            f.write(network_info)
        else:
            f.write("Unable to retrieve network information\n")
        f.write("\n")
        
        # Top Processes
        f.write("--- Top 10 Processes by CPU ---\n")
        if top_processes:
            for process in top_processes:
                f.write(f"{process}\n")
        else:
            f.write("Unable to retrieve process information\n")
        f.write("\n")
        
        # Package Count
        f.write("--- Installed Packages ---\n")
        if package_counts:
            for pm_name, count in package_counts.items():
                f.write(f"{pm_name.upper()}: {count} packages\n")
        else:
            f.write("Unable to retrieve package information\n")
        f.write("\n")
        
        # Uptime
        f.write("--- System Uptime ---\n")
        try:
            uptime_result = subprocess.run(
                ['uptime'],
                capture_output=True,
                text=True,
                timeout=2
            )
            if uptime_result.returncode == 0:
                f.write(f"{uptime_result.stdout.strip()}\n")
        except (FileNotFoundError, subprocess.TimeoutExpired):
            f.write("Unable to retrieve uptime\n")
        f.write("\n")
    
    print_success(f"Full system report saved to: {report_file}")
    log("INFO", f"Full report generated. Report: {report_file}")


if __name__ == "__main__":
    main()




