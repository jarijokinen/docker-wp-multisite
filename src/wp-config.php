<?php

if ('%WORDPRESS_ENV%' === 'development') {
  define('WP_DEBUG', true);
}
else {
  define('WP_DEBUG', false);
  $_SERVER['HTTPS'] = 'on';
}

define('WP_DEFAULT_THEME', 'blank');

define('WP_ALLOW_MULTISITE',  true);
define('MULTISITE',           true);
define('SUBDOMAIN_INSTALL',   true);
define('DOMAIN_CURRENT_SITE', '%WORDPRESS_DOMAIN%');
define('PATH_CURRENT_SITE',   '/');
define('SITE_ID_CURRENT_SITE', 1);
define('BLOG_ID_CURRENT_SITE', 1);

define('DB_NAME',     '%WORDPRESS_DB_NAME%');
define('DB_USER',     '%WORDPRESS_DB_USER%');
define('DB_PASSWORD', '%WORDPRESS_DB_PASSWORD%');
define('DB_HOST',     '%WORDPRESS_DB_HOST%');
define('DB_CHARSET',  'utf8');
define('DB_COLLATE',  '');

%WORDPRESS_SALTS%

$table_prefix = 'wp_';

if (!defined('ABSPATH')) {
  define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';

?>
