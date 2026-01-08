#!/bin/bash

# Example 6: Rocket Launch Script (Complete Example)
# This demonstrates a complete script using all concepts

function launch_rocket() {
    local mission_name=$1
    
    if [ -z "$mission_name" ]; then
        echo "Error: Mission name is required"
        return 1
    fi
    
    echo "=== Starting Launch Sequence for $mission_name ==="
    
    # Simulate launch sequence
    echo "[1/5] Creating mission directory..."
    mkdir -p "$mission_name"
    
    echo "[2/5] Adding rocket configuration..."
    # In real scenario: rocket-add $mission_name
    
    echo "[3/5] Starting auxiliary power..."
    # In real scenario: rocket-start-power $mission_name
    
    echo "[4/5] Switching to internal power..."
    # In real scenario: rocket-internal-power $mission_name
    
    echo "[5/5] Starting launch sequence..."
    # In real scenario: rocket-start-sequence $mission_name
    
    # Simulate status check
    rocket_status="launching"
    echo "Status: $rocket_status"
    
    # Wait for launch completion (simulated)
    counter=0
    while [ "$rocket_status" == "launching" ] && [ $counter -lt 3 ]; do
        sleep 1
        counter=$((counter + 1))
        echo "Waiting... ($counter/3)"
    done
    
    # Final status
    if [ $counter -eq 3 ]; then
        rocket_status="success"
    fi
    
    echo "Final status: $rocket_status"
    
    if [ "$rocket_status" == "failed" ]; then
        echo "Launch failed! Debugging..."
        # In real scenario: rocket-debug $mission_name
        return 1
    fi
    
    echo "=== Launch Complete ==="
    return 0
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <mission-name>"
    exit 1
fi

mission_name=$1
launch_rocket "$mission_name"
launch_status=$?

if [ $launch_status -eq 0 ]; then
    echo "Mission $mission_name launched successfully!"
else
    echo "Mission $mission_name failed!"
    exit 1
fi





