# Install PHP 7 on Debian

These are a set of bash scripts for building and running PHP 7 (CLI and FPM) on Debian based Linux distributions:

- `build.sh` :
    1. Installs the necessary build dependencies and the latest development version of PHP with CLI and FPM server APIs (SAPI) from the latest PHP 7 branch of https://github.com/php/php-src
 
- `install.sh` :
    1. Sets up PHP-FPM by moving configuration files into their correct locations in `/usr/local/php7` 
    2. Enables the `php7-fpm` service, adds it to the startup sequence 
    3. Installs `/ext/pdo_pgsql`, `/ext/pgsql`, `pthreads`, `apcu`

--

#### Note: 

Please note that these are very simple scripts that don't implement error checking or process validation.

The configure string in `build.sh` is different than the file on original repo that is located [here](https://github.com/kasparsd/php-7-debian/blob/master/build.sh). It is up to your requirements to add/remove PHP modules therefore you should review (and edit if needed) the configure string accordingly. In case you do not want to install any of `/ext/pdo_pgsql`, `/ext/pgsql`, `pthreads`, `apcu` visit `install.sh` and comment out related parts or check out the original [repo](https://github.com/kasparsd/php-7-debian).

--

## Usage

	$ git clone https://github.com/ekinhbayar/php-7-debian.git
	$ cd php-7-debian
	$ ./build.sh
	$ sudo ./install.sh

The PHP-FPM can be operated using the `php7-fpm` init script:

	Usage: /etc/init.d/php7-fpm {start|stop|status|restart|reload|force-reload}

while the FPM socket is available at

	127.0.0.1:9007

and PHP CLI:
	
	$ /usr/local/php7/bin/php -v
	PHP 7.0.7 (cli) (built: May 29 2016 04:53:21) ( ZTS DEBUG )
	Copyright (c) 1997-2016 The PHP Group
	Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies
    	    with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2016, by Zend Technologies

## Configuration files

All PHP configuration files are stored under `/usr/local/php7`:
	
	/usr/local/php7/lib/php.ini
	/usr/local/php7/etc/php-fpm.conf
	/usr/local/php7/etc/php-fpm.d/www.conf
	/usr/local/php7/etc/conf.d/modules.ini

while the Debian init script is added to:

	/etc/init.d/php7-fpm

## Extensions

Note that most of the third-party PHP extensions are [not yet compatible with PHP 7](https://github.com/gophp7/gophp7-ext/wiki/extensions-catalog) and [GoPHP7-ext](http://gophp7.org/) (also on [GitHub](https://github.com/gophp7/gophp7-ext)) is a project to help do that. 

Here is a list of PHP modules that are enabled by default in this (fork) build:

	$ /usr/local/php7/bin/php -m
	[PHP Modules]
	apcu
	bcmath
	bz2
	calendar
	Core
	ctype
	curl
	date
	dba
	dom
	exif
	fileinfo
	filter
	ftp
	gd
	gettext
	hash
	iconv
	intl
	json
	libxml
	mbstring
	mcrypt
	mysqli
	mysqlnd
	openssl
	pcntl
	pcre
	PDO
	pdo_mysql
	pdo_pgsql
	pdo_sqlite
	pgsql
	Phar
	posix
	pspell
	pthreads
	readline
	Reflection
	session
	shmop
	SimpleXML
	soap
	sockets
	SPL
	sqlite3
	standard
	sysvmsg
	sysvsem
	sysvshm
	tokenizer
	wddx
	xml
	xmlreader
	xmlwriter
	xsl
	Zend OPcache
	zip
	zlib

	[Zend Modules]
	Zend OPcache

## Installing Memcached Extension

[Memcached extension for PHP](https://github.com/php-memcached-dev/php-memcached) already supports PHP 7. First you install the dependencies:

	$ sudo apt-get install libmemcached-dev libmemcached11
	
and then build and install the extension:

	$ git clone https://github.com/php-memcached-dev/php-memcached
	$ cd php-memcached
	$ git checkout -b php7 origin/php7

	$ /usr/local/php7/bin/phpize
	$ ./configure --with-php-config=/usr/local/php7/bin/php-config
	$ make
	$ sudo make install

and then append `extension=memcached.so` to `/usr/local/php7/etc/conf.d/modules.ini`:

	# Zend OPcache
	zend_extension=opcache.so
	
	# Memcached
	extension=memcached.so


## Credits

- Original [repo](https://github.com/kasparsd/php-7-debian) created by [Kaspars Dambis](http://kaspars.net)
- Based on [`php7.sh`](https://gist.github.com/tvlooy/953a7c0658e70b573ab4) by [Tom Van Looy](http://www.intracto.com/nl/blog/running-symfony2-on-php7) 
