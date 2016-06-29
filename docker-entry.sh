echo Starting Owncloud
ln -sv /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud

service php5-fpm start && nginx
