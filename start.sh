#!/bin/bash

if [ -f "/var/www/owncloud/config/config.php" ]
then
  sed -i '/^);/i\  '"'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," /var/www/owncloud/config/config.php
fi
