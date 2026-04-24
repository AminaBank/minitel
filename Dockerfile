FROM node:20-alpine

WORKDIR /app

# system deps
RUN apk add --no-cache bash nginx

# install bun
RUN npm install -g bun

# create user
RUN addgroup -g 10001 satoshi \
 && adduser -D -u 10001 -G satoshi -s /bin/sh satoshi

# copy repo first
COPY . .

# nginx runtime dirs
RUN mkdir -p /run/nginx \
    /var/log/nginx \
    /var/lib/nginx/tmp \
 && chown -R nginx:nginx /run/nginx /var/log/nginx /var/lib/nginx

# nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# fix app permissions for satoshi
RUN chown -R satoshi:satoshi /app

# install deps as root
RUN bun install

EXPOSE 80

# start both services
CMD ["sh", "-c", "bun run dev & nginx -g 'daemon off;'"]
