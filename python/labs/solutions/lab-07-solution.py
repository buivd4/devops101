#!/usr/bin/env python3

# Lab 7 Solution: System Monitoring Script

import platform
import subprocess
import time
from datetime import datetime


def get_cpu_usage():
    try:
        # Try using psutil if available (most reliable)
        try:
            import psutil
            return psutil.cpu_percent(interval=1)
        except ImportError:
            pass
        
        # Fallback: Platform-specific methods
        if platform.system() == "Darwin":  # macOS
            # Get load average and convert to CPU usage approximation
            result = subprocess.run(
                ["sysctl", "-n", "vm.loadavg"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                load_avg = float(result.stdout.split()[1])
                cpu_count = int(subprocess.check_output(
                    ["sysctl", "-n", "hw.ncpu"]
                ).decode().strip())
                # Approximate CPU usage from load average
                cpu_usage = (load_avg / cpu_count) * 100
                return min(100, cpu_usage)  # Cap at 100%
        else:  # Linux
            # Use top command for Linux
            result = subprocess.run(
                ["top", "-bn1"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                for line in result.stdout.split('\n'):
                    if 'Cpu(s)' in line or '%Cpu(s)' in line:
                        parts = line.split(',')
                        for part in parts:
                            if 'id' in part:
                                idle_str = part.strip()
                                idle = float(idle_str.replace('%id', '').replace('%', '').replace('id', '').strip())
                                return 100 - idle
    except Exception as e:
        print(f"Warning: Could not determine CPU usage: {e}")
    return None


def get_memory_usage():
    try:
        # Try using psutil if available (most reliable)
        try:
            import psutil
            mem = psutil.virtual_memory()
            return mem.percent
        except ImportError:
            pass
        
        # Fallback: Platform-specific methods
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
                
                if total_pages > 0:
                    mem_percent = (used_pages / total_pages) * 100
                    return mem_percent
        else:  # Linux
            result = subprocess.run(
                ["free"],
                capture_output=True,
                text=True,
                timeout=2
            )
            if result.returncode == 0:
                lines = result.stdout.split('\n')
                if len(lines) >= 2:
                    mem_line = lines[1].split()
                    if len(mem_line) >= 3:
                        total = int(mem_line[1])
                        used = int(mem_line[2])
                        if total > 0:
                            return (used / total) * 100
    except Exception as e:
        print(f"Warning: Could not determine memory usage: {e}")
    return None


def log_to_file(cpu_usage, memory_usage):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # Format the log entry
    cpu_str = f"{cpu_usage:.2f}%" if cpu_usage is not None else "N/A"
    mem_str = f"{memory_usage:.2f}%" if memory_usage is not None else "N/A"
    
    log_entry = f"[{timestamp}] WARNING: CPU Usage: {cpu_str}, Memory Usage: {mem_str}\n"
    
    # Write to monitoring.log file
    with open('monitoring.log', 'a') as f:
        f.write(log_entry)
    
    # Also print to console
    print(f"{log_entry.strip()}")


def main():
    """Main monitoring loop."""
    print("=== System Monitoring Started ===")
    print("Monitoring CPU and Memory usage...")
    print("Press Ctrl+C to stop\n")
    
    try:
        while True:
            # Get current CPU and Memory usage
            cpu_usage = get_cpu_usage()
            memory_usage = get_memory_usage()
            
            # Check if thresholds are exceeded
            cpu_exceeded = cpu_usage is not None and cpu_usage > 10
            memory_exceeded = memory_usage is not None and memory_usage > 10
            
            if cpu_exceeded or memory_exceeded:
                log_to_file(cpu_usage, memory_usage)
            else:
                pass
            
            time.sleep(5)
            
    except KeyboardInterrupt:
        print("\n\n=== Monitoring Stopped ===")
        print("Thank you for using the monitoring script!")


if __name__ == "__main__":
    main()

