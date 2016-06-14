# Dockerfile to Owncloud
FROM resin/rpi-raspbian:latest

MAINTAINER John Sladerz

RUN apt-get -y update
RUN apt-get install -y locales dialog
RUN locale-gen fr_FR fr_FR.UTF-8
RUN dpkg-reconfigure -f noninteractive locales

RUN apt-get install -y nginx php5-fpm mariadb-server

#php5 php5-gd php-xml-parser php5-intl php5-sqlite mysql-server-5.5 smbclient curl libcurl3 php5-mysql php5-curl bzip2 wget vim openssl ssl-cert sharutils owncloud

EXPOSE 80
EXPOSE 443
