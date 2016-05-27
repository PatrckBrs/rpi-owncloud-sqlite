# Pull base image
#FROM resin/rpi-raspbian:latest
FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y install apache2 mariadb-server libapache2-mod-php5
RUN apt-get -y install php5-gd php5-json php5-mysql php5-curl
RUN apt-get -y install php5-intl php5-mcrypt php5-imagick
