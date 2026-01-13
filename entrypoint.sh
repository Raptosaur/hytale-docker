#!/bin/bash
set -e

SERVER_DIR="/server/data"
SERVER_JAR="$SERVER_DIR/Server/HytaleServer.jar"
DOWNLOAD_ZIP="$SERVER_DIR/hytale-server.zip"
CREDENTIALS_FILE="$SERVER_DIR/.hytale-downloader-credentials.json"

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
    
    # Run the downloader with credentials in persistent storage
    # Use -download-path to specify where to save the zip
    if [ -f "$CREDENTIALS_FILE" ]; then
        echo "Using saved credentials..."
    fi
    
    hytale-downloader -download-path "$DOWNLOAD_ZIP"
    
    echo ""
    echo "Download complete! Extracting files..."
    echo ""
    
    # Extract the zip file
    unzip -o "$DOWNLOAD_ZIP" -d "$SERVER_DIR"
    
    # Clean up the zip file to save space
    rm -f "$DOWNLOAD_ZIP"
    
    echo "Extraction complete!"
    echo ""
fi

# Change to server directory (where HytaleServer.jar is located)
cd "$SERVER_DIR/Server"

# Start the Hytale server
echo "=============================================="
echo "  Starting Hytale Server..."
echo "=============================================="
echo "Java Options: $JAVA_OPTS"
echo "Server Options: $SERVER_OPTS"
echo ""

exec java $JAVA_OPTS -jar $SERVER_JAR --assets /server/data/Assets.zip $SERVER_OPTS
