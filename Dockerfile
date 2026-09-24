FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# The Linux build of lemon-website must sit next to this Dockerfile at build time.
COPY lemon-website-linux-x86_64-glibc /app/lemon-website
RUN chmod +x /app/lemon-website

EXPOSE 8080

ENTRYPOINT ["/app/lemon-website"]
# Default arguments. The Unraid template relies on these, so keep them in sync
# with the /data/lemon and /data/charm mounts.
CMD ["--listen-address", "0.0.0.0:8080", "/data/lemon/index.json", "/data/charm/index.json"]
