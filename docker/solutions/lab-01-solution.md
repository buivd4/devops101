# Docker Lab 01: Solution - Running Nginx with Custom HTML and Port Mapping

## Objective

In this lab, you will learn how to:
1. Run an Nginx container
2. Modify a static HTML file
3. Mount a port to access the web server on port 8080

## Prerequisites

- Docker installed and running on your system
- Basic knowledge of command line
- A text editor (nano, vim, or your preferred editor)

## Instructions

### Step 1: Create a Custom HTML File

First, create a directory for your web content and a simple HTML file:

```bash
# Create a directory for your web files
mkdir -p ~/docker-lab/html

# Create a simple HTML file
cat > ~/docker-lab/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Lab 01</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            color: #333;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Docker Lab 01!</h1>
        <p>This is a custom HTML page served by Nginx in a Docker container.</p>
        <p>You successfully completed the lab!</p>
    </div>
</body>
</html>
EOF
```

### Step 2: Run Nginx Container with Port Mapping

Run the Nginx container and map port 8080 on your host to port 80 in the container:

```bash
docker run -d \
  --name nginx-lab \
  -p 8080:80 \
  -v ~/docker-lab/html:/usr/share/nginx/html:ro \
  nginx:latest
```

**Command Explanation:**
- `-d`: Run container in detached mode (in the background)
- `--name nginx-lab`: Give the container a friendly name
- `-p 8080:80`: Map port 8080 on your host to port 80 in the container
- `-v ~/docker-lab/html:/usr/share/nginx/html:ro`: Mount your HTML directory to Nginx's default web root (read-only)
- `nginx:latest`: Use the latest Nginx image

### Step 3: Verify the Container is Running

Check that your container is running:

```bash
docker ps
```

You should see a container named `nginx-lab` with status "Up".

### Step 4: Access Your Web Server

Open your web browser and navigate to:

```
http://localhost:8080
```

You should see your custom HTML page!

### Step 5: Modify the HTML File

Now, let's modify the HTML file to see the changes reflected:

```bash
# Edit the HTML file
nano ~/docker-lab/html/index.html
```

Or use your preferred editor. Change the content, for example:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Lab 01 - Modified</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #2c3e50;
            color: white;
        }
        h1 {
            color: #3498db;
        }
        .container {
            background-color: #34495e;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello from Docker!</h1>
        <p>This HTML file has been modified.</p>
        <p>The changes are visible immediately because we mounted a volume!</p>
        <p><strong>Port 8080 is successfully mapped!</strong></p>
    </div>
</body>
</html>
```

Save the file and refresh your browser at `http://localhost:8080`. You should see the updated content without restarting the container!

### Step 6: Clean Up

When you're done, stop and remove the container:

```bash
# Stop the container
docker stop nginx-lab

# Remove the container
docker rm nginx-lab
```

## Key Concepts Learned

1. **Port Mapping**: The `-p 8080:80` flag maps port 8080 on your host machine to port 80 inside the container
2. **Volume Mounting**: The `-v` flag allows you to mount a directory from your host into the container, enabling live updates
3. **Detached Mode**: The `-d` flag runs the container in the background
4. **Container Naming**: Using `--name` makes it easier to reference your container

## Troubleshooting

### Container won't start
- Check if port 8080 is already in use: `lsof -i :8080` or `netstat -an | grep 8080`
- Use a different port: `-p 8081:80`

### Can't see changes in browser
- Make sure you saved the HTML file
- Try a hard refresh (Ctrl+F5 or Cmd+Shift+R)
- Check that the volume mount path is correct

### Permission issues
- Make sure the HTML directory exists and is readable
- Check Docker has permission to access the directory

## Next Steps

- Try creating additional HTML pages and accessing them
- Experiment with different Nginx configurations
- Learn about Docker networks and multi-container applications

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Docker Hub - Nginx](https://hub.docker.com/_/nginx)

---

**Congratulations!** You've successfully completed Lab 01. You now know how to run Nginx in Docker, modify static content, and map ports.
