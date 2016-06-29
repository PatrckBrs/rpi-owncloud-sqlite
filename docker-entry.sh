echo Starting Owncloud
ln -sv /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/owncloud

[[ -f /var/www/owncloud/config/config.php ]] && {
    grep -q APCu /var/www/owncloud/config/config.php ||
        sed -i '/^);/i\  '"'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," \
                    /var/www/owncloud/config/config.php
}

service php5-fpm start && nginx
