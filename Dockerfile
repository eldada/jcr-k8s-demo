FROM nginx:1.17.6-alpine

LABEL mainteainer = JFrog

COPY index.html /usr/share/nginx/html/index.html

