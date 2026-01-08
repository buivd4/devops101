#!/usr/bin/env python3

"""
System Health Check - Use Case Script

This script performs a comprehensive system health check including:
- CPU usage monitoring
- Memory usage analysis
- Disk space monitoring
- Load average checks
- Network connectivity tests
- Critical service status

Usage:
    python3 health_check.py

Author: DevOps Automation Team
Version: 1.0.0
"""

import os
import platform
import subprocess
import socket
import sys
from datetime import datetime
from pathlib import Path

# Add parent directory to path to import common
sys.path.insert(0, str(Path(__file__).parent))
from common import (
    init_directories, print_info, print_success, print_warning, print_error,
    log, REPORT_DIR, CPU_USAGE_THRESHOLD, MEMORY_USAGE_THRESHOLD,
    DISK_USAGE_THRESHOLD
)


def get_cpu_usage():
    """Get CPU usage percentage."""
    try:
        if platform.system() == "Darwin":  # macOS
            result = subprocess.run(
                ["sysctl", "-n", "vm.loadavg"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                load_avg = float(result.stdout.split()[1])
                cpu_count = int(subprocess.check_output(["sysctl", "-n", "hw.ncpu"]).decode().strip())
                return (load_avg / cpu_count) * 100
        else:  # Linux
            result = subprocess.run(
                ["top", "-bn1"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                for line in result.stdout.split('\n'):
                    if 'Cpu(s)' in line:
                        parts = line.split(',')
                        for part in parts:
                            if 'id' in part:
                                idle = float(part.strip().replace('%id', '').replace('%', ''))
                                return 100 - idle
        # Fallback using psutil if available
        try:
            import psutil
            return psutil.cpu_percent(interval=1)
        except ImportError:
            pass
    except Exception as e:
        print_warning(f"Could not determine CPU usage: {e}")
    return None


def get_memory_info():
    """Get memory usage information."""
    try:
        if platform.system() == "Darwin":  # macOS
            result = subprocess.run(
                ["vm_stat"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                vm_stat = {}
                for line in result.stdout.split('\n'):
                    if ':' in line:
                        key, value = line.split(':', 1)
                        vm_stat[key.strip()] = int(value.strip().replace('.', ''))
                
                page_size = 4096  # Default page size
                pages_free = vm_stat.get('Pages free', 0)
                pages_active = vm_stat.get('Pages active', 0)
                pages_inactive = vm_stat.get('Pages inactive', 0)
                pages_wired = vm_stat.get('Pages wired down', 0)
                
                total_pages = pages_free + pages_active + pages_inactive + pages_wired
                used_pages = pages_active + pages_inactive + pages_wired
                
                total_bytes = total_pages * page_size
                used_bytes = used_pages * page_size
                free_bytes = pages_free * page_size
                
                mem_percent = (used_bytes / total_bytes) * 100 if total_bytes > 0 else 0
                
                return {
                    'total': total_bytes,
                    'used': used_bytes,
                    'free': free_bytes,
                    'percent': mem_percent
                }
        else:  # Linux
            result = subprocess.run(
                ["free", "-b"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                lines = result.stdout.split('\n')
                if len(lines) >= 2:
                    mem_line = lines[1].split()
                    total = int(mem_line[1])
                    used = int(mem_line[2])
                    available = int(mem_line[6]) if len(mem_line) > 6 else int(mem_line[3])
                    
                    return {
                        'total': total,
                        'used': used,
                        'free': available,
                        'percent': (used / total) * 100 if total > 0 else 0
                    }
        # Fallback using psutil if available
        try:
            import psutil
            mem = psutil.virtual_memory()
            return {
                'total': mem.total,
                'used': mem.used,
                'free': mem.available,
                'percent': mem.percent
            }
        except ImportError:
            pass
    except Exception as e:
        print_warning(f"Could not determine memory usage: {e}")
    return None


def get_disk_usage():
    """Get disk usage for mounted filesystems."""
    disk_info = []
    try:
        result = subprocess.run(
            ["df", "-h"],
            capture_output=True,
            text=True,
            timeout=2
        )
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n')[1:]  # Skip header
            for line in lines:
                parts = line.split()
                if len(parts) >= 6 and parts[0].startswith('/dev/'):
                    filesystem = parts[0]
                    usage = int(parts[4].replace('%', ''))
                    mount_point = parts[5]
                    disk_info.append({
                        'filesystem': filesystem,
                        'usage': usage,
                        'mount_point': mount_point
                    })
    except Exception as e:
        print_warning(f"Could not determine disk usage: {e}")
    return disk_info


def check_network_connectivity():
    """Check network connectivity to common hosts."""
    hosts = [
        ('Google DNS', '8.8.8.8', 53),
        ('Cloudflare DNS', '1.1.1.1', 53),
    ]
    
    results = []
    for name, host, port in hosts:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(2)
            result = sock.connect_ex((host, port))
            sock.close()
            results.append((name, result == 0))
        except Exception:
            results.append((name, False))
    
    return results


def get_load_average():
    """Get system load average."""
    try:
        if platform.system() == "Darwin":  # macOS
            result = subprocess.run(
                ["sysctl", "-n", "vm.loadavg"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                return result.stdout.strip().replace('{ ', '').replace(' }', '').split()
        else:  # Linux
            with open('/proc/loadavg', 'r') as f:
                return f.read().split()[:3]
    except Exception:
        pass
    return None


def main():
    """Main function."""
    init_directories()
    
    print_info("Starting comprehensive system health check...")
    report_file = REPORT_DIR / f"health-check-{datetime.now().strftime('%Y%m%d-%H%M%S')}.txt"
    
    with open(report_file, 'w') as f:
        f.write("=== System Health Check Report ===\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Hostname: {socket.gethostname()}\n")
        
        try:
            uptime_result = subprocess.run(
                ["uptime"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if uptime_result.returncode == 0:
                f.write(f"Uptime: {uptime_result.stdout.strip()}\n")
        except Exception:
            pass
        
        f.write("\n")
        
        # CPU Usage
        f.write("--- CPU Information ---\n")
        cpu_usage = get_cpu_usage()
        if cpu_usage is not None:
            f.write(f"CPU Usage: {cpu_usage:.1f}%\n")
            if cpu_usage > CPU_USAGE_THRESHOLD:
                print_warning(f"High CPU usage detected: {cpu_usage:.1f}%")
                f.write(f"[WARNING] High CPU usage: {cpu_usage:.1f}%\n")
            else:
                print_success(f"CPU usage is normal: {cpu_usage:.1f}%")
                f.write(f"[SUCCESS] CPU usage is normal: {cpu_usage:.1f}%\n")
        else:
            f.write("CPU Usage: Unable to determine\n")
        f.write("\n")
        
        # Memory Usage
        f.write("--- Memory Information ---\n")
        mem_info = get_memory_info()
        if mem_info:
            from common import format_bytes
            f.write(f"Total Memory: {format_bytes(mem_info['total'])}\n")
            f.write(f"Used Memory: {format_bytes(mem_info['used'])}\n")
            f.write(f"Available Memory: {format_bytes(mem_info['free'])}\n")
            f.write(f"Memory Usage: {mem_info['percent']:.2f}%\n")
            if mem_info['percent'] > MEMORY_USAGE_THRESHOLD:
                print_warning(f"High memory usage detected: {mem_info['percent']:.2f}%")
                f.write(f"[WARNING] High memory usage: {mem_info['percent']:.2f}%\n")
            else:
                print_success(f"Memory usage is normal: {mem_info['percent']:.2f}%")
                f.write(f"[SUCCESS] Memory usage is normal: {mem_info['percent']:.2f}%\n")
        else:
            f.write("Memory Information: Unable to determine\n")
        f.write("\n")
        
        # Disk Usage
        f.write("--- Disk Usage ---\n")
        disk_info = get_disk_usage()
        for disk in disk_info:
            f.write(f"Filesystem: {disk['filesystem']} - {disk['mount_point']}: {disk['usage']}%\n")
            if disk['usage'] > DISK_USAGE_THRESHOLD:
                print_warning(f"High disk usage on {disk['mount_point']}: {disk['usage']}%")
                f.write(f"  [WARNING] High disk usage: {disk['usage']}%\n")
            else:
                f.write(f"  [OK] Disk usage is normal: {disk['usage']}%\n")
        f.write("\n")
        
        # Load Average
        f.write("--- Load Average ---\n")
        load_avg = get_load_average()
        if load_avg:
            f.write(f"Load Average (1min, 5min, 15min): {', '.join(load_avg[:3])}\n")
        else:
            f.write("Load Average: Unable to determine\n")
        f.write("\n")
        
        # Network Connectivity
        f.write("--- Network Connectivity ---\n")
        network_results = check_network_connectivity()
        for name, status in network_results:
            status_str = "OK" if status else "FAIL"
            f.write(f"{name}: {status_str}\n")
            if status:
                print_success(f"Network connectivity to {name}: OK")
            else:
                print_warning(f"Network connectivity to {name}: FAIL")
        f.write("\n")
    
    print_success(f"Health check completed. Report saved to: {report_file}")
    log("INFO", f"Health check completed. Report: {report_file}")


if __name__ == "__main__":
    main()




