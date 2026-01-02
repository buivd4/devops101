#!/bin/bash
# Script to verify Jenkins agents are configured and connected

set -e

echo "Jenkins Agent Verification Script"
echo "=================================="
echo ""

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JENKINS_USER="${JENKINS_USER:-admin}"
JENKINS_PASSWORD="${JENKINS_PASSWORD:-admin}"

# Check if Jenkins is accessible
echo "1. Checking Jenkins accessibility..."
if curl -s -f -u "${JENKINS_USER}:${JENKINS_PASSWORD}" "${JENKINS_URL}" > /dev/null 2>&1; then
    echo "   ✓ Jenkins is accessible at ${JENKINS_URL}"
else
    echo "   ✗ Jenkins is not accessible at ${JENKINS_URL}"
    echo "   Waiting 30 seconds for Jenkins to start..."
    sleep 30
fi

# Get CSRF token
echo ""
echo "2. Getting CSRF token..."
CRUMB=$(curl -s -u "${JENKINS_USER}:${JENKINS_PASSWORD}" "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# Check agents via Jenkins API
echo ""
echo "3. Checking agents via Jenkins API..."

AGENTS=$(curl -s -u "${JENKINS_USER}:${JENKINS_PASSWORD}" "${JENKINS_URL}/computer/api/json" | grep -o '"displayName":"[^"]*"' | cut -d'"' -f4 | grep -v "master\|built-in")

if [ -z "$AGENTS" ]; then
    echo "   ✗ No agents found"
else
    echo "   ✓ Found agents:"
    echo "$AGENTS" | while read agent; do
        echo "     - $agent"
        
        # Check agent status
        STATUS=$(curl -s -u "${JENKINS_USER}:${JENKINS_PASSWORD}" "${JENKINS_URL}/computer/${agent}/api/json" | grep -o '"offline":[^,]*' | cut -d':' -f2)
        if [ "$STATUS" = "false" ]; then
            echo "       Status: ONLINE ✓"
        else
            echo "       Status: OFFLINE ✗"
        fi
    done
fi

# Check agent containers
echo ""
echo "4. Checking agent containers..."
if docker ps --filter "name=jenkins-agent" --format "{{.Names}}" | grep -q "jenkins-agent"; then
    echo "   ✓ Agent containers are running:"
    docker ps --filter "name=jenkins-agent" --format "   - {{.Names}} ({{.Status}})"
else
    echo "   ✗ No agent containers found"
fi

echo ""
echo "5. Checking SSH connectivity to agents..."
for agent in jenkins-agent-1 jenkins-agent-2; do
    if docker exec $agent pgrep sshd > /dev/null 2>&1; then
        echo "   ✓ $agent: SSH server is running"
    else
        echo "   ✗ $agent: SSH server is not running"
    fi
done

echo ""
echo "=================================="
echo "Verification complete!"
echo ""
echo "To view agents in Jenkins UI:"
echo "  ${JENKINS_URL}/computer/"
echo ""

