## Features

- _Frontend_ written in React
- _Backend_ written in Go
- _PostgreSQL_ database connected to the Backend
- In-memory database _Redis_ to the Backend
- _Nginx_ as a Reverse Proxy

## Project Diagram

![Project Diagram](./app-screeshots/app-diagram.png)

## Exercise done on this project

- Ex-1.12: Create a Dockerfile for _Frontend_ and listens on port 5000
- Ex-1.13: Create a Dockerfile for _Backend_ and listens on port 8080
- Ex-1.14: Exposed ports for frontend and backend correctly and frontend gets response from backend api when talk to browser
- Ex-2.3: Configure the backend and frontend to work in docker-compose.
- Ex-2.4: Using Docker Networking, redis is connected to the backend as docker container
- Ex-2.6: connected to a postgres database to save messages. postgreql starts as docker container and configured to docker-compose file.
- Ex-2.8: Add Nginx which will function as a reverse proxy (see the image above). The requests arriving at anything other than /api will be redirected to frontend container and /api will get redirected to backend container.
- Ex-2.9-2.10: Complete all configurations on docker-compose so that the app start when "docker-compose up" command given and all services are accesible.
- Ex-3.3: For security reasons, removed the root access and make sure the containers start their processes as a non-root user.
- Ex-3.4-3.5: Optimize the size of the images
- Ex-3.6: Multi-stage build for the backend app


## Complete Project Screenshot

![Project Diagram](./app-screeshots/complete-project.png)
