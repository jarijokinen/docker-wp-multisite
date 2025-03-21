#!/bin/bash

set -e

if [[ ! -f /wp/wp-config.php ]]; then
  cp -r /wordpress/* /wp/
  
  export SALTS=$(wget -q https://api.wordpress.org/secret-key/1.1/salt/ -O -)

  perl -i -pe '
    s/%WORDPRESS_DOMAIN%/$ENV{"WORDPRESS_DOMAIN"}/g;
    s/%WORDPRESS_ENV%/$ENV{"WORDPRESS_ENV"}/g;
    s/%WORDPRESS_DB_NAME%/$ENV{"WORDPRESS_DB_NAME"}/g;
    s/%WORDPRESS_DB_USER%/$ENV{"WORDPRESS_DB_USER"}/g;
    s/%WORDPRESS_DB_PASSWORD%/$ENV{"WORDPRESS_DB_PASSWORD"}/g;
    s/%WORDPRESS_DB_HOST%/$ENV{"WORDPRESS_DB_HOST"}/g;
    s/%WORDPRESS_SALTS%/$ENV{"SALTS"}/g;
  ' /wp/wp-config.php
fi

if [[ ! -d /wp/wp-content/uploads && -d /wp-uploads ]]; then
  ln -s /wp-uploads /wp/wp-content/uploads
fi

mkdir -p /wp/wp-content/themes/blank
echo '/** Theme Name: Blank */' > /wp/wp-content/themes/blank/style.css
touch /wp/wp-content/themes/blank/index.php

rm -rf /wp/wp-content/themes/twenty*
rm -rf /wp/wp-content/plugins/akismet
rm -rf /wp/wp-content/plugins/hello.php

chown -R wp:wp /wp

service php8.2-fpm start
service nginx start

[[ $DISABLE_FOREGROUND == 1 ]] || tail -f /dev/null

exit 0
