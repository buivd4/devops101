#!/usr/bin/env python3

"""
Configuration Backup - Use Case Script

This script backs up important system configuration files:
- Network configuration
- System configuration files
- Service configuration files
- Creates timestamped archive

Usage:
    python3 backup_config.py

Author: DevOps Automation Team
Version: 1.0.0
"""

import os
import shutil
import sys
import tarfile
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import init_directories, print_info, print_success, print_warning, log, BACKUP_DIR


def backup_config_file(source_path: Path, dest_dir: Path):
    """Backup a single configuration file."""
    if not source_path.exists() or not source_path.is_file():
        return False
    
    try:
        # Create destination filename by replacing / with _
        dest_filename = str(source_path).replace('/', '_').lstrip('_')
        dest_path = dest_dir / dest_filename
        
        shutil.copy2(source_path, dest_path)
        return True
    except (OSError, PermissionError) as e:
        print_warning(f"Could not backup {source_path}: {e}")
        return False


def main():
    """Main function."""
    init_directories()
    
    print_info("Backing up system configuration files...")
    
    backup_timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    backup_path = BACKUP_DIR / f"config-backup-{backup_timestamp}"
    backup_path.mkdir(exist_ok=True)
    
    # Important configuration files to backup
    config_files = [
        Path("/etc/hosts"),
        Path("/etc/resolv.conf"),
        Path("/etc/fstab"),
        Path("/etc/crontab"),
        Path("/etc/ssh/sshd_config"),
        Path("/etc/nginx/nginx.conf"),
        Path("/etc/apache2/apache2.conf"),
        Path("/etc/docker/daemon.json"),
    ]
    
    backed_up = 0
    
    for config_file in config_files:
        if backup_config_file(config_file, backup_path):
            print_info(f"Backed up: {config_file}")
            backed_up += 1
    
    # Create archive
    if backed_up > 0:
        archive_path = BACKUP_DIR / f"config-backup-{backup_timestamp}.tar.gz"
        try:
            with tarfile.open(archive_path, 'w:gz') as tar:
                tar.add(backup_path, arcname=backup_path.name)
            
            # Remove the temporary directory
            shutil.rmtree(backup_path)
            
            print_success(f"Configuration backup completed: {backed_up} files backed up")
            print_info(f"Backup archive: {archive_path}")
            log("INFO", f"Configuration backup: {backed_up} files")
        except Exception as e:
            print_warning(f"Could not create archive: {e}")
            print_info(f"Files backed up to: {backup_path}")
    else:
        print_warning("No configuration files were backed up")
        if backup_path.exists():
            backup_path.rmdir()


if __name__ == "__main__":
    main()




