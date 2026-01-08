# Python Example API

A simple Flask API server with a `/ping` endpoint that returns "pong".

## Prerequisites

- Python 3.11 or higher
- pip (Python package manager)

## Building the Project

### Using pip

```bash
# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

The application will start on `http://localhost:8080`

## Testing the API

Once the server is running, you can test the endpoint:

```bash
curl http://localhost:8080/ping
```

Expected response: `pong`

## Running Unit Tests

```bash
# Run tests
pytest

# Run tests with coverage
pytest --cov=app test_app.py
```

## Docker

### Build Docker Image

```bash
docker build -t python-example:1.0.0 .
```

### Run Docker Container

```bash
docker run -p 8080:8080 python-example:1.0.0
```

The API will be available at `http://localhost:8080/ping`





