# Hytale Dedicated Server Dockerfile
# Based on: https://support.hytale.com/hc/en-us/articles/45326769420827-Hytale-Server-Manual

# Adoptium Temurin JRE 25 (eclipse-temurin is the official Adoptium Docker image)
# https://adoptium.net/
FROM eclipse-temurin:25-jre-alpine

LABEL maintainer="Hytale Server"
LABEL description="Hytale Dedicated Server"

# Install required packages
RUN apk add --no-cache bash

# Create a non-root user for running the server
RUN addgroup -S hytale && adduser -S hytale -G hytale

# Create server directory
WORKDIR /server

# Copy the Hytale Downloader CLI
COPY --chmod=755 hytale-downloader-linux-amd64 /usr/local/bin/hytale-downloader

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Create directories for persistent data
RUN mkdir -p /server/data \
    && chown -R hytale:hytale /server

# Expose the default Hytale port (UDP for QUIC protocol)
EXPOSE 5520/udp

# Environment variables for JVM configuration
ENV JAVA_OPTS="-Xms4G -Xmx4G"
ENV SERVER_OPTS=""

# Health check - verify Java is working
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD java -version || exit 1

# Use the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
