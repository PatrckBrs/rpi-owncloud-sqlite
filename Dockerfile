# Pull base image
FROM resin/rpi-raspbian:latest

RUN apt-get update

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
