#!/bin/bash
# Test script for Jenkins setup
# This script validates and tests the Jenkins Docker Compose setup

set -e

echo "=========================================="
echo "Jenkins Setup Test Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((TESTS_FAILED++))
}

test_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Test 1: Check Docker
echo "1. Checking Docker installation..."
if command -v docker &> /dev/null; then
    test_pass "Docker is installed"
    docker --version
else
    test_fail "Docker is not installed"
    exit 1
fi

# Test 2: Check Docker Compose
echo ""
echo "2. Checking Docker Compose installation..."
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
    test_pass "Docker Compose is available"
    docker-compose --version 2>/dev/null || docker compose version
else
    test_fail "Docker Compose is not installed"
    exit 1
fi

# Test 3: Check Docker daemon
echo ""
echo "3. Checking Docker daemon..."
if docker info &> /dev/null; then
    test_pass "Docker daemon is running"
else
    test_fail "Docker daemon is not running"
    exit 1
fi

# Test 4: Validate docker-compose.yml
echo ""
echo "4. Validating docker-compose.yml..."
if docker-compose config &> /dev/null; then
    test_pass "docker-compose.yml is valid"
else
    test_fail "docker-compose.yml has errors"
    docker-compose config
    exit 1
fi

# Test 5: Check required files
echo ""
echo "5. Checking required files..."
REQUIRED_FILES=(
    "docker-compose.yml"
    "Dockerfile.agent"
    "jenkins-config.yaml"
    "plugins.txt"
    "registry-config.yml"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        test_pass "File exists: $file"
    else
        test_fail "File missing: $file"
    fi
done

# Test 6: Check ports availability
echo ""
echo "6. Checking port availability..."
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1; then
        test_info "Port $1 is in use (might be from previous run)"
        return 1
    else
        test_pass "Port $1 is available"
        return 0
    fi
}

check_port 8080
check_port 5000
check_port 50000

# Test 7: Check for existing containers
echo ""
echo "7. Checking for existing containers..."
EXISTING_CONTAINERS=$(docker ps -a --filter "name=jenkins-master|jenkins-agent-1|jenkins-agent-2|docker-registry" --format "{{.Names}}" 2>/dev/null || true)
if [ -z "$EXISTING_CONTAINERS" ]; then
    test_pass "No existing containers found"
else
    test_info "Found existing containers:"
    echo "$EXISTING_CONTAINERS"
    echo ""
    read -p "Do you want to remove existing containers? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down 2>/dev/null || true
        test_pass "Removed existing containers"
    fi
fi

# Test 8: Build agent image
echo ""
echo "8. Building agent Docker image..."
if docker-compose build jenkins-agent-1 2>&1 | tee /tmp/docker-build.log; then
    if grep -q "Successfully built\|Successfully tagged" /tmp/docker-build.log; then
        test_pass "Agent image built successfully"
    else
        test_fail "Agent image build failed"
    fi
else
    test_fail "Agent image build command failed"
fi

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Tests failed: ${RED}${TESTS_FAILED}${NC}"
    exit 1
else
    echo -e "Tests failed: ${GREEN}${TESTS_FAILED}${NC}"
fi

echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo "1. Start the setup:"
echo "   docker-compose up -d"
echo ""
echo "2. Check logs:"
echo "   docker-compose logs -f jenkins"
echo ""
echo "3. Wait for Jenkins to start (look for 'Jenkins is fully up and running')"
echo ""
echo "4. Access Jenkins:"
echo "   http://localhost:8080"
echo "   Login: admin / admin"
echo ""
echo "5. Check agents:"
echo "   http://localhost:8080/computer/"
echo ""
echo "6. Test Docker registry:"
echo "   curl http://localhost:5000/v2/_catalog"
echo ""

