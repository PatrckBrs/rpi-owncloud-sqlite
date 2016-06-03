# Pull base image
FROM resin/rpi-raspbian:latest
#FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y install nginx ssl-cert wget git curl

CMD wget http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_8.0/Release.key
CMD apt-key add - < Release.key
CMD echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_8.0/ /' >> /etc/apt/sources.list.d/owncloud.list

RUN apt-get -y update
