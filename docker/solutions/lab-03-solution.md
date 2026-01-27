# Docker Lab 03: Solution - Docker Compose CI/CD Stack

## Objective

Create a Docker Compose setup with Jenkins, Gitea, and Docker Registry running together.

## Prerequisites

- Docker installed and running
- Docker Compose v2 available (`docker compose version`)

## Step 1: Create project directory

```bash
mkdir -p ~/docker-lab-03
cd ~/docker-lab-03
```

## Step 2: Create `docker-compose.yml`

Create `~/docker-lab-03/docker-compose.yml`:

```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
    environment:
      - JENKINS_OPTS=--httpPort=8080
    networks:
      - ci-cd-network
    restart: unless-stopped

  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    ports:
      - "3000:3000"
      - "2224:22"
    volumes:
      - gitea_data:/data
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__database__DB_TYPE=sqlite3
      - GITEA__database__PATH=/data/gitea/gitea.db
      - GITEA__server__DOMAIN=localhost
      - GITEA__server__SSH_DOMAIN=localhost
      - GITEA__server__SSH_PORT=22
      - GITEA__server__HTTP_PORT=3000
    networks:
      - ci-cd-network
    restart: unless-stopped

  docker-registry:
    image: registry:2
    container_name: docker-registry
    ports:
      - "5000:5000"
    volumes:
      - registry_data:/var/lib/registry
    networks:
      - ci-cd-network
    restart: unless-stopped

volumes:
  jenkins_home:
  gitea_data:
  registry_data:

networks:
  ci-cd-network:
    driver: bridge
```

## Step 3: Start the stack

```bash
docker compose up -d
```

## Step 4: Verify services are running

```bash
docker compose ps
```

You should see all three services with status "Up".

## Step 5: Check service logs

```bash
# Check Jenkins logs
docker compose logs jenkins --tail=50

# Check Gitea logs
docker compose logs gitea --tail=50

# Check Docker Registry logs
docker compose logs docker-registry --tail=50
```

## Step 6: Verify service accessibility

### Jenkins

Open in browser: `http://localhost:8080`

You should see the Jenkins setup wizard. On first run, you'll need to:
1. Retrieve the initial admin password from logs:
   ```bash
   docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
2. Complete the setup wizard

### Gitea

Open in browser: `http://localhost:3000`

You should see the Gitea installation page. On first run, you'll need to:
1. Complete the initial configuration
2. Create an admin account

### Docker Registry

Test with curl:

```bash
curl http://localhost:5000/v2/
```

Expected response: `{}` (empty JSON object)

## Step 7: Test network connectivity

Verify services can communicate with each other:

```bash
# From Jenkins container, ping Gitea
docker compose exec jenkins ping -c 2 gitea

# From Jenkins container, ping Docker Registry
docker compose exec jenkins ping -c 2 docker-registry

# From Gitea container, ping Jenkins
docker compose exec gitea ping -c 2 jenkins
```

All ping commands should succeed.

## Step 8: Test Docker Registry (optional)

Try pushing an image to the registry:

```bash
# Tag a test image
docker tag hello-world localhost:5000/hello-world:test

# Push to registry
docker push localhost:5000/hello-world:test

# Verify it's stored
curl http://localhost:5000/v2/_catalog
```

Expected response should include your image:
```json
{"repositories":["hello-world"]}
```

## Clean up

When finished:

```bash
cd ~/docker-lab-03
docker compose down
```

To also remove volumes (deletes all data):

```bash
docker compose down -v
```

## Key Concepts Learned

1. **Multi-service orchestration**: Using Docker Compose to run multiple services together
2. **Service networking**: Services on the same network can communicate using service names
3. **Volume persistence**: Named volumes preserve data across container restarts
4. **Port mapping**: Exposing services to the host machine
5. **Service discovery**: Docker Compose provides DNS resolution for service names
6. **Restart policies**: Keeping services running automatically

## Troubleshooting

### Jenkins won't start
- Check if port 8080 is already in use: `lsof -i :8080`
- Check Jenkins logs: `docker compose logs jenkins`
- Ensure volume permissions are correct

### Gitea installation page not loading
- Wait a few seconds for Gitea to fully start
- Check Gitea logs: `docker compose logs gitea`
- Verify port 3000 is not in use: `lsof -i :3000`

### Docker Registry returns errors
- Check registry logs: `docker compose logs docker-registry`
- For insecure registry (localhost), you may need to configure Docker daemon (not required for this lab)
- Verify port 5000 is not in use: `lsof -i :5000`

### Services can't ping each other
- Verify all services are on the same network: `docker network inspect docker-lab-03_ci-cd-network`
- Check service names match exactly (case-sensitive)
- Ensure services are running: `docker compose ps`

## Additional Notes

- **First-time setup**: Both Jenkins and Gitea require initial configuration through their web UIs
- **Data persistence**: All data is stored in named volumes and persists across container restarts
- **Resource usage**: These services can be resource-intensive; ensure your system has enough RAM (recommended: 4GB+)
- **Production considerations**: This setup is for learning purposes. For production:
  - Use proper authentication and security
  - Configure HTTPS/TLS
  - Set up proper backup strategies
  - Use external databases instead of SQLite for Gitea
  - Configure proper registry authentication

---

**Congratulations!** You've successfully set up a complete CI/CD stack with Jenkins, Gitea, and Docker Registry using Docker Compose.
