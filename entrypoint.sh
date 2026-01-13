#!/bin/bash
set -e

SERVER_DIR="/server/data"
SERVER_JAR="$SERVER_DIR/HytaleServer.jar"

# Check if server files exist
if [ ! -f "$SERVER_JAR" ]; then
    echo "=============================================="
    echo "  Hytale Server files not found!"
    echo "  Running Hytale Downloader..."
    echo "=============================================="
    echo ""
    echo "You will need to authenticate with your Hytale account."
    echo "Follow the prompts below:"
    echo ""
    
    cd "$SERVER_DIR"
    
    # Run the downloader
    # The downloader will handle OAuth2 authentication
    hytale-downloader
    
    echo ""
    echo "Download complete!"
    echo ""
fi

# Change to server directory
cd "$SERVER_DIR"

# Start the Hytale server
echo "=============================================="
echo "  Starting Hytale Server..."
echo "=============================================="
echo "Java Options: $JAVA_OPTS"
echo "Server Options: $SERVER_OPTS"
echo ""

exec java $JAVA_OPTS -jar $SERVER_JAR $SERVER_OPTS
