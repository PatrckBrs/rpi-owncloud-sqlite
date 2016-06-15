# Dockerfile to Owncloud
FROM resin/rpi-raspbian:latest

MAINTAINER John Sladerz

RUN apt-get -y update
RUN apt-get install -y locales dialog
RUN locale-gen fr_FR fr_FR.UTF-8
RUN dpkg-reconfigure -f noninteractive locales

RUN apt-get install -y nginx php5-fpm php5-gd php-xml-parser \
    php5-intl php5-sqlite php5-mysql php5-curl \
    mariadb-server owncloud vim openssl ssl-cert \
    smbclient curl libcurl3 bzip2 wget vim sharutils owncloud

EXPOSE 80
EXPOSE 443
