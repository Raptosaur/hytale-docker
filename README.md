# Hytale Server Docker

Docker configuration for running a dedicated Hytale server with automatic server file downloading.

Based on the official [Hytale Server Manual](https://support.hytale.com/hc/en-us/articles/45326769420827-Hytale-Server-Manual).

## Features

- **Automatic Download**: Uses the official Hytale Downloader CLI to fetch server files
- **Persistent Data**: Server files and world data stored in `./data/`
- **Easy Updates**: Re-run the downloader to update server files
- **Production Ready**: Resource limits, health checks, and auto-restart

## Requirements

- Docker and Docker Compose
- A Hytale account (for OAuth2 authentication on first run)

## Quick Start

1. **Build and run** (first time requires interactive mode for authentication):
   ```bash
   docker compose up --build
   ```

2. **Authenticate with Hytale Downloader**:
   - On first run, the downloader will prompt for OAuth2 authentication
   - Follow the URL and login with your Hytale account
   - Server files will be downloaded to `./data/`

3. **Authenticate the server**:
   - After download, the server will start and require authentication
   - Follow the prompts in the logs

4. **Connect to your server** at `your-ip:5520`

5. **Future runs** (after initial setup):
   ```bash
   docker compose up -d
   ```

## Configuration

### Memory Settings

Adjust in `docker-compose.yml`:

```yaml
environment:
  JAVA_OPTS: "-Xms4G -Xmx8G"
```

**General guidance from documentation:**
- Minimum: 4GB RAM
- View distance is the main RAM driver
- Default view distance: 384 blocks (~24 Minecraft chunks)
- Recommended max view distance: 12 chunks (384 blocks)

### Custom Port

```yaml
environment:
  SERVER_OPTS: "--bind 0.0.0.0:25565"
ports:
  - "25565:25565/udp"
```

### Disable Crash Reporting (Development)

```yaml
environment:
  SERVER_OPTS: "--disable-sentry"
```

## Data Directory

All server data is stored in `./data/`:

```
data/
├── HytaleServer.jar      # Server executable
├── HytaleServer.aot      # AOT cache for faster startup
├── Assets.zip            # Game assets
├── Server/               # Server configuration
│   └── config.json
├── universe/             # World data
│   └── worlds/
├── mods/                 # Mod files (.zip or .jar)
└── logs/                 # Server logs
```

## Networking

⚠️ **Important**: Hytale uses **QUIC protocol over UDP**, not TCP.

- Default port: `5520/udp`
- Ensure your firewall/router forwards **UDP** traffic
- TCP forwarding is NOT required

### Firewall Examples

**Linux (ufw):**
```bash
sudo ufw allow 5520/udp
```

**Linux (iptables):**
```bash
sudo iptables -A INPUT -p udp --dport 5520 -j ACCEPT
```

## Commands

```bash
# Start server (interactive, for first run)
docker compose up --build

# Start server (background, after setup)
docker compose up -d

# View logs
docker compose logs -f

# Stop server
docker compose down

# Access server console
docker attach hytale-server
# (Ctrl+P, Ctrl+Q to detach)

# Force re-download server files
rm -rf ./data/HytaleServer.jar
docker compose up
```

## Installing Mods

1. Download mods (.zip or .jar) from sources like [CurseForge](https://www.curseforge.com)
2. Place them in `./data/mods/`
3. Restart the server

## Updating the Server

To update to a new Hytale version:

```bash
# Stop the server
docker compose down

# Remove server files (keeps world data)
rm ./data/HytaleServer.jar ./data/HytaleServer.aot ./data/Assets.zip

# Restart - will re-download latest version
docker compose up
```

## Tips

- **Monitor resources**: Watch RAM/CPU usage during gameplay
- **AOT Cache**: `HytaleServer.aot` provides faster boot times (JEP-514)
- **Config changes**: Files are read on startup; changes while running may be overwritten

## Architecture

- Supports **x64** and **arm64** architectures
- Each world runs on its own main thread with shared thread pool
- No reverse proxy (BungeeCord) needed - native player routing supported

## Troubleshooting

### Players can't connect
1. Verify UDP port 5520 is forwarded (not TCP)
2. Check firewall rules allow UDP traffic
3. For symmetric NAT issues, consider a VPS or dedicated server

### High RAM usage
- Reduce view distance in world config
- Monitor with recommended plugins (e.g., `Nitrado:PerformanceSaver`)

### Downloader authentication fails
- Ensure you have a valid Hytale account
- Check your internet connection
- Try running interactively: `docker compose up` (not `-d`)

### Server not authenticating
- Follow the [Server Provider Authentication Guide](https://support.hytale.com/hc/en-us/articles/45326769420827-Server-Provider-Authentication-Guide) for bulk/automated auth
