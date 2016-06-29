echo Starting Owncloud
ln -sv /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud
#sed -i '/true,/a\  '"'memcache.local' => '\OC\Memcache\APC',"'' ./owncloud/config/config.php
service php5-fpm start && nginx
