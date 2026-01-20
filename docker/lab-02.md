## Docker Lab 02: Docker Compose (Python app + Nginx reverse proxy)

## Goal

Run a **multi-container** app using **Docker Compose**:

- A Python (Flask) app from `application/python-example/`
- An Nginx container acting as a **reverse proxy** in front of the app

## What you will do

Complete the following tasks:

1. **Create a `docker-compose.yml`** inside `application/python-example/`
2. **Run the Python app** as a Compose service (build from the provided `Dockerfile`)
3. **Run Nginx** as a Compose service and configure it to reverse proxy to the app
4. **Verify** you can reach the app through Nginx at `http://localhost:8080/ping`

## Requirements

- Use **Compose v2** (`docker compose ...`)
- The backend app listens on **port 8080** in the container and responds on:
  - `GET /ping` → `pong`
- Nginx should:
  - Listen on **port 80** in the container
  - Be published to **port 8080** on your host (so you can browse/curl locally)
  - Reverse proxy requests to the backend service via the Compose network (service-to-service DNS)

## Suggested project layout (create these files/folders)

From repo root:

```bash
cd application/python-example
```

Create:

```text
application/python-example/
  docker-compose.yml
  nginx/
    default.conf
```

## Hints (recommended approach)

### Compose services

In your `docker-compose.yml` define two services:

- **`app`**
  - `build: .`
  - Do not publish the app port to the host (Nginx should be the only public entry point)
  - Use `expose: ["8080"]` (or just rely on the internal network)
- **`nginx`**
  - `image: nginx:alpine`
  - `ports: ["8080:80"]`
  - Mount your Nginx config into the container:
    - `./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro`
  - `depends_on: ["app"]`

### Nginx reverse proxy config

In `nginx/default.conf`, proxy to the Compose service name `app`:

- Backend URL should be: `http://app:8080`
- Make sure you include standard proxy headers (at minimum `Host`, `X-Forwarded-For`, `X-Forwarded-Proto`)

## Verification

From `application/python-example/`:

```bash
docker compose up --build -d
docker compose ps
docker compose logs -f --tail=100
```

Then verify the reverse proxy works:

```bash
curl -i http://localhost:8080/ping
```

**Expected result**: HTTP 200 response with body `pong`.

## Troubleshooting

- **Port already in use**: change the host port mapping (example: `8081:80`) and retry.
- **Nginx returns 502/504**:
  - Confirm your upstream points to `app:8080` (service name, not `localhost`)
  - Check logs: `docker compose logs nginx app --tail=200`
- **Config not applied**:
  - Confirm the volume mount path is correct
  - Restart only nginx: `docker compose restart nginx`

## Clean up

Stop and remove containers + the Compose network:

```bash
docker compose down
```

If you also want to remove volumes (if you created any later):

```bash
docker compose down -v
```

---

**Note:** For detailed step-by-step instructions, see `docker/solutions/lab-02-solution.md`
