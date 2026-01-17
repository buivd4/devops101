# Docker Lab 01: Running Nginx with Custom HTML and Port Mapping

## Instructions

Complete the following tasks:

1. **Run an Nginx container** using Docker
2. **Create and modify a static HTML file** that will be served by Nginx
3. **Map port 8080** on your host machine to port 80 in the container

## Requirements

- Use the `nginx:latest` Docker image
- Create a custom HTML file on your host machine
- Mount the HTML file directory to the container so changes are reflected without restarting
- Map port 8080 (host) to port 80 (container)
- Verify you can access the web server at `http://localhost:8080`
- Modify the HTML file and confirm changes are visible in the browser

## Expected Results

After completing this lab, you should be able to:

- Access a custom HTML page at `http://localhost:8080`
- See changes to the HTML file immediately after saving (without restarting the container)
- Understand how Docker port mapping works
- Understand how Docker volume mounting works

## Hints

- Use `docker run` with appropriate flags
- The Nginx default web root is `/usr/share/nginx/html`
- Use the `-p` flag for port mapping
- Use the `-v` flag for volume mounting
- Use the `-d` flag to run in detached mode
- Use `--name` to give your container a friendly name

## Verification

To verify your solution:

1. Run `docker ps` to see your running container
2. Open `http://localhost:8080` in your browser
3. Modify the HTML file and refresh the browser to see changes
4. Check that the port mapping is correct: `docker port <container-name>`

## Clean Up

When finished, stop and remove your container:

```bash
docker stop <container-name>
docker rm <container-name>
```

---

**Note:** For detailed step-by-step instructions, see `solutions/lab-01-solution.md`
