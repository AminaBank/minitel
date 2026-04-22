FROM node:20-alpine

WORKDIR /app

# install system deps
RUN apk add --no-cache bash nginx openrc

# Install bun
RUN npm install -g bun
RUN bun --version

# Create user
RUN addgroup -g 10001 satoshi \
 && adduser -D -u 10001 -G satoshi -s /sbin/nologin satoshi

# Copy repo
COPY . .

# Set permissions
RUN chown -R satoshi:satoshi /app
RUN mkdir -p /tmp/.vite \
    && chown -R satoshi:satoshi /tmp/.vite

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Create nginx runtime directories
# RUN mkdir -p /var/lib/nginx/tmp/client_body \
#     && mkdir -p /var/log/nginx \
#     && mkdir -p /run/nginx \
#     && mkdir -p /app/apps \
#     && mkdir -p /tmp/.vite

# RUN mkdir -p /var/lib/nginx/tmp /var/log/nginx /run/nginx \
#     && chown -R satoshi:satoshi /var/lib/nginx /var/log/nginx /run/nginx \
#     && chmod -R 755 /var/lib/nginx /var/log/nginx /run/nginx

# Set permissions
# RUN chown -R satoshi:satoshi /app
# RUN mkdir -p /tmp/.vite \
#     && chown -R satoshi:satoshi /tmp/.vite

# ensure app is writable for Vite cache
# RUN chown -R satoshi:satoshi /app \
#     && chown -R satoshi:satoshi /var/lib/nginx \
#     && chown -R satoshi:satoshi /var/log/nginx \
#     && chown -R satoshi:satoshi /run/nginx \
#     && chown -R satoshi:satoshi /tmp/.vite

# Run nginx on startup
# RUN mkdir -p /run/openrc/ \
#     && touch /run/openrc/softlevel \
#     && rc-update add nginx default

# Switch to non-root user
# USER satoshi

# Install deps
RUN bun install

# Expose default 80 port
EXPOSE 80

# Run
CMD ["sh", "-c", "bun run dev & sleep 3 && nginx -g 'daemon off;'"]
#CMD ["bun", "run", "dev"]