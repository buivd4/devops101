#!/usr/bin/env python3

"""
Log Cleanup and Rotation - Use Case Script

This script automates log management tasks:
- Removes old log files beyond retention period
- Rotates systemd journal logs
- Cleans up application-specific log directories
- Reports space freed

Usage:
    python3 cleanup_logs.py

Author: DevOps Automation Team
Version: 1.0.0
"""

import os
import subprocess
import sys
from datetime import datetime, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    init_directories, print_info, print_success, print_warning,
    log, MAX_LOG_AGE_DAYS
)


def cleanup_old_logs(log_dir: Path, max_age_days: int):
    """Clean up old log files in a directory."""
    cleaned_count = 0
    total_freed = 0
    cutoff_date = datetime.now() - timedelta(days=max_age_days)
    
    if not log_dir.exists():
        return cleaned_count, total_freed
    
    print_info(f"Processing logs in: {log_dir}")
    
    for log_file in log_dir.rglob("*.log*"):
        if log_file.is_file():
            try:
                # Get modification time
                mtime = datetime.fromtimestamp(log_file.stat().st_mtime)
                if mtime < cutoff_date:
                    file_size = log_file.stat().st_size
                    print_info(f"Removing old log: {log_file.name}")
                    log_file.unlink()
                    cleaned_count += 1
                    total_freed += file_size
            except (OSError, PermissionError) as e:
                print_warning(f"Could not remove {log_file}: {e}")
    
    return cleaned_count, total_freed


def main():
    """Main function."""
    init_directories()
    
    print_info("Starting log cleanup and rotation...")
    
    cleaned_count = 0
    total_freed = 0
    
    # Common log directories
    log_dirs = [
        Path("/var/log"),
        Path("/var/log/apache2"),
        Path("/var/log/nginx"),
        Path(os.path.expanduser("~/.local/share/logs")),
    ]
    
    for log_dir in log_dirs:
        if log_dir.exists() and log_dir.is_dir():
            count, freed = cleanup_old_logs(log_dir, MAX_LOG_AGE_DAYS)
            cleaned_count += count
            total_freed += freed
    
    # Rotate journal logs if systemd is available
    try:
        result = subprocess.run(
            ["journalctl", "--vacuum-time", f"{MAX_LOG_AGE_DAYS}d"],
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode == 0:
            print_info("Rotated systemd journal logs")
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass  # journalctl not available or timeout
    
    freed_mb = total_freed / (1024 * 1024)
    print_success(f"Log cleanup completed: {cleaned_count} files removed, ~{freed_mb:.2f}MB freed")
    log("INFO", f"Log cleanup: {cleaned_count} files removed, {freed_mb:.2f}MB freed")


if __name__ == "__main__":
    main()




