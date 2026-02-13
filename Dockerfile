FROM nginxinc/nginx-unprivileged:latest

USER root
RUN apk add --no-cache rsync
USER 101
