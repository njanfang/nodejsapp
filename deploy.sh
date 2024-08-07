#!/bin/bash

# Define directories
SOURCE_DIR="/var/nodeapp/nodejsapp"
TARGET_DIR="/var/nodeapp/new_nodejsapp"

# Copy the project directory to a new location
cp -r "$SOURCE_DIR" "$TARGET_DIR"

# Navigate to the target directory
cd /var/nodeapp || exit

# Find the process PID using port 3000
PID=$(lsof -t -i :3000)

# If PID is found, kill the process
if [ -n "$PID" ]; then
    echo "Killing process with PID: $PID"
    kill -9 "$PID"
else
    echo "No process found on port 3000."
fi

# Check if ecosystem.config.js exists
if [ -f nodejsapp/ecosystem.config.js ]; then
    echo "ecosystem.config.js found. Stopping PM2 processes..."
    pm2 stop ecosystem.config.js
else
    echo "ecosystem.config.js not found. Stopping processes by name..."
    pm2 stop nodeapp  # Replace 'nodeapp' with the actual name if needed
fi

# Install dependencies; ensure that package.json is present
if [ -f package.json ]; then
    echo "package.json found. Installing dependencies..."
    npm install
else
    echo "package.json not found. Skipping npm install."
fi

# Start the app with PM2; ensure that ecosystem.config.js is in the current directory
if [ -f nodejsapp/ecosystem.config.js ]; then
    echo "Starting PM2 processes with ecosystem.config.js..."
    pm2 start nodejsapp/ecosystem.config.js
else
    echo "ecosystem.config.js not found. Skipping PM2 start."
fi

# Output the status of the deployment
echo "Deployment is successful, running on port 3000 with new PID of instance & PM2."
