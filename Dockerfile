# Dockerfile to Owncloud
FROM patrckbrs/rpi-nginx-php5-fpm

# Update sources && install packages
RUN DEBIAN_FRONTEND=noninteractive ;\
apt-get update && \
apt-get install --assume-yes \
  vim \
  locales \
  dialog \
  php5 \
  php5-json \
  php5-gd \
  php5-sqlite \
  curl \
  libcurl3-dev \
  php5-curl \
  php5-common \
  php-xml-parser \
  sqlite3 \
  php-apc \
  wget
  
RUN locale-gen fr_FR fr_FR.UTF-8 && \ 
dpkg-reconfigure -f noninteractive locales && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change upload-limits and -sizes
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
sed -i "s/post_max_size = 8M/post_max_size =root123  2048M/g" /etc/php5/fpm/php.ini && \
echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.in && \
echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure tzdata && sed -i 's/.debian./.fr./g' /etc/ntp.conf

COPY ./owncloud.conf /etc/nginx/sites-available/ 
#RUN ln -sf /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud && ln -sf /usr/share/owncloud/index.php /var/www/html/index.php

RUN cd /var/www && wget http://download.owncloud.org/community/owncloud-9.0.2.tar.bz2 && tar jxvf owncloud-9.0.2.tar.bz2 
RUN chown -R www-data:www-data /var/www/owncloud && ln -s /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud

# Set the current working directory
WORKDIR /var/www/html

CMD service php5-fpm start && nginx
