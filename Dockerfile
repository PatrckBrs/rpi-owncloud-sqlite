# Dockerfile to Owncloud
FROM patrckbrs/rpi-nginx-php5-fpm

MAINTAINER Patrick Brs 

# Update sources && install packages
RUN DEBIAN_FRONTEND=noninteractive ;\
apt-get update && \
apt-get install --assume-yes \
  vim \
  locales \
  dialog \
  curl \
  libcurl3-dev \
  sqlite3 \
  bzip2 \
  wget \
  supervisor && \
  rm -rf /var/lib/apt/lists/* 
  
RUN locale-gen fr_FR fr_FR.UTF-8 && \ 
dpkg-reconfigure -f noninteractive locales

# Change upload-limits and -sizes
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
sed -i "s/post_max_size = 8M/post_max_size =root123  2048M/g" /etc/php5/fpm/php.ini && \
echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.in && \
echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure tzdata && sed -i 's/.debian./.fr./g' /etc/ntp.conf

COPY ./default /etc/nginx/sites-available/

# New version 9.0.4
RUN cd /var/www && wget http://download.owncloud.org/community/owncloud-9.0.4.tar.bz2 && tar jxvf owncloud-9.0.4.tar.bz2 && rm owncloud-9.0.4.tar.bz2 
RUN chown -R www-data:www-data /var/www/owncloud && ln -s /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud
RUN touch /var/www/owncloud/config/config.php && \
    sed -i '/^);/i\  '"'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," /var/www/owncloud/config/config.php

# Set the current working directory
WORKDIR /var/www/owncloud

# Ports 
EXPOSE 80 443

# Boot up Nginx, and PHP5-FPM when container is started
CMD ["/usr/bin/supervisord"]
