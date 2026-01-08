#!/usr/bin/env python3

"""
Service Status - Use Case Script

This script checks the status of system services:
- Lists all running systemd services
- Identifies failed services
- Generates service status report

Usage:
    python3 service_status.py

Author: DevOps Automation Team
Version: 1.0.0
"""

import subprocess
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import init_directories, print_info, print_success, print_warning, log, REPORT_DIR


def get_service_status():
    """Get status of systemd services."""
    try:
        result = subprocess.run(
            ['systemctl', 'list-units', '--type=service', '--all', '--no-pager'],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            return result.stdout
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return None


def get_failed_services():
    """Get list of failed services."""
    try:
        result = subprocess.run(
            ['systemctl', 'list-units', '--type=service', '--state=failed', '--no-pager'],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            return result.stdout
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return None


def main():
    """Main function."""
    init_directories()
    
    print_info("Checking service status...")
    report_file = REPORT_DIR / f"services-{datetime.now().strftime('%Y%m%d-%H%M%S')}.txt"
    
    with open(report_file, 'w') as f:
        f.write("=== Service Status Report ===\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        # Get all services
        all_services = get_service_status()
        if all_services:
            f.write("--- All Services ---\n")
            f.write(all_services)
            f.write("\n")
        else:
            f.write("--- All Services ---\n")
            f.write("Unable to retrieve service status (systemctl not available)\n\n")
            print_warning("systemctl not available or cannot access service status")
            return
        
        # Get failed services
        failed_services = get_failed_services()
        if failed_services:
            f.write("--- Failed Services ---\n")
            f.write(failed_services)
            
            # Count failed services
            failed_lines = [line for line in failed_services.split('\n') if '.service' in line and 'failed' in line.lower()]
            if failed_lines:
                print_warning(f"{len(failed_lines)} failed services detected")
        else:
            f.write("--- Failed Services ---\n")
            f.write("No failed services\n")
            print_success("No failed services")
    
    print_success(f"Service status report saved to: {report_file}")
    log("INFO", f"Service status check completed. Report: {report_file}")


if __name__ == "__main__":
    main()




