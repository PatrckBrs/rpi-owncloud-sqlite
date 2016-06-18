# Dockerfile to Owncloud
# FROM dilgerm/rpi-app-base:jessie
FROM resin/rpi-raspbian:jessie

MAINTAINER John Sladerz

RUN apt-get -y update
RUN apt-get install -y locales dialog
RUN locale-gen fr_FR fr_FR.UTF-8
RUN dpkg-reconfigure -f noninteractive locales

RUN apt-get install -y nginx php5-fpm ntp \
owncloud vim
# php5-gd php-xml-parser \
# php5-intl php5-sqlite php5-mysql php5-curl \
# mariadb-server owncloud vim openssl ssl-cert \
# smbclient curl libcurl3 bzip2 wget vim sharutils owncloud

# Change upload-limits and -sizes
RUN sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
    sudo sed -i "s/post_max_size = 8M/post_max_size =root123  2048M/g" /etc/php5/fpm/php.ini && \
    sudo echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.in

# Change the docker default timezone from UTC to Paris
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure tzdata && sed -i 's/.debian./.fr./g' /etc/ntp.conf

# PHP-FPM listen Unix socket
RUN sed -i -e 's/listen \= 127.0.0.1\:9000/listen \= \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf

# ADD PHP-FPM Configuration
ADD ./php5-fpm.conf /etc/nginx/conf.d/php5-fpm.conf
# ADD index.php info
#ADD ./index.php /var/www/html/index.php
# ADD default nginx sites-available
ADD ./default /etc/nginx/sites-available/default

VOLUME ["/usr/share/nginx/www"]
VOLUME ["/etc/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
