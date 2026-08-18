FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY lemon-website-linux-x86_64-glibc /app/lemon-website
RUN chmod +x /app/lemon-website

EXPOSE 8080

ENTRYPOINT ["/app/lemon-website"]
