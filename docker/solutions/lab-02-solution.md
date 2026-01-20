# Docker Lab 02: Solution - Docker Compose (Python app + Nginx reverse proxy)

## Objective

Run the Flask app in `application/python-example/` behind an Nginx reverse proxy using Docker Compose, then verify:

- `GET http://localhost:8080/ping` returns `pong`

## Prerequisites

- Docker installed and running
- Docker Compose v2 available (`docker compose version`)

## Step 1: Go to the Python example directory

From the repo root:

```bash
cd application/python-example
```

## Step 2: Create the Nginx reverse proxy config

Create `application/python-example/nginx/default.conf`:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://app:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Step 3: Create `docker-compose.yml`

Create `application/python-example/docker-compose.yml`:

```yaml
services:
  app:
    build: .
    expose:
      - "8080"

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - app
```

## Step 4: Start the stack

From `application/python-example/`:

```bash
docker compose up --build -d
docker compose ps
```

## Step 5: Verify the reverse proxy works

```bash
curl -i http://localhost:8080/ping
```

Expected output includes:

- HTTP 200
- Body: `pong`

## Step 6: Inspect logs (optional)

```bash
docker compose logs nginx app --tail=200
```

## Step 7: Clean up

```bash
docker compose down
```

## Notes

- Compose provides a default network; the service name `app` resolves via internal DNS, so Nginx can proxy to `http://app:8080`.
- `depends_on` controls startup order but does not wait for the app to be “ready”. If you see a temporary `502`, wait a few seconds and retry the curl.

