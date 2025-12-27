# Advanced Shell Scripting Examples

This directory contains advanced shell scripting examples that demonstrate real-world DevOps automation scenarios.

## Linux System Manager

The Linux System Manager is a modular DevOps automation toolkit that demonstrates how to automate common Linux system management tasks. The toolkit is organized into separate use case scripts, each handling a specific automation task.

### Architecture

The toolkit follows a modular architecture:

- **`common.sh`** - Shared utilities and configuration (logging, colors, directories)
- **Individual Use Case Scripts** - Each script handles one specific automation task
- **`linux-system-manager.sh`** - Main wrapper script for convenience (optional)

### File Structure

```
advanced/
├── common.sh              # Shared utilities and configuration
├── health-check.sh        # System health monitoring use case
├── cleanup-logs.sh        # Log management use case
├── disk-cleanup.sh        # Disk cleanup use case
├── service-status.sh      # Service monitoring use case
├── user-audit.sh         # User account auditing use case
├── backup-config.sh       # Configuration backup use case
├── full-report.sh         # Comprehensive reporting use case
├── linux-system-manager.sh # Main wrapper (optional)
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

### Usage

You can use the scripts in two ways:

#### Option 1: Using the Wrapper Script (Recommended for beginners)

```bash
# Make scripts executable (if not already)
chmod +x *.sh

# View usage information
./linux-system-manager.sh

# Run a health check
./linux-system-manager.sh health-check

# Clean up old logs
./linux-system-manager.sh cleanup-logs

# Clean up disk space
./linux-system-manager.sh disk-cleanup

# Check service status
./linux-system-manager.sh service-status

# Audit user accounts
./linux-system-manager.sh user-audit

# Backup system configurations
./linux-system-manager.sh backup-config

# Generate full system report
./linux-system-manager.sh full-report
```

#### Option 2: Running Individual Scripts Directly

```bash
# Make scripts executable
chmod +x *.sh

# Run individual use case scripts
./health-check.sh
./cleanup-logs.sh
./disk-cleanup.sh
./service-status.sh
./user-audit.sh
./backup-config.sh
./full-report.sh
```

### Individual Use Case Scripts

#### 1. `health-check.sh` - System Health Monitoring

Performs comprehensive system health checks:
- CPU usage monitoring with threshold alerts
- Memory usage analysis
- Disk space monitoring
- Load average checks
- Network connectivity tests
- Critical service status verification

**Usage:**
```bash
./health-check.sh
```

#### 2. `cleanup-logs.sh` - Log Management

Automates log rotation and cleanup:
- Removes old log files beyond retention period (default: 30 days)
- Rotates systemd journal logs
- Cleans application-specific log directories
- Reports space freed

**Usage:**
```bash
./cleanup-logs.sh
```

#### 3. `disk-cleanup.sh` - Disk Space Management

Intelligent disk space cleanup:
- Cleans package manager caches (APT, YUM, DNF)
- Removes old temporary files (7+ days old)
- Cleans Docker resources
- Reports cleanup statistics

**Usage:**
```bash
./disk-cleanup.sh
```

**Note:** Some operations may require root privileges.

#### 4. `service-status.sh` - Service Monitoring

Checks the status of system services:
- Lists all running systemd services
- Identifies failed services
- Generates service status report

**Usage:**
```bash
./service-status.sh
```

#### 5. `user-audit.sh` - User Account Auditing

Security-focused user account auditing:
- Lists all system users with UID/GID information
- Identifies users with shell access
- Checks for users with root privileges (sudo)
- Shows recent login history

**Usage:**
```bash
./user-audit.sh
```

#### 6. `backup-config.sh` - Configuration Backup

Backs up important system configuration files:
- Network configuration files
- System configuration files
- Service configuration files
- Creates timestamped compressed archive

**Usage:**
```bash
./backup-config.sh
```

#### 7. `full-report.sh` - Comprehensive Reporting

Generates a comprehensive system report:
- System and hardware information
- Disk and network information
- Running processes (top 10 by CPU)
- Installed packages count
- System load and recent events

**Usage:**
```bash
./full-report.sh
```

### Script Features Demonstrated

1. **Error Handling**
   - `set -euo pipefail` for strict error handling
   - Proper exit codes and error messages
   - Graceful failure handling

2. **Logging System**
   - Structured logging with timestamps
   - Log file rotation by date
   - Multiple log levels (INFO, WARNING, ERROR, SUCCESS)

3. **Color Output**
   - Color-coded messages for better readability
   - Professional output formatting

4. **Modular Design**
   - Each use case in a separate script file
   - Shared utilities in common.sh
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
   - Proper shebang line
   - Comprehensive documentation
   - Usage instructions

2. **Variable Management**
   - Readonly variables for constants
   - Proper variable scoping
   - Safe variable expansion

3. **Function Design**
   - Single responsibility principle
   - Clear function names
   - Proper return codes

4. **Error Handling**
   - Exit on error
   - Undefined variable detection
   - Pipe failure detection

5. **Portability**
   - Cross-platform compatibility checks
   - Command availability checks
   - Graceful degradation

### Example Output

```bash
$ ./linux-system-manager.sh health-check
[INFO] Starting comprehensive system health check...
=== System Health Check Report ===
Generated: 2024-01-15 10:30:45
Hostname: server01
Uptime:  10:30:45 up 15 days,  2:15,  1 user,  load average: 0.52, 0.48, 0.45

--- CPU Information ---
CPU Usage: 15.2%
[SUCCESS] CPU usage is normal: 15.2%

--- Memory Information ---
Total Memory: 16Gi
Used Memory: 8.2Gi
Available Memory: 7.1Gi
Memory Usage: 51.25%
[SUCCESS] Memory usage is normal: 51.25%

...
```

### Integration with Cron

The scripts can be easily integrated into cron jobs for automated system management:

```bash
# Add to crontab (crontab -e)
# Using wrapper script:
# Daily health check at 2 AM
0 2 * * * /path/to/linux-system-manager.sh health-check

# Weekly log cleanup on Sundays at 3 AM
0 3 * * 0 /path/to/linux-system-manager.sh cleanup-logs

# Daily disk cleanup at 4 AM
0 4 * * * /path/to/linux-system-manager.sh disk-cleanup

# Weekly full report on Mondays at 5 AM
0 5 * * 1 /path/to/linux-system-manager.sh full-report

# Or using individual scripts directly:
0 2 * * * /path/to/health-check.sh
0 3 * * 0 /path/to/cleanup-logs.sh
0 4 * * * /path/to/disk-cleanup.sh
0 5 * * 1 /path/to/full-report.sh
```

### Requirements

- Bash 4.0 or higher
- Standard Unix utilities (grep, awk, sed, find, etc.)
- Optional: systemctl (for service management)
- Optional: docker (for Docker cleanup)
- Optional: bc (for floating point calculations)

### Learning Objectives

This script demonstrates:

- Advanced shell scripting techniques
- System administration automation
- Error handling and logging
- Modular script design
- Production-ready code practices
- DevOps automation patterns

### Extending the Toolkit

The toolkit is designed to be easily extensible. To add a new use case:

1. **Create a new script file** (e.g., `my-custom-task.sh`):
```bash
#!/bin/bash
set -euo pipefail

# Source common utilities
source "$(dirname "$0")/common.sh"

# Main function
main() {
    init_directories
    print_info "Running custom task..."
    # Your code here
    print_success "Custom task completed"
    log "INFO" "Custom task completed"
}

# Run main function
main "$@"
```

2. **Make it executable:**
```bash
chmod +x my-custom-task.sh
```

3. **Optionally, add it to the wrapper script** (`linux-system-manager.sh`):
```bash
# Add to the case statement in main()
my-custom-task)
    bash "${SCRIPT_DIR}/my-custom-task.sh" "$@"
    ;;
```

4. **Update the usage information** in the wrapper script's help text.

### Notes

- Some operations may require root privileges (especially `disk-cleanup.sh`)
- All scripts create necessary directories automatically (logs/, reports/, backups/)
- All operations are logged for audit purposes
- Reports are timestamped for easy tracking
- Each script can be run independently or through the wrapper
- The `common.sh` file provides shared functionality to all scripts

### Benefits of Modular Design

1. **Maintainability**: Each use case is isolated, making it easier to maintain and debug
2. **Reusability**: Scripts can be used independently or combined
3. **Testability**: Individual scripts can be tested in isolation
4. **Clarity**: Each script has a single, clear purpose
5. **Flexibility**: Easy to add new use cases without modifying existing code
6. **Collaboration**: Multiple developers can work on different use cases simultaneously

