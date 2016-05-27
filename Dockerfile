# Pull base image
#FROM resin/rpi-raspbian:latest
FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y install apache2 mariadb-server
