# Flask Systemd Service

This directory contains a simple Flask application configured to run as a systemd service.

## Files

- `app.py` - Simple Flask application with health check endpoints
- `requirements.txt` - Python dependencies
- `flask-app.service` - Systemd service file

## Setup Instructions

1. **Install dependencies:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. **Deploy the application:**
   ```bash
   sudo mkdir -p /opt/flask-app
   sudo cp app.py requirements.txt /opt/flask-app/
   sudo cp -r venv /opt/flask-app/
   sudo chown -R www-data:www-data /opt/flask-app
   ```

3. **Install the service:**
   ```bash
   sudo cp flask-app.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable flask-app.service
   sudo systemctl start flask-app.service
   ```

4. **Check service status:**
   ```bash
   sudo systemctl status flask-app.service
   ```

5. **View logs:**
   ```bash
   sudo journalctl -u flask-app.service -f
   ```

## Service Management

- **Start:** `sudo systemctl start flask-app.service`
- **Stop:** `sudo systemctl stop flask-app.service`
- **Restart:** `sudo systemctl restart flask-app.service`
- **Status:** `sudo systemctl status flask-app.service`
- **Enable on boot:** `sudo systemctl enable flask-app.service`
- **Disable on boot:** `sudo systemctl disable flask-app.service`

## Endpoints

- `http://localhost:5000/` - Main endpoint
- `http://localhost:5000/health` - Health check endpoint

## Notes

- The service runs on port 5000 by default
- The service user is set to `www-data` (adjust if needed)
- The service automatically restarts on failure with a 10-second delay
- Make sure to adjust the paths in the service file if deploying to a different location

