#!/usr/bin/env python3

"""
User Account Auditing - Use Case Script

This script performs security-focused user account auditing:
- Lists all system users with UID/GID information
- Identifies users with shell access
- Checks for users with root privileges (sudo)
- Shows recent login history

Usage:
    python3 user_audit.py

Author: DevOps Automation Team
Version: 1.0.0
"""

import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path

# Try to import pwd (Unix-specific)
try:
    import pwd
    PWD_AVAILABLE = True
except ImportError:
    PWD_AVAILABLE = False

sys.path.insert(0, str(Path(__file__).parent))
from common import init_directories, print_info, print_success, print_warning, log, REPORT_DIR


def get_all_users():
    """Get all system users."""
    users = []
    if not PWD_AVAILABLE:
        print_warning("pwd module not available (not on Unix system)")
        return users
    
    try:
        for user in pwd.getpwall():
            users.append({
                'name': user.pw_name,
                'uid': user.pw_uid,
                'gid': user.pw_gid,
                'home': user.pw_dir,
                'shell': user.pw_shell
            })
    except Exception as e:
        print_warning(f"Error getting users: {e}")
    return users


def get_sudo_users():
    """Get users with sudo privileges."""
    sudo_users = []
    try:
        # Check /etc/sudoers and /etc/sudoers.d/*
        sudoers_files = [Path('/etc/sudoers')]
        sudoers_files.extend(Path('/etc/sudoers.d').glob('*') if Path('/etc/sudoers.d').exists() else [])
        
        for sudoers_file in sudoers_files:
            if sudoers_file.exists() and sudoers_file.is_file():
                try:
                    with open(sudoers_file, 'r') as f:
                        for line in f:
                            line = line.strip()
                            if line and not line.startswith('#') and 'ALL=' in line:
                                parts = line.split()
                                if parts and parts[0] != 'Defaults':
                                    sudo_users.append(parts[0])
                except (OSError, PermissionError):
                    pass
    except Exception as e:
        print_warning(f"Error getting sudo users: {e}")
    
    # Also check sudo group
    try:
        result = subprocess.run(
            ['getent', 'group', 'sudo'],
            capture_output=True,
            text=True,
            timeout=2
        )
        if result.returncode == 0:
            # Extract users from group
            parts = result.stdout.strip().split(':')
            if len(parts) >= 4 and parts[3]:
                sudo_users.extend(parts[3].split(','))
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    
    return list(set(sudo_users))  # Remove duplicates


def get_recent_logins():
    """Get recent login history."""
    recent_logins = []
    try:
        result = subprocess.run(
            ['last', '-n', '20'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            return result.stdout.split('\n')[:20]
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return recent_logins


def main():
    """Main function."""
    init_directories()
    
    print_info("Starting user account audit...")
    report_file = REPORT_DIR / f"user-audit-{datetime.now().strftime('%Y%m%d-%H%M%S')}.txt"
    
    users = get_all_users()
    sudo_users = get_sudo_users()
    recent_logins = get_recent_logins()
    
    with open(report_file, 'w') as f:
        f.write("=== User Account Audit Report ===\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        
        # All users
        f.write("--- All System Users ---\n")
        f.write(f"{'Username':<20} {'UID':<10} {'GID':<10} {'Home':<30} {'Shell':<30}\n")
        f.write("-" * 100 + "\n")
        for user in users:
            f.write(f"{user['name']:<20} {user['uid']:<10} {user['gid']:<10} {user['home']:<30} {user['shell']:<30}\n")
        f.write("\n")
        
        # Users with shell access
        f.write("--- Users with Shell Access ---\n")
        shell_users = [u for u in users if u['shell'] not in ['/usr/sbin/nologin', '/sbin/nologin', '/bin/false', '/usr/bin/false']]
        for user in shell_users:
            f.write(f"{user['name']:<20} {user['shell']}\n")
        f.write(f"\nTotal users with shell access: {len(shell_users)}\n\n")
        
        # Users with sudo privileges
        f.write("--- Users with Sudo Privileges ---\n")
        if sudo_users:
            for user in sorted(sudo_users):
                f.write(f"{user}\n")
        else:
            f.write("No users with sudo privileges found\n")
        f.write(f"\nTotal users with sudo: {len(sudo_users)}\n\n")
        
        # Recent logins
        f.write("--- Recent Login History ---\n")
        if recent_logins:
            for login in recent_logins[:20]:
                if login.strip():
                    f.write(f"{login}\n")
        else:
            f.write("Unable to retrieve login history\n")
        f.write("\n")
    
    print_success(f"User audit completed. Report saved to: {report_file}")
    log("INFO", f"User audit completed. Report: {report_file}")


if __name__ == "__main__":
    main()

