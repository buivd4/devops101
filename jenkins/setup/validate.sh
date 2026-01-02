#!/bin/bash
# Simple validation script for Jenkins setup files

echo "Validating Jenkins Setup Files"
echo "=============================="
echo ""

ERRORS=0

# Check docker-compose.yml
echo -n "Checking docker-compose.yml... "
if docker-compose config > /dev/null 2>&1; then
    echo "✓ Valid"
else
    echo "✗ Invalid"
    docker-compose config
    ((ERRORS++))
fi

# Check YAML files (basic syntax check)
echo -n "Checking jenkins-config.yaml... "
if [ -f "jenkins-config.yaml" ] && grep -q "^jenkins:" jenkins-config.yaml; then
    echo "✓ File exists and has valid structure"
else
    echo "✗ File missing or invalid"
    ((ERRORS++))
fi

echo -n "Checking registry-config.yml... "
if [ -f "registry-config.yml" ] && grep -q "^version:" registry-config.yml; then
    echo "✓ File exists and has valid structure"
else
    echo "✗ File missing or invalid"
    ((ERRORS++))
fi

# Check required files exist
echo ""
echo "Checking required files..."
for file in docker-compose.yml Dockerfile.agent jenkins-config.yaml plugins.txt registry-config.yml; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file is missing"
        ((ERRORS++))
    fi
done

# Check Dockerfile syntax
echo ""
echo -n "Checking Dockerfile.agent... "
if [ -f "Dockerfile.agent" ]; then
    if grep -q "^FROM" Dockerfile.agent && grep -q "^USER" Dockerfile.agent; then
        echo "✓ Basic structure looks good"
    else
        echo "✗ Missing required directives"
        ((ERRORS++))
    fi
else
    echo "✗ File not found"
    ((ERRORS++))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✓ All validations passed!"
    echo ""
    echo "You can now start the setup with:"
    echo "  docker-compose up -d"
    exit 0
else
    echo "✗ Found $ERRORS error(s)"
    exit 1
fi

