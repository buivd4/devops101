# Application Jenkins Pipelines

This directory contains sample applications with Jenkins pipeline configurations for CI/CD.

## Applications

### 1. Frontend Example (React/Vite)
- **Location**: `frontend-example/`
- **Technology**: React 18, Vite, Vitest
- **Jenkinsfile**: Basic and advanced versions available

### 2. Java Example (Spring Boot)
- **Location**: `java-example/`
- **Technology**: Spring Boot 3.2, Java 17, Maven
- **Jenkinsfile**: Basic and advanced versions available

### 3. Python Example (Flask)
- **Location**: `python-example/`
- **Technology**: Flask 3.0, Python 3.11, pytest
- **Jenkinsfile**: Basic and advanced versions available

## Jenkinsfiles

Each application has two Jenkinsfile options:

### Basic Jenkinsfile
- **File**: `Jenkinsfile`
- Simple CI pipeline with:
  - Source code checkout
  - Dependency installation
  - Testing
  - Building
  - Artifact archiving

### Advanced Jenkinsfile
- **File**: `Jenkinsfile.advanced`
- Full-featured CI/CD pipeline with:
  - All basic features
  - Parameterized builds
  - Docker image building
  - Deployment stages
  - Code quality checks (where applicable)
  - Test coverage reporting
  - Environment-specific deployments

## Usage

### Option 1: Use Basic Jenkinsfile (Recommended for Learning)

1. Copy the `Jenkinsfile` to your repository root (if not already there)
2. In Jenkins:
   - Create a new Pipeline job
   - Select "Pipeline script from SCM"
   - Choose your SCM (Git)
   - Enter repository URL
   - Set script path to `Jenkinsfile`
   - Click Save and Build

### Option 2: Use Advanced Jenkinsfile

1. Rename `Jenkinsfile.advanced` to `Jenkinsfile` OR
2. Keep both and update Jenkins to use `Jenkinsfile.advanced` as the script path

### Option 3: Copy to Jenkins GUI

1. Copy the contents of `Jenkinsfile` or `Jenkinsfile.advanced`
2. In Jenkins:
   - Create a new Pipeline job
   - Select "Pipeline script"
   - Paste the Jenkinsfile content
   - Configure parameters (for advanced version)
   - Click Save and Build

## Prerequisites

### Jenkins Plugins Required

- **Pipeline Plugin** (usually pre-installed)
- **Docker Pipeline Plugin** (for Docker agent and image building)
- **Git Plugin** (for SCM checkout)
- **JUnit Plugin** (for test result publishing)
- **HTML Publisher Plugin** (for coverage reports in advanced pipelines)
- **Workspace Cleanup Plugin** (for cleanWs step)

### Docker (for Docker agents)

If using Docker agents, ensure:
- Docker is installed on Jenkins agents
- Jenkins has permission to use Docker
- Docker daemon is running

### Credentials (for advanced pipelines)

For Docker registry push (if uncommented):
- Configure Docker registry credentials in Jenkins
- Update `DOCKER_REGISTRY` environment variable in Jenkinsfile
- Update credentials ID in `docker.withRegistry()` step

## Pipeline Features

### Frontend Pipeline (`frontend-example/`)

**Basic:**
- Node.js 20 Alpine Docker agent
- npm dependency installation
- Vitest test execution
- Vite production build
- Artifact archiving

**Advanced:**
- All basic features
- Parameterized builds (environment, skip tests, build Docker)
- Docker image building
- Deployment stages
- Multi-environment support

### Java Pipeline (`java-example/`)

**Basic:**
- Maven 3.9 with Java 17 Docker agent
- Maven compile, test, package
- JUnit test result publishing
- JAR artifact archiving

**Advanced:**
- All basic features
- Parameterized builds
- Docker image building
- Deployment with manual approval for production
- Test coverage reporting (if configured)
- Custom Maven goals parameter

### Python Pipeline (`python-example/`)

**Basic:**
- Python 3.11 Slim Docker agent
- pip dependency installation
- pytest test execution
- Application verification
- Test result publishing

**Advanced:**
- All basic features
- Code linting (flake8, pylint)
- Test coverage with HTML reports
- Docker image building
- Deployment stages
- Multi-environment support

## Customization

### Update Docker Registry

In `Jenkinsfile.advanced` files, update:
```groovy
DOCKER_REGISTRY = 'your-registry.com'
```

### Add Deployment Logic

In the `Deploy` stage, add your deployment commands:
```groovy
stage('Deploy') {
    steps {
        script {
            // Example: kubectl apply
            sh 'kubectl apply -f k8s/'
            
            // Example: docker-compose
            sh 'docker-compose up -d'
            
            // Example: custom script
            sh './deploy.sh ${params.DEPLOY_ENV}'
        }
    }
}
```

### Configure Credentials

For Docker registry, configure credentials in Jenkins:
1. Jenkins → Credentials → System → Global credentials
2. Add Docker registry credentials
3. Update credentials ID in Jenkinsfile:
   ```groovy
   docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-registry-credentials')
   ```

## Testing the Pipelines

### Local Testing (Jenkinsfile Lint)

```bash
# Install Jenkins Pipeline Linter (if available)
# Or test in Jenkins directly
```

### Best Practices

1. **Start with Basic**: Use `Jenkinsfile` first to understand the pipeline
2. **Gradually Add Features**: Move to `Jenkinsfile.advanced` when ready
3. **Version Control**: Always commit Jenkinsfiles to your repository
4. **Test Locally First**: Verify builds work locally before running in Jenkins
5. **Monitor Builds**: Check build logs and test results regularly
6. **Secure Secrets**: Never hardcode credentials; use Jenkins credentials

## Troubleshooting

### Docker Agent Issues

- Ensure Docker is installed and running on Jenkins agent
- Check Docker socket permissions: `sudo chmod 666 /var/run/docker.sock`
- Verify Jenkins user can access Docker: `sudo usermod -aG docker jenkins`

### Test Failures

- Check test output in Jenkins console
- Verify test dependencies are installed
- Review test result reports

### Build Failures

- Check build logs for specific error messages
- Verify all dependencies are available
- Ensure correct versions are specified

## Additional Resources

- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)
- [Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)

## Notes

- These pipelines are examples and may need customization for your environment
- Update environment variables, registry URLs, and deployment logic as needed
- Security best practices: Use Jenkins credentials for sensitive data
- Consider using Jenkins Shared Libraries for reusable pipeline code

