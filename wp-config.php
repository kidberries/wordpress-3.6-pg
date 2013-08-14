<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wp36');

/** MySQL database username */
define('DB_USER', 'wordpress');

/** MySQL database password */
define('DB_PASSWORD', 'wp36');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

define('DB_SEARCH_PATH', 'casts,mysql,fn,public,pg_catalog');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '[eu;YYmQAp=RA ioH4^+(-]235F4NkI|A#~ :v-B%+Vj%PEV.kWoFQ{Qe|E:m!Q3');
define('SECURE_AUTH_KEY',  'zjI,f)GRz&S-y{tf4sSk{|J{f*Bo ldb%?%q_D?5c1jDCR%T|$fCs5O-9`.$Jaz8');
define('LOGGED_IN_KEY',    'o+~=ipE;g@k-/|<H8u^iDv199|ONVLzF@}e}{{+FF@4mx6~5N|dqxGL9[hd_pfis');
define('NONCE_KEY',        'xarWygw,Ucd]4&{;hozSS+)RFjDwfdqt@hSdy2l`)+})0rhW%qW=+H7BIso|zjLR');
define('AUTH_SALT',        't>E`u@E|15]2KTg{2u%T2uF/PL4bccG+-tVr]DB%09P!(N5D5VJ,~,W^!iJ-1?sh');
define('SECURE_AUTH_SALT', ';+q?76Qj)Vj1|+/bKV~-@^<h%f|vPR[v||i$**s|bu6)hE$-U+8]0Q.}sV-M58C6');
define('LOGGED_IN_SALT',   '-BB+nb{*f|N@h8 (X#6Q|{dNZ*_js~XTBI_ecyh  (AJ#&f;)msmd@<JJ(Mc)oq%');
define('NONCE_SALT',       'yA5g,};mh:f@@ZDEXKrT)8K2{A&eVke-Y^*b;q:91DXzU#nz/B^V+Szg5uzZmY_r');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', 'ru_RU');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
