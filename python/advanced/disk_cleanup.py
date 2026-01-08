#!/usr/bin/env python3

"""
Disk Cleanup - Use Case Script

This script automates disk space cleanup:
- Cleans package manager caches (APT, YUM, DNF)
- Removes old temporary files
- Cleans Docker resources
- Reports cleanup statistics

Usage:
    python3 disk_cleanup.py

Note: Some operations may require root privileges

Author: DevOps Automation Team
Version: 1.0.0
"""

import os
import subprocess
import sys
from datetime import datetime, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import init_directories, print_info, print_success, print_warning, log, check_root


def clean_package_cache():
    """Clean package manager cache."""
    if not check_root():
        print_warning("Skipping package cache cleanup (requires root privileges)")
        return
    
    package_managers = {
        'apt-get': ['apt-get', 'clean', '-y'],
        'yum': ['yum', 'clean', 'all'],
        'dnf': ['dnf', 'clean', 'all'],
    }
    
    for pm_name, cmd in package_managers.items():
        try:
            subprocess.run(
                ['which', pm_name],
                capture_output=True,
                check=True,
                timeout=2
            )
            print_info(f"Cleaning {pm_name.upper()} package cache...")
            subprocess.run(
                cmd,
                capture_output=True,
                timeout=60
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, subprocess.CalledProcessError):
            continue


def clean_temp_files():
    """Clean old temporary files."""
    print_info("Cleaning temporary files...")
    temp_dirs = [
        Path("/tmp"),
        Path("/var/tmp"),
        Path(os.path.expanduser("~/.cache")),
    ]
    
    cutoff_date = datetime.now() - timedelta(days=7)
    
    for temp_dir in temp_dirs:
        if temp_dir.exists() and temp_dir.is_dir():
            try:
                files_before = sum(1 for f in temp_dir.rglob('*') if f.is_file())
                removed = 0
                
                for file_path in temp_dir.rglob('*'):
                    if file_path.is_file():
                        try:
                            mtime = datetime.fromtimestamp(file_path.stat().st_mtime)
                            if mtime < cutoff_date:
                                file_path.unlink()
                                removed += 1
                        except (OSError, PermissionError):
                            pass
                
                if removed > 0:
                    print_info(f"Removed {removed} old files from {temp_dir}")
            except (OSError, PermissionError) as e:
                print_warning(f"Could not clean {temp_dir}: {e}")


def clean_docker():
    """Clean Docker resources if available."""
    try:
        subprocess.run(
            ['which', 'docker'],
            capture_output=True,
            check=True,
            timeout=2
        )
        print_info("Cleaning Docker resources...")
        subprocess.run(
            ['docker', 'system', 'prune', '-f'],
            capture_output=True,
            timeout=300
        )
    except (FileNotFoundError, subprocess.TimeoutExpired, subprocess.CalledProcessError):
        pass  # Docker not available


def main():
    """Main function."""
    init_directories()
    
    print_info("Starting disk cleanup operation...")
    
    clean_package_cache()
    clean_temp_files()
    clean_docker()
    
    print_success("Disk cleanup completed")
    log("INFO", "Disk cleanup completed")


if __name__ == "__main__":
    main()




