# Jenkins Setup with Docker Compose

This directory contains a complete Jenkins setup with:
- **Jenkins Master** configured with JCasC (Jenkins Configuration as Code)
- **2 Jenkins Agents** with Docker support
- **Docker Registry** for storing container images

## Architecture

```
┌─────────────────┐
│  Jenkins Master │ (Port 8080)
│   (JCasC)       │
└────────┬────────┘
         │
         ├─────────────────┬─────────────────┐
         │                 │                 │
┌────────▼────────┐ ┌──────▼──────┐  ┌──────▼──────┐
│ Jenkins Agent 1 │ │Jenkins Agent│  │  Docker     │
│                 │ │     2       │  │  Registry   │
│ (Docker ready)  │ │(Docker ready)│  │  (Port 5000)│
└─────────────────┘ └─────────────┘  └─────────────┘
```

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ RAM recommended
- Ports 8080, 5000, 50000 available

## Quick Start

1. **Clone and navigate to the setup directory:**
   ```bash
   cd jenkins/setup
   ```

2. **Start all services:**
   ```bash
   docker-compose up -d
   ```

3. **Wait for Jenkins to initialize (about 1-2 minutes):**
   ```bash
   docker-compose logs -f jenkins
   ```
   Look for: `Jenkins is fully up and running`

4. **Install plugins (if not auto-installed):**
   ```bash
   ./install-plugins.sh
   docker-compose restart jenkins
   ```
   Or install manually via: **Manage Jenkins** → **Manage Plugins** → **Available**

5. **Access Jenkins:**
   - URL: http://localhost:8080
   - Default credentials: `admin` / `admin` (configured via JCasC)

6. **Access Docker Registry:**
   - URL: http://localhost:5000
   - Test: `curl http://localhost:5000/v2/_catalog`

## Services

### Jenkins Master
- **Port**: 8080
- **Configuration**: Managed via JCasC (`jenkins-config.yaml`)
- **Plugins**: Auto-installed via JCasC
- **Credentials**: Pre-configured for agents
- **No setup wizard**: Disabled for automated setup

### Jenkins Agents
- **Agent 1**: `jenkins-agent-1`
  - Labels: `docker agent-1`
  - Executors: 2
  - Docker enabled
  
- **Agent 2**: `jenkins-agent-2`
  - Labels: `docker agent-2`
  - Executors: 2
  - Docker enabled

Both agents:
- Have Docker CLI installed
- Connected via SSH
- Can build and push Docker images

### Docker Registry
- **Port**: 5000
- **Storage**: Persistent volume
- **Configuration**: `registry-config.yml`
- **Usage**: `localhost:5000/image-name:tag`

## Configuration Files

### `docker-compose.yml`
Main orchestration file defining all services, networks, and volumes.

### `jenkins-config.yaml`
JCasC configuration file containing:
- Jenkins system settings
- Node/agent configurations
- Tool installations (Git, Maven, JDK)
- Credentials for agents
- Security settings

### `Dockerfile.agent`
Custom agent image with:
- Docker CLI
- Git
- Additional build tools

### `registry-config.yml`
Docker registry configuration for local development.

### `install-plugins.sh`
Script to manually install plugins from `plugins.txt` if they weren't auto-installed on first startup.

## Customization

### Change Jenkins Admin Password

1. Edit `jenkins-config.yaml`:
   ```yaml
   credentials:
     system:
       domainCredentials:
         - credentials:
             - usernamePassword:
                 id: "admin-credentials"
                 username: "admin"
                 password: "your-new-password"
   ```

2. Restart Jenkins:
   ```bash
   docker-compose restart jenkins
   ```

### Add More Agents

1. Add service to `docker-compose.yml`:
   ```yaml
   jenkins-agent-3:
     build:
       context: .
       dockerfile: Dockerfile.agent
     container_name: jenkins-agent-3
     # ... (copy from agent-1/2)
   ```

2. Add node to `jenkins-config.yaml`:
   ```yaml
   - permanent:
       name: "agent-3"
       # ... configuration
   ```

3. Restart:
   ```bash
   docker-compose up -d
   ```

### Configure Docker Registry Authentication

Edit `registry-config.yml`:
```yaml
auth:
  htpasswd:
    realm: "Registry Realm"
    path: /auth/htpasswd
```

Then create htpasswd file and mount it.

### Change Ports

Edit `docker-compose.yml`:
```yaml
services:
  jenkins:
    ports:
      - "9090:8080"  # Change 8080 to 9090
```

## Usage

### Accessing Jenkins

1. Open browser: http://localhost:8080
2. Login with: `admin` / `admin`
3. Check agents in: **Manage Jenkins** → **Nodes**

### Using Docker Registry in Pipelines

In your Jenkinsfile:
```groovy
pipeline {
    agent any
    stages {
        stage('Build and Push') {
            steps {
                script {
                    def image = docker.build("localhost:5000/myapp:${BUILD_NUMBER}")
                    docker.withRegistry('http://localhost:5000') {
                        image.push()
                    }
                }
            }
        }
    }
}
```

### Pulling from Registry

```bash
# Configure Docker to allow insecure registry
sudo tee /etc/docker/daemon.json <<EOF
{
  "insecure-registries": ["localhost:5000"]
}
EOF

sudo systemctl restart docker

# Pull image
docker pull localhost:5000/myapp:latest
```

## Troubleshooting

### Agents Not Connecting

1. **Check agent logs:**
   ```bash
   docker-compose logs jenkins-agent-1
   docker-compose logs jenkins-agent-2
   ```

2. **Verify SSH credentials in JCasC:**
   ```bash
   docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```

3. **Check Jenkins master logs:**
   ```bash
   docker-compose logs jenkins | grep -i agent
   ```

### Jenkins Won't Start

1. **Check volumes:**
   ```bash
   docker-compose down -v  # WARNING: Deletes all data
   docker-compose up -d
   ```

2. **Check permissions:**
   ```bash
   sudo chown -R 1000:1000 jenkins_home/
   ```

3. **Check logs:**
   ```bash
   docker-compose logs jenkins
   ```

### Registry Not Accessible

1. **Check if running:**
   ```bash
   docker-compose ps docker-registry
   ```

2. **Test connectivity:**
   ```bash
   curl http://localhost:5000/v2/_catalog
   ```

3. **Check logs:**
   ```bash
   docker-compose logs docker-registry
   ```

### Docker Build Fails in Pipeline

1. **Verify Docker socket is mounted** (already in docker-compose.yml)
2. **Check agent has Docker:**
   ```bash
   docker-compose exec jenkins-agent-1 docker --version
   ```

3. **Test Docker command:**
   ```bash
   docker-compose exec jenkins-agent-1 docker ps
   ```

## Data Persistence

All data is stored in Docker volumes:
- `jenkins_home`: Jenkins configuration and jobs
- `agent1_work`: Agent 1 workspace
- `agent2_work`: Agent 2 workspace
- `registry_data`: Docker registry images

To backup:
```bash
docker run --rm -v jenkins_setup_jenkins_home:/data -v $(pwd):/backup \
  alpine tar czf /backup/jenkins-backup.tar.gz /data
```

To restore:
```bash
docker run --rm -v jenkins_setup_jenkins_home:/data -v $(pwd):/backup \
  alpine tar xzf /backup/jenkins-backup.tar.gz -C /
```

## Cleanup

### Stop all services:
```bash
docker-compose down
```

### Remove all data (WARNING: Destructive):
```bash
docker-compose down -v
```

### Remove only containers:
```bash
docker-compose rm -f
```

## Security Notes

⚠️ **This setup is for development/learning only!**

For production:
- Enable HTTPS/TLS
- Use proper authentication
- Configure firewall rules
- Use secrets management
- Enable audit logging
- Regular security updates
- Network isolation
- Resource limits

## Additional Resources

- [Jenkins JCasC Documentation](https://github.com/jenkinsci/configuration-as-code-plugin)
- [Docker Registry Documentation](https://docs.docker.com/registry/)
- [Jenkins Agent Documentation](https://www.jenkins.io/doc/book/managing/agents/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## Support

For issues or questions:
1. Check logs: `docker-compose logs [service-name]`
2. Verify configuration files
3. Check Docker and Docker Compose versions
4. Review Jenkins and agent connectivity

