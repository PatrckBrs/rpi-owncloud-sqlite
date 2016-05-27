# Pull base image
#FROM resin/rpi-raspbian:latest
FROM ubuntu:latest

RUN apt-get -y update && apt-get install -y nginx

CMD service nginx start
