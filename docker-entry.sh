echo Starting Owncloud
ln -sv /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

[[ -f /var/www/owncloud/config/config.php ]] && {
    grep -q APCu /var/www/owncloud/config/config.php ||
        sed -i '/^);/i\  '"'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," \
                    /var/www/owncloud/config/config.php
}

service php5-fpm start && nginx
