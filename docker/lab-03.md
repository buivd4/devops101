## Docker Lab 03: Docker Compose - CI/CD Stack (Jenkins, Gitea, Docker Registry)

## Goal

Create a **Docker Compose** setup that runs three services together:

- **Jenkins** - CI/CD automation server
- **Gitea** - Git repository hosting
- **Docker Registry** - Private Docker image registry

## What you will do

Complete the following tasks:

1. **Create a `docker-compose.yml`** file that defines all three services
2. **Configure each service** with appropriate ports, volumes, and environment variables
3. **Set up networking** so services can communicate with each other
4. **Verify** all three services are accessible

## Requirements

### Jenkins
- Use the official `jenkins/jenkins:lts` image
- Expose Jenkins web UI on **port 8080** (host) → 8080 (container)
- Expose Jenkins agent port on **port 50000** (host) → 50000 (container)
- Create a named volume for Jenkins data persistence (`jenkins_home`)
- Set environment variable to skip setup wizard: `JENKINS_OPTS=--httpPort=8080`

### Gitea
- Use the official `gitea/gitea:latest` image
- Expose web UI on **port 3000** (host) → 3000 (container)
- Expose SSH on **port 2224** (host) → 22 (container)
- Create a named volume for Gitea data persistence (`gitea_data`)
- Configure with environment variables:
  - `GITEA__database__DB_TYPE=sqlite3`
  - `GITEA__server__DOMAIN=localhost`
  - `GITEA__server__HTTP_PORT=3000`
  - `GITEA__server__SSH_PORT=22`

### Docker Registry
- Use the official `registry:2` image
- Expose registry API on **port 5000** (host) → 5000 (container)
- Create a named volume for registry data persistence (`registry_data`)
- Optionally configure with a basic config file (not required for this lab)

### Networking
- All services should be on the **same Docker network** (create a custom bridge network)
- Services should be able to reach each other by service name (e.g., `jenkins`, `gitea`, `docker-registry`)

## Suggested project layout

Create a new directory for this lab:

```bash
mkdir -p ~/docker-lab-03
cd ~/docker-lab-03
```

Create:

```text
~/docker-lab-03/
  docker-compose.yml
```

## Hints

### Service names
- Use service names: `jenkins`, `gitea`, `docker-registry`

### Volumes
- Use named volumes (not bind mounts) for data persistence:
  - `jenkins_home`
  - `gitea_data`
  - `registry_data`

### Network
- Create a custom bridge network (e.g., `ci-cd-network`)
- Add all services to this network

### Restart policy
- Consider using `restart: unless-stopped` for all services

### Dependencies
- Services don't need to wait for each other to start, but you can use `depends_on` if you want explicit ordering

## Verification

After starting your stack:

```bash
cd ~/docker-lab-03
docker compose up -d
docker compose ps
```

Verify each service:

1. **Jenkins**: Open `http://localhost:8080` in your browser
   - You should see the Jenkins setup wizard or login page
   - Check logs: `docker compose logs jenkins`

2. **Gitea**: Open `http://localhost:3000` in your browser
   - You should see the Gitea installation page
   - Check logs: `docker compose logs gitea`

3. **Docker Registry**: Test with curl:
   ```bash
   curl http://localhost:5000/v2/
   ```
   - Expected response: `{}` (empty JSON object)
   - Check logs: `docker compose logs docker-registry`

4. **Network connectivity**: Verify services can reach each other:
   ```bash
   docker compose exec jenkins ping -c 2 gitea
   docker compose exec jenkins ping -c 2 docker-registry
   ```

## Troubleshooting

- **Port conflicts**: If ports are already in use, change the host port mappings in `docker-compose.yml`
- **Services not starting**: Check logs with `docker compose logs <service-name>`
- **Permission issues**: Ensure Docker has proper permissions to create volumes
- **Jenkins setup wizard**: This is expected on first run - you'll need to complete the initial setup
- **Gitea installation**: Gitea requires initial configuration through the web UI on first run

## Clean up

Stop and remove containers, networks, and volumes:

```bash
cd ~/docker-lab-03
docker compose down
```

To also remove volumes (this will delete all data):

```bash
docker compose down -v
```

## Expected Results

After completing this lab, you should be able to:

- Access Jenkins at `http://localhost:8080`
- Access Gitea at `http://localhost:3000`
- Access Docker Registry at `http://localhost:5000`
- Understand how to orchestrate multiple services with Docker Compose
- Understand Docker networking and service discovery
- Understand volume management for data persistence

---

**Note:** For detailed step-by-step instructions, see `docker/solutions/lab-03-solution.md`
