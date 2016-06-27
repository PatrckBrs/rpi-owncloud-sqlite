# Dockerfile to Owncloud
FROM patrckbrs/rpi-nginx-php5-fpm

# Update sources && install packages
RUN DEBIAN_FRONTEND=noninteractive ;\
apt-get update && \
apt-get install --assume-yes \
  vim \
  locales \
  dialog \
  owncloud \
  sqlite3

RUN locale-gen fr_FR fr_FR.UTF-8 && \ 
dpkg-reconfigure -f noninteractive locales && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change upload-limits and -sizes
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
sed -i "s/post_max_size = 8M/post_max_size =root123  2048M/g" /etc/php5/fpm/php.ini && \
echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.in && \
sed -i -e 's/listen \= 127.0.0.1\:9000/listen \= \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf && \
echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure tzdata && sed -i 's/.debian./.fr./g' /etc/ntp.conf

COPY owncloud.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud

RUN chmod 0770 /usr/share/owncloud/data && chmod 0770 /usr/share/owncloud/private/ && \
chown -R www-data:www-data /usr/share/owncloud

# Set the current working directory
WORKDIR /var/www/html

CMD service php5-fpm start && nginx
