FROM nginx:1.31.9-alpine3.24

# Copy static site
COPY ./src /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Default nginx entrypoint