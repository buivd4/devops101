# Installation Instructions

This package uses `pyproject.toml` for modern Python packaging (PEP 517/518). No `setup.py` is required.

## Development Installation

### Option 1: Install in Development Mode (Recommended)

This installs the package in "editable" mode, so changes to the source code are immediately available:

```bash
cd /path/to/python/advanced
pip install -e .
```

Or if you need enhanced features:
```bash
pip install -e ".[enhanced]"
```

### Option 2: Regular Installation

```bash
cd /path/to/python/advanced
pip install .
```

With enhanced features:
```bash
pip install ".[enhanced]"
```

### Option 3: Install from Source Directory

```bash
cd /path/to/python
pip install ./advanced
```

## After Installation

Once installed, you can use the commands from anywhere:

```bash
# Main wrapper script
linux-system-manager health-check
linux-system-manager cleanup-logs

# Short alias
lsm health-check
lsm cleanup-logs

# Individual commands
lsm-health-check
lsm-cleanup-logs
lsm-disk-cleanup
lsm-service-status
lsm-user-audit
lsm-backup-config
lsm-full-report
```

## Building Distribution Packages

To build distribution packages (wheel and source distribution):

```bash
cd /path/to/python/advanced
python3 -m build
```

This will create:
- `dist/linux-system-manager-2.0.0.tar.gz` (source distribution)
- `dist/linux_system_manager-2.0.0-py3-none-any.whl` (wheel)

## Installing from Wheel

```bash
pip install dist/linux_system_manager-*.whl
```

## Requirements

- Python 3.6 or higher
- pip 21.3+ (supports pyproject.toml)
- setuptools>=45 (for building, usually included with Python)
- wheel (for building wheels)
- build (for modern build process)

Install build tools (if needed):
```bash
pip install setuptools wheel build
```

Note: Modern pip versions (21.3+) automatically use `pyproject.toml` when present.

## Uninstallation

```bash
pip uninstall linux-system-manager
```

