FROM node:20-alpine

WORKDIR /app

# system deps
RUN apk add --no-cache bash nginx supervisor

# install bun
RUN npm install -g bun

# create user
RUN addgroup -g 10001 satoshi \
 && adduser -D -u 10001 -G satoshi -s /bin/sh satoshi

# copy repo first
COPY apps apps
COPY packages packages
COPY bun.lock bun.lock
COPY package.json package.json
COPY tsconfig.json tsconfig.json

# configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# create nginx required dirs
RUN mkdir -p /tmp/nginx/logs \
    /tmp/nginx/client_body \
    /tmp/nginx/proxy \
    /tmp/nginx/fastcgi \
    && chown -R satoshi:satoshi /tmp/nginx

# fix app permissions for satoshi
RUN chown -R satoshi:satoshi /app
USER satoshi

# install deps
RUN bun install

EXPOSE 8088

# start
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]