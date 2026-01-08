# Java Example API

A simple Spring Boot API server with a `/ping` endpoint that returns "pong".

## Prerequisites

- Java 17 or higher
- Maven 3.6 or higher

## Building the Project

### Using Maven

```bash
# Build the project
mvn clean package

# Run tests
mvn test

# Run the application
mvn spring-boot:run
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
mvn test
```

## Docker

### Build Docker Image

```bash
docker build -t java-example:1.0.0 .
```

### Run Docker Container

```bash
docker run -p 8080:8080 java-example:1.0.0
```

The API will be available at `http://localhost:8080/ping`





