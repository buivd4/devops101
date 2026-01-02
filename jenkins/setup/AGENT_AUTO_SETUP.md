# Jenkins Agent Auto-Setup with JCasC

## Overview

The Jenkins agents (agent-1 and agent-2) are automatically configured and added to the Jenkins master using Jenkins Configuration as Code (JCasC). No manual configuration is required.

## How It Works

### 1. JCasC Configuration (`jenkins-config.yaml`)

The agents are defined in the `jenkins.nodes` section:

```yaml
jenkins:
  nodes:
    - permanent:
        name: "agent-1"
        nodeDescription: "Docker-enabled Jenkins agent 1"
        remoteFS: "/home/jenkins/agent"
        numExecutors: 2
        labelString: "docker agent-1 linux"
        mode: NORMAL
        retentionStrategy: "always"
        launcher:
          ssh:
            host: "jenkins-agent-1"
            port: 22
            credentialsId: "agent-ssh-credentials"
            # ... SSH configuration
```

### 2. Automatic Setup Process

When Jenkins starts:

1. **JCasC Plugin loads** `jenkins-config.yaml`
2. **Nodes are created** automatically in Jenkins
3. **Credentials are created** (`agent-ssh-credentials`)
4. **Jenkins attempts to connect** to agents via SSH
5. **Agent JAR is deployed** to the agent via SSH
6. **Agent connects** back to Jenkins master

### 3. Agent Requirements

The agent containers must have:
- ✅ SSH server running (configured in `Dockerfile.agent`)
- ✅ Java installed (included in `openjdk:26-ea-11-jdk-slim` base image)
- ✅ Docker CLI (for building Docker images)
- ✅ Network connectivity to Jenkins master

## Configuration Details

### Agent Configuration

Each agent has:

- **Name**: `agent-1`, `agent-2`
- **Executors**: 2 per agent
- **Labels**: `docker agent-1 linux`, `docker agent-2 linux`
- **Retention**: `always` (agents stay connected)
- **SSH Launcher**: Connects via SSH using credentials
- **Node Properties**: Environment variables (DOCKER_HOST)

### SSH Credentials

Defined in JCasC:
- **ID**: `agent-ssh-credentials`
- **Username**: `jenkins`
- **Password**: `jenkins`
- **Scope**: GLOBAL

### Connection Process

1. Jenkins master connects via SSH to `jenkins-agent-1:22` or `jenkins-agent-2:22`
2. Uses credentials `agent-ssh-credentials`
3. Deploys `agent.jar` to `/home/jenkins/agent`
4. Starts the agent process
5. Agent connects back to Jenkins master

## Verification

### Check Agents in Jenkins UI

1. Access Jenkins: http://localhost:8080
2. Go to: **Manage Jenkins** → **Nodes**
3. You should see:
   - `agent-1` (should be online)
   - `agent-2` (should be online)

### Check via API

```bash
# List all nodes
curl -u admin:admin http://localhost:8080/computer/api/json | jq '.computer[].displayName'

# Check agent-1 status
curl -u admin:admin http://localhost:8080/computer/agent-1/api/json | jq '.offline'
```

### Use Verification Script

```bash
cd jenkins/setup
./verify-agents.sh
```

## Troubleshooting

### Agents Show as Offline

1. **Check agent containers are running:**
   ```bash
   docker-compose ps jenkins-agent-1 jenkins-agent-2
   ```

2. **Check SSH server is running:**
   ```bash
   docker-compose exec jenkins-agent-1 pgrep sshd
   ```

3. **Check SSH connectivity from Jenkins:**
   ```bash
   docker-compose exec jenkins ssh jenkins@jenkins-agent-1
   # Password: jenkins
   ```

4. **Check Jenkins logs:**
   ```bash
   docker-compose logs jenkins | grep -i agent
   ```

5. **Check agent logs:**
   ```bash
   docker-compose logs jenkins-agent-1
   ```

### Common Issues

**Issue**: Agents don't appear in Jenkins
- **Solution**: Check JCasC configuration is loaded (Manage Jenkins → Configuration as Code → View Configuration)

**Issue**: SSH connection fails
- **Solution**: Verify credentials match (username: `jenkins`, password: `jenkins`)
- **Solution**: Check network connectivity between containers

**Issue**: Agent JAR deployment fails
- **Solution**: Verify `/home/jenkins/agent` directory exists and is writable
- **Solution**: Check Java is installed on agent

**Issue**: Agents connect but go offline immediately
- **Solution**: Check agent logs for errors
- **Solution**: Verify agent has network access to Jenkins master on port 50000

## Manual Connection Test

To manually test SSH connection:

```bash
# Test SSH from Jenkins container to agent
docker-compose exec jenkins ssh -o StrictHostKeyChecking=no jenkins@jenkins-agent-1

# Or from host (if ports are mapped)
ssh -p 2222 jenkins@localhost
# Password: jenkins
```

## Adding More Agents

To add more agents:

1. **Add service to `docker-compose.yml`:**
   ```yaml
   jenkins-agent-3:
     build:
       context: .
       dockerfile: Dockerfile.agent
     container_name: jenkins-agent-3
     # ... (similar to agent-1)
   ```

2. **Add node to `jenkins-config.yaml`:**
   ```yaml
   - permanent:
       name: "agent-3"
       # ... (similar to agent-1 configuration)
   ```

3. **Restart services:**
   ```bash
   docker-compose up -d
   ```

## Notes

- Agents are **permanent nodes** (not ephemeral)
- Agents use **SSH launcher** (not JNLP)
- Agents **auto-connect** when containers start
- Agents **auto-reconnect** if connection is lost
- JCasC **automatically creates** nodes on Jenkins startup
- No manual node configuration needed in Jenkins UI

