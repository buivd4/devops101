#!/usr/bin/env python3

"""
Linux System Manager - Main Wrapper Script

This is a convenience wrapper that calls individual use case scripts.
Each use case is now in its own separate file for better modularity.

Usage:
    python3 linux_system_manager.py [command]

Commands:
    health-check      - Perform comprehensive system health check
    cleanup-logs      - Rotate and clean old log files
    disk-cleanup      - Clean up disk space
    service-status    - Check status of critical services
    user-audit        - Audit user accounts and permissions
    backup-config     - Backup system configuration files
    full-report       - Generate comprehensive system report

Note: You can also run individual scripts directly:
    python3 health_check.py
    python3 cleanup_logs.py
    etc.

Author: DevOps Automation Team
Version: 2.0.0
"""

import sys
from pathlib import Path

# Import common utilities for colored output
sys.path.insert(0, str(Path(__file__).parent))
from common import print_info, print_error


def show_usage():
    """Show usage information."""
    script_name = Path(__file__).name
    print("Linux System Manager - DevOps Automation Tool")
    print("")
    print(f"Usage: {script_name} [command]")
    print("")
    print("Commands:")
    print("  health-check      Perform comprehensive system health check")
    print("  cleanup-logs      Rotate and clean old log files")
    print("  disk-cleanup      Clean up disk space")
    print("  service-status    Check status of critical services")
    print("  user-audit        Audit user accounts and permissions")
    print("  backup-config     Backup system configuration files")
    print("  full-report       Generate comprehensive system report")
    print("")
    print("Examples:")
    print(f"  {script_name} health-check")
    print(f"  {script_name} cleanup-logs")
    print(f"  {script_name} full-report")
    print("")
    print("Note: You can also run individual scripts directly:")
    print("  python3 health_check.py")
    print("  python3 cleanup_logs.py")


def main():
    """Main function."""
    if len(sys.argv) < 2:
        show_usage()
        sys.exit(0)
    
    command = sys.argv[1]
    
    # Map command names to module names (snake_case)
    command_map = {
        'health-check': 'health_check',
        'cleanup-logs': 'cleanup_logs',
        'disk-cleanup': 'disk_cleanup',
        'service-status': 'service_status',
        'user-audit': 'user_audit',
        'backup-config': 'backup_config',
        'full-report': 'full_report',
    }
    
    if command not in command_map:
        print_error(f"Unknown command: {command}")
        print("Run without arguments to see usage")
        sys.exit(1)
    
    # Import and run the corresponding module
    module_name = command_map[command]
    try:
        # Try importing as installed package first, then as local module
        try:
            module = __import__(f'advanced.{module_name}', fromlist=[module_name])
        except ImportError:
            # Fallback to local import for development
            module = __import__(module_name)
        
        if hasattr(module, 'main'):
            module.main()
        else:
            print_error(f"Module {module_name} does not have a main() function")
            sys.exit(1)
    except ImportError as e:
        print_error(f"Failed to import {module_name}: {e}")
        sys.exit(1)
    except Exception as e:
        print_error(f"Error running {command}: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()

