FROM nginx:1.17.6-alpine

LABEL maintainer="eldada@jfrog.com"
LABEL description="A simple example of an Nginx Docker image with a custom index.html file"

COPY index.html /usr/share/nginx/html/index.html
