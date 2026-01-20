# Flask + MySQL Example API

A simple Flask API server backed by MySQL.

- `GET /ping`: returns `pong` **and increments** a counter stored in MySQL
- `GET /stats`: returns the current request count for `/ping`

## Run with Docker Compose (recommended)

From the repo root:

```bash
cd application/flask-example
docker compose up --build
```

In another terminal:

```bash
curl http://localhost:8080/ping
curl http://localhost:8080/ping
curl http://localhost:8080/stats
```

Expected `/stats` response:

```json
{"ping":2}
```

## Clean up

```bash
cd application/flask-example
docker compose down
```

To also delete the MySQL volume (resets counts):

```bash
docker compose down -v
```

## Run locally (without Docker)

You need a running MySQL instance and these environment variables set:

- `DB_HOST`
- `DB_PORT`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`

Then:

```bash
python3 -m pip install -r requirements.txt
python3 app.py
```

