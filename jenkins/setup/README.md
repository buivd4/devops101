# Jenkins Setup with Docker Compose

This directory contains a complete Jenkins setup with:
- **Jenkins Master** configured with JCasC (Jenkins Configuration as Code)
- **2 Jenkins Agents** with Docker support
- **Docker Registry** for storing container images

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Host Docker Daemon                   │
│              /var/run/docker.sock                        │
└───────────────────────┬─────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
┌───────▼──────┐  ┌─────▼──────┐  ┌─────▼──────┐
│ Jenkins      │  │ Agent 1    │  │ Agent 2    │
│ Master       │  │ (SSH:2222) │  │ (SSH:2223) │
│ (Port 8080)  │  │            │  │            │
│              │  │ Docker CLI  │  │ Docker CLI │
│ Docker CLI   │  │ Socket      │  │ Socket     │
│ Socket       │  │ Mounted     │  │ Mounted    │
└──────────────┘  └─────────────┘  └────────────┘
        │
        └───────────────┐
                        │
                ┌───────▼───────┐
                │ Docker        │
                │ Registry      │
                │ (Port 5000)   │
                └───────────────┘
```

**Key Features:**
- All containers have Docker CLI installed
- Docker socket mounted from host to all containers
- Agents can build and push Docker images
- Docker registry for storing container images

## Prerequisites

- Docker Engine 20.10+ (with Docker daemon running)
- Docker Compose 2.0+
- 4GB+ RAM recommended
- Ports 8080, 50000, 2222, 2223 available
- Docker socket accessible at `/var/run/docker.sock` (default Docker installation)

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

4. **Verify agents are connected:**
   ```bash
   docker-compose logs jenkins | grep -i "agent"
   ```
   Or check in Jenkins UI: **Manage Jenkins** → **Nodes**

5. **Access Jenkins:**
   - URL: http://localhost:8080
   - Default credentials: `admin` / `admin` (configured via JCasC)

6. **Verify Docker is working:**
   ```bash
   # Test Docker on master
   docker-compose exec jenkins docker --version
   
   # Test Docker on agent
   docker-compose exec -u jenkins jenkins-agent-1 docker --version
   ```

7. **Access Docker Registry:**
   - URL: http://localhost:5000 (if port is exposed)
   - Test: `curl http://localhost:5000/v2/_catalog`

## Services

### Jenkins Master
- **Port**: 8080
- **Configuration**: Managed via JCasC (`jenkins-config.yaml`)
- **Plugins**: Auto-installed via JCasC
- **Credentials**: Pre-configured for agents
- **No setup wizard**: Disabled for automated setup
- **Docker**: Docker CLI installed with socket mounted
- **Docker Socket**: `/var/run/docker.sock` mounted from host

### Jenkins Agents
- **Agent 1**: `jenkins-agent-1`
  - Labels: `docker agent-1`
  - Executors: 2
  - Docker enabled
  - SSH Port: 2222
  
- **Agent 2**: `jenkins-agent-2`
  - Labels: `docker agent-2`
  - Executors: 2
  - Docker enabled
  - SSH Port: 2223

Both agents:
- Have Docker CLI installed from official Docker repository
- Docker socket mounted from host (`/var/run/docker.sock`)
- Connected via SSH with non-verifying host key strategy
- Docker group GID automatically adjusted at startup to match host
- Can build and push Docker images
- Run in privileged mode for Docker access

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
- Docker CLI (installed from official Docker repository)
- Git, curl, wget, and other build tools
- SSH server for Jenkins agent connection
- Automatic Docker group GID adjustment at startup
- Java symlink for Jenkins SSH launcher

### `Dockerfile.master`
Custom Jenkins master image with:
- Docker CLI (installed from official Docker repository)
- Docker socket access configured
- Jenkins user added to docker group

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

2. **Verify SSH is running on agents:**
   ```bash
   docker-compose exec jenkins-agent-1 ps aux | grep sshd
   ```

3. **Test SSH connection:**
   ```bash
   ssh -p 2222 jenkins@localhost
   # Password: jenkins
   ```

4. **Check Jenkins master logs:**
   ```bash
   docker-compose logs jenkins | grep -i agent
   ```

5. **Verify SSH host key verification is disabled:**
   - Check `jenkins-config.yaml` for `nonVerifyingKeyVerificationStrategy`
   - This is already configured for both agents

6. **Check agent connectivity in Jenkins UI:**
   - Go to **Manage Jenkins** → **Nodes**
   - Check agent status and connection logs

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

1. **Verify Docker socket is mounted** (already in docker-compose.yml):
   ```bash
   docker-compose exec jenkins-agent-1 ls -la /var/run/docker.sock
   ```

2. **Check agent has Docker CLI:**
   ```bash
   docker-compose exec jenkins-agent-1 docker --version
   ```

3. **Test Docker command as jenkins user:**
   ```bash
   docker-compose exec -u jenkins jenkins-agent-1 docker ps
   ```

4. **Check Docker group GID matches host:**
   ```bash
   # On host
   stat -c %g /var/run/docker.sock
   
   # In container
   docker-compose exec jenkins-agent-1 getent group docker
   ```
   The GIDs should match. The startup script automatically adjusts this.

5. **Verify jenkins user is in docker group:**
   ```bash
   docker-compose exec jenkins-agent-1 groups jenkins
   ```
   Should show `docker` in the output.

6. **Check container logs for Docker permission errors:**
   ```bash
   docker-compose logs jenkins-agent-1 | grep -i docker
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

## Docker Configuration Details

### Docker Installation
- **Master**: Docker CLI installed from official Docker repository
- **Agents**: Docker CLI installed from official Docker repository
- **Socket Mounting**: `/var/run/docker.sock` mounted from host to all containers
- **Permissions**: Automatic GID matching at container startup

### How Docker Works in This Setup
1. Docker socket is mounted from the host into Jenkins master and agents
2. Containers can execute Docker commands that run on the host Docker daemon
3. Docker group GID is automatically adjusted at startup to match host permissions
4. Jenkins user is added to docker group for proper access

### Testing Docker Access
```bash
# Test on Jenkins master
docker-compose exec jenkins docker ps

# Test on agent as jenkins user
docker-compose exec -u jenkins jenkins-agent-1 docker ps

# Test Docker build capability
docker-compose exec -u jenkins jenkins-agent-1 docker build --help
```

## Security Notes

⚠️ **This setup is for development/learning only!**

Security considerations:
- **Docker Socket Access**: Mounting Docker socket gives containers full access to host Docker daemon
- **Privileged Mode**: Agents run in privileged mode for Docker access
- **SSH Host Key Verification**: Disabled for convenience (non-verifying strategy)
- **Default Passwords**: Using default credentials (`admin/admin`, `jenkins/jenkins`)

For production:
- Enable HTTPS/TLS
- Use proper authentication and strong passwords
- Configure firewall rules
- Use secrets management (HashiCorp Vault, AWS Secrets Manager, etc.)
- Enable audit logging
- Regular security updates
- Network isolation
- Resource limits
- Consider Docker-in-Docker (DinD) instead of socket mounting
- Enable SSH host key verification
- Use SSH keys instead of passwords

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

