# Advanced Python System Management Examples

This directory contains advanced Python examples that demonstrate real-world DevOps automation scenarios.

## Linux System Manager

The Linux System Manager is a modular DevOps automation toolkit that demonstrates how to automate common Linux system management tasks using Python. The toolkit is organized into separate use case scripts, each handling a specific automation task.

### Architecture

The toolkit follows a modular architecture:

- **`common.py`** - Shared utilities and configuration (logging, colors, directories)
- **Individual Use Case Scripts** - Each script handles one specific automation task
- **`linux_system_manager.py`** - Main wrapper script for convenience (optional)

### File Structure

```
advanced/
├── common.py              # Shared utilities and configuration
├── health_check.py        # System health monitoring use case
├── cleanup_logs.py        # Log management use case
├── disk_cleanup.py        # Disk cleanup use case
├── service_status.py      # Service monitoring use case
├── user_audit.py         # User account auditing use case
├── backup_config.py       # Configuration backup use case
├── full_report.py         # Comprehensive reporting use case
├── linux_system_manager.py # Main wrapper (optional)
└── README.md             # This file
```

### Features

- **System Health Monitoring**: Comprehensive health checks including CPU, memory, disk usage, and network connectivity
- **Log Management**: Automated log rotation and cleanup of old log files
- **Disk Cleanup**: Intelligent cleanup of temporary files, package caches, and Docker resources
- **Service Management**: Status monitoring for critical system services
- **User Auditing**: Security-focused user account and permission auditing
- **Configuration Backup**: Automated backup of important system configuration files
- **Reporting**: Detailed system reports with timestamps and logging

### Requirements

- Python 3.6 or higher
- Standard library modules (os, sys, subprocess, pathlib, etc.)
- Optional: `psutil` library for better system monitoring (fallback to standard library if not available)

### Installation

No additional installation required if using only standard library. For enhanced system monitoring:

```bash
pip install psutil
```

### Usage

You can use the scripts in two ways:

#### Option 1: Using the Wrapper Script (Recommended for beginners)

```bash
# View usage information
python3 linux_system_manager.py

# Run a health check
python3 linux_system_manager.py health-check

# Clean up old logs
python3 linux_system_manager.py cleanup-logs

# Clean up disk space
python3 linux_system_manager.py disk-cleanup

# Check service status
python3 linux_system_manager.py service-status

# Audit user accounts
python3 linux_system_manager.py user-audit

# Backup system configurations
python3 linux_system_manager.py backup-config

# Generate full system report
python3 linux_system_manager.py full-report
```

#### Option 2: Running Individual Scripts Directly

```bash
# Run individual use case scripts
python3 health_check.py
python3 cleanup_logs.py
python3 disk_cleanup.py
python3 service_status.py
python3 user_audit.py
python3 backup_config.py
python3 full_report.py
```

### Individual Use Case Scripts

#### 1. `health_check.py` - System Health Monitoring

Performs comprehensive system health checks:
- CPU usage monitoring with threshold alerts
- Memory usage analysis
- Disk space monitoring
- Load average checks
- Network connectivity tests
- Critical service status verification

**Usage:**
```bash
python3 health_check.py
```

#### 2. `cleanup_logs.py` - Log Management

Automates log rotation and cleanup:
- Removes old log files beyond retention period (default: 30 days)
- Rotates systemd journal logs
- Cleans application-specific log directories
- Reports space freed

**Usage:**
```bash
python3 cleanup_logs.py
```

#### 3. `disk_cleanup.py` - Disk Space Management

Intelligent disk space cleanup:
- Cleans package manager caches (APT, YUM, DNF)
- Removes old temporary files (7+ days old)
- Cleans Docker resources
- Reports cleanup statistics

**Usage:**
```bash
python3 disk_cleanup.py
```

**Note:** Some operations may require root privileges.

#### 4. `service_status.py` - Service Monitoring

Checks the status of system services:
- Lists all running systemd services
- Identifies failed services
- Generates service status report

**Usage:**
```bash
python3 service_status.py
```

#### 5. `user_audit.py` - User Account Auditing

Security-focused user account auditing:
- Lists all system users with UID/GID information
- Identifies users with shell access
- Checks for users with root privileges (sudo)
- Shows recent login history

**Usage:**
```bash
python3 user_audit.py
```

#### 6. `backup_config.py` - Configuration Backup

Backs up important system configuration files:
- Network configuration files
- System configuration files
- Service configuration files
- Creates timestamped compressed archive

**Usage:**
```bash
python3 backup_config.py
```

#### 7. `full_report.py` - Comprehensive Reporting

Generates a comprehensive system report:
- System and hardware information
- Disk and network information
- Running processes (top 10 by CPU)
- Installed packages count
- System load and recent events

**Usage:**
```bash
python3 full_report.py
```

### Script Features Demonstrated

1. **Error Handling**
   - Try/except blocks for graceful error handling
   - Proper exception handling and error messages
   - Graceful failure handling

2. **Logging System**
   - Structured logging with timestamps
   - Log file rotation by date
   - Multiple log levels (INFO, WARNING, ERROR, SUCCESS)

3. **Color Output**
   - Color-coded messages for better readability
   - Professional output formatting using ANSI escape codes

4. **Modular Design**
   - Each use case in a separate Python module
   - Shared utilities in common.py
   - Reusable code components
   - Clear separation of concerns
   - Easy to maintain and extend

5. **Configuration Management**
   - Configurable thresholds and settings
   - Environment-aware operations
   - Safe defaults

6. **Reporting**
   - Comprehensive system reports
   - Timestamped report files
   - Multiple output formats

7. **Security Considerations**
   - Root privilege checks
   - Safe file operations
   - Permission-aware operations

### Directory Structure

The script creates the following directories automatically:

- `logs/` - Daily log files
- `reports/` - Generated system reports
- `backups/` - Configuration backups

### Best Practices Demonstrated

1. **Shebang and Script Header**
   - Proper shebang line (`#!/usr/bin/env python3`)
   - Comprehensive documentation
   - Usage instructions

2. **Variable Management**
   - Type hints for better code clarity
   - Constants for configuration
   - Proper variable scoping

3. **Function Design**
   - Single responsibility principle
   - Clear function names
   - Proper return values
   - Docstrings for documentation

4. **Error Handling**
   - Comprehensive exception handling
   - Graceful degradation
   - Informative error messages

5. **Portability**
   - Cross-platform compatibility checks
   - Command availability checks
   - Graceful degradation

6. **Python Best Practices**
   - PEP 8 style compliance
   - Type hints where appropriate
   - Module-level documentation
   - Proper import organization

### Example Output

```bash
$ python3 linux_system_manager.py health-check
[INFO] Starting comprehensive system health check...
[SUCCESS] CPU usage is normal: 15.2%
[SUCCESS] Memory usage is normal: 51.25%
[WARNING] High disk usage on /: 85%
[SUCCESS] Network connectivity to Google DNS: OK
[SUCCESS] Health check completed. Report saved to: reports/health-check-20240115-103045.txt
```

### Integration with Cron

The scripts can be easily integrated into cron jobs for automated system management:

```bash
# Add to crontab (crontab -e)
# Using wrapper script:
# Daily health check at 2 AM
0 2 * * * cd /path/to/python/advanced && /usr/bin/python3 linux_system_manager.py health-check

# Weekly log cleanup on Sundays at 3 AM
0 3 * * 0 cd /path/to/python/advanced && /usr/bin/python3 linux_system_manager.py cleanup-logs

# Daily disk cleanup at 4 AM
0 4 * * * cd /path/to/python/advanced && /usr/bin/python3 linux_system_manager.py disk-cleanup

# Weekly full report on Mondays at 5 AM
0 5 * * 1 cd /path/to/python/advanced && /usr/bin/python3 linux_system_manager.py full-report

# Or using individual scripts directly:
0 2 * * * cd /path/to/python/advanced && /usr/bin/python3 health_check.py
0 3 * * 0 cd /path/to/python/advanced && /usr/bin/python3 cleanup_logs.py
0 4 * * * cd /path/to/python/advanced && /usr/bin/python3 disk_cleanup.py
0 5 * * 1 cd /path/to/python/advanced && /usr/bin/python3 full_report.py
```

### Learning Objectives

This script demonstrates:

- Advanced Python programming techniques
- System administration automation
- Error handling and logging
- Modular script design
- Production-ready code practices
- DevOps automation patterns
- Cross-platform compatibility

### Extending the Toolkit

The toolkit is designed to be easily extensible. To add a new use case:

1. **Create a new Python module** (e.g., `my_custom_task.py`):
```python
#!/usr/bin/env python3
"""
My Custom Task - Use Case Script

Description of what this script does.

Usage:
    python3 my_custom_task.py
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    init_directories, print_info, print_success, log
)

def main():
    """Main function."""
    init_directories()
    print_info("Running custom task...")
    # Your code here
    print_success("Custom task completed")
    log("INFO", "Custom task completed")

if __name__ == "__main__":
    main()
```

2. **Optionally, add it to the wrapper script** (`linux_system_manager.py`):
```python
# Add to the command_map dictionary
command_map = {
    # ... existing commands ...
    'my-custom-task': 'my_custom_task',
}
```

3. **Update the usage information** in the wrapper script's `show_usage()` function.

### Notes

- Some operations may require root privileges (especially `disk_cleanup.py`)
- All scripts create necessary directories automatically (logs/, reports/, backups/)
- All operations are logged for audit purposes
- Reports are timestamped for easy tracking
- Each script can be run independently or through the wrapper
- The `common.py` file provides shared functionality to all scripts
- Scripts use standard library modules when possible, with optional `psutil` for enhanced functionality

### Benefits of Modular Design

1. **Maintainability**: Each use case is isolated, making it easier to maintain and debug
2. **Reusability**: Scripts can be used independently or combined
3. **Testability**: Individual scripts can be tested in isolation
4. **Clarity**: Each script has a single, clear purpose
5. **Flexibility**: Easy to add new use cases without modifying existing code
6. **Collaboration**: Multiple developers can work on different use cases simultaneously

### Comparison with Shell Script Version

This Python version offers several advantages over the shell script version:

- **Better Error Handling**: Python's exception handling is more robust
- **Cross-Platform**: Easier to make cross-platform compatible
- **Type Safety**: Type hints help catch errors early
- **Rich Standard Library**: Python's standard library is extensive
- **Easier Testing**: Python unit testing frameworks are more mature
- **Better Data Structures**: Native support for dictionaries, lists, sets
- **Readability**: Python's syntax is generally more readable

### Troubleshooting

**Permission Errors**: Some scripts require root privileges. Use `sudo` when necessary:
```bash
sudo python3 disk_cleanup.py
```

**Module Import Errors**: Ensure you're running scripts from the `advanced/` directory or adjust Python path:
```bash
cd /path/to/python/advanced
python3 health_check.py
```

**Missing Dependencies**: Install optional dependencies for enhanced functionality:
```bash
pip install psutil
```

### Contributing

When adding new features:
1. Follow PEP 8 style guidelines
2. Add proper docstrings
3. Include error handling
4. Update this README
5. Test on multiple platforms if possible




