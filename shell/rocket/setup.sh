#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add the directory to PATH if it's not already there
if [[ ":$PATH:" != *":$SCRIPT_DIR:"* ]]; then
    export PATH="$PATH:$SCRIPT_DIR"
    chmod +x $SCRIPT_DIR/rocket-*
    chmod +x $SCRIPT_DIR/create-and-launch-rocket
    chmod +x $SCRIPT_DIR/launch-rockets
    echo "Added $SCRIPT_DIR to PATH"
    echo "You can now run rocket commands directly:"
    echo "  rocket-add <mission_name>"
    echo "  rocket-start-power <mission_name>"
    echo "  rocket-internal-power <mission_name>"
    echo "  rocket-start-sequence <mission_name>"
    echo "  rocket-start-engine <mission_name>"
    echo "  rocket-lift-off <mission_name>"
    echo "  rocket-status <mission_name>"
    echo "  rocket-debug <mission_name>"
    echo "  etc."
else
    echo "$SCRIPT_DIR is already in PATH"
fi

