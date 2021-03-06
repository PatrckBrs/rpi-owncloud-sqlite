# Dockerfile to Owncloud
FROM patrckbrs/nginx-php5-fpm-resin

ENV OWNCLOUD_VERSION=10.0.2

LABEL maintainer "Patrick Brunias <patrick@brunias.org>"

# Update sources && install packages
RUN DEBIAN_FRONTEND=noninteractive ;\
apt-get update && \
apt-get install --assume-yes \
  vim \
  locales \
  dialog \
  curl \
  libcurl3-dev \
  php5-sqlite \
  bzip2 \
  wget \
  supervisor && \
  rm -rf /var/lib/apt/lists/* 
  
RUN locale-gen fr_FR fr_FR.UTF-8 && \ 
dpkg-reconfigure -f noninteractive locales

# Change upload-limits and -sizes
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
sed -i "s/post_max_size = 8M/post_max_size = 2048M/g" /etc/php5/fpm/php.ini && \
echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.ini && \
echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure tzdata && sed -i 's/.debian./.fr./g' /etc/ntp.conf

COPY ./default /etc/nginx/sites-available/

# New version 9.1.3
RUN cd /var/www && wget https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 && tar jxvf owncloud-${OWNCLOUD_VERSION}.tar.bz2 && rm owncloud-${OWNCLOUD_VERSION}.tar.bz2 
RUN chown -R www-data:www-data /var/www/owncloud

# Set the current working directory
WORKDIR /var/www/owncloud

# Start container
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

# Test HEALTHCHECK
#HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1

# Ports 
EXPOSE 80 443

# Boot up Nginx, and PHP5-FPM when container is started
ENTRYPOINT ["docker-entrypoint.sh"]
