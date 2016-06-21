# Dockerfile to Owncloud
FROM resin/rpi-raspbian:jessie
MAINTAINER John Sladerz

USER root

# Update sources && install packages
RUN DEBIAN_FRONTEND=noninteractive ;\
apt-get update && \
apt-get install --assume-yes \
bzip2 \
cron \
nginx \
openssl \
php-apc \
php5 \
php5-apcu \
php5-cli \
php5-curl \
php5-fpm \
php5-gd \
php5-gmp \
php5-imagick \
php5-intl \
php5-ldap \
php5-mcrypt \
php5-mysqlnd \
php5-pgsql \
php5-sqlite \
smbclient \
sudo \
wget \
ntp \
vim \
owncloud \
sqlite3 \
curl \
libcurl3 \
libcurl3-dev \
php5-common \
php-xml-parser
        
# Update Locales
RUN apt-get install -y locales dialog && \
locale-gen fr_FR fr_FR.UTF-8 && \ 
dpkg-reconfigure -f noninteractive locales

# Change upload-limits and -sizes
RUN sudo sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
   sudo sed -i "s/post_max_size = 8M/post_max_size =root123  2048M/g" /etc/php5/fpm/php.ini && \
   sudo echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.in

# Change the docker default timezone from UTC to Paris
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure tzdata && sed -i 's/.debian./.fr./g' /etc/ntp.conf

# PHP-FPM listen Unix socket
RUN sed -i -e 's/listen \= 127.0.0.1\:9000/listen \= \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf

# Modification rights
chown -R www-data:www-data /usr/share/owncloud/

# ADD PHP-FPM Configuration
ADD ./php5-fpm.conf /etc/nginx/conf.d/php5-fpm.conf

# ADD index.php info
# ADD ./index.php /var/www/html/index.php
RUN ln -s /usr/share/owncloud/index.php /var/www/html/index.php

# COPY default nginx sites-available
COPY ./default /etc/nginx/sites-available/default

# COPY nginx.conf 
COPY nginx/config/nginx.conf /etc/nginx/nginx.conf

# Turn off daemon mode
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Volume
VOLUME ["/etc/nginx", "/etc/nginx/conf.d", "/var/www/html"]
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
RUN sed -i "s/date.timezone \= Europe\/Berlin/date.timezone \= Europe\/Paris/" /etc/php5/fpm/php.ini

# Clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the current working directory
WORKDIR /var/www/html

# Ports 
EXPOSE 80
EXPOSE 443

# Boot up Nginx, and PHP5-FPM when container is started
CMD service php5-fpm start && nginx
