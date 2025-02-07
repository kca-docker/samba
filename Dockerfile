# Use alpine image as base
FROM docker.io/alpine:3

# CI build arguments
ARG VERSION="0.0.0"
ARG CREATED="RFC 3339 date-time"
ARG REVISION="sourceID"

## Fix information
LABEL org.opencontainers.image.url="https://hub.docker.com/r/bksolutions/samba" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/bksolutions/samba" \
      org.opencontainers.image.source="https://github.com/kca-docker/samba" \
      org.opencontainers.image.title="SAMBA" \
      org.opencontainers.image.description="Provide secure, stable and fast file and print services for all clients using the SMB/CIFS" \
      org.opencontainers.image.authors="bksolutions"

# Install samba
RUN apk --no-cache add samba shadow tini tzdata && \
    addgroup -S smb && \
    adduser -S -D -H -h /tmp -s /sbin/nologin -G smb -g 'Samba User' smbuser


# Define working directory
WORKDIR /etc/samba

# Export ports required by samba
EXPOSE 137/udp 138/udp 139 445

# Expose all volumes
VOLUME ["/mnt", \
        "/etc/samba", \
        "/var/log/samba",\
        "/var/cache/samba", \
        "/var/lib/samba", \
        "/run/samba"]


# Define healthcheck
HEALTHCHECK --interval=60s --timeout=15s \
        CMD ["smbclient", "-L", "\\localhost", "-U", "%", "-m", "SMB3"]

# Add startup script and define entrypoint
ADD  ./scripts/samba.sh /usr/bin/samba.sh
ENTRYPOINT ["/sbin/tini", "-p", "-g", "--", "/usr/bin/samba.sh"]