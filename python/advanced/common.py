#!/usr/bin/env python3

"""
Common Utilities for Linux System Manager Scripts

This module contains shared functions and configuration used by all
system management scripts.
"""

import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Optional

# Color codes for output
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'  # No Color

# Configuration
SCRIPT_DIR = Path(__file__).parent.absolute()
LOG_DIR = SCRIPT_DIR / "logs"
REPORT_DIR = SCRIPT_DIR / "reports"
BACKUP_DIR = SCRIPT_DIR / "backups"

# Thresholds
MAX_LOG_AGE_DAYS = 30
DISK_USAGE_THRESHOLD = 80
MEMORY_USAGE_THRESHOLD = 85
CPU_USAGE_THRESHOLD = 80


def init_directories():
    """Initialize required directories."""
    LOG_DIR.mkdir(exist_ok=True)
    REPORT_DIR.mkdir(exist_ok=True)
    BACKUP_DIR.mkdir(exist_ok=True)


def log(level: str, message: str):
    """Log a message to the log file with timestamp."""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_file = LOG_DIR / f"system-manager-{datetime.now().strftime('%Y-%m-%d')}.log"
    
    log_entry = f"[{timestamp}] [{level}] {message}\n"
    
    with open(log_file, 'a') as f:
        f.write(log_entry)
    
    # Also print to stdout
    print(log_entry.strip())


def print_info(message: str):
    """Print info message with blue color."""
    print(f"{BLUE}[INFO]{NC} {message}")


def print_success(message: str):
    """Print success message with green color."""
    print(f"{GREEN}[SUCCESS]{NC} {message}")


def print_warning(message: str):
    """Print warning message with yellow color."""
    print(f"{YELLOW}[WARNING]{NC} {message}")


def print_error(message: str):
    """Print error message with red color."""
    print(f"{RED}[ERROR]{NC} {message}", file=sys.stderr)


def check_root() -> bool:
    """Check if running as root (for certain operations)."""
    if os.geteuid() != 0:
        print_warning("Some operations may require root privileges")
        return False
    return True


def format_bytes(bytes_value: int) -> str:
    """Format bytes to human-readable format."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_value < 1024.0:
            return f"{bytes_value:.2f}{unit}"
        bytes_value /= 1024.0
    return f"{bytes_value:.2f}PB"




