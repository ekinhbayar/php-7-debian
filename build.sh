#!/bin/bash
cd "$(dirname "$0")"

# DEPENDENCIES
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    pkg-config \
    git-core \
    autoconf \
    bison \
    libxml2-dev \
    libbz2-dev \
    libmcrypt-dev \
    libicu-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libltdl-dev \
    libjpeg-dev \
    libpng-dev \
    libpspell-dev \
    libreadline-dev \
    libpq-dev

sudo mkdir /usr/local/php7

# START PHP INSTALLATION
git clone https://github.com/php/php-src.git
cd php-src
git checkout PHP-7.0.7
git pull

./buildconf --force

CONFIGURE_STRING="--prefix=/usr/local/php7 \
                  --with-config-file-scan-dir=/usr/local/php7/etc/conf.d \
                  --without-pear \
                  --enable-bcmath \
                  --with-bz2 \
                  --enable-calendar \
                  --enable-intl \
                  --enable-exif \
                  --enable-dba \
                  --enable-ftp \
                  --with-gettext \
                  --with-gd \
                  --with-jpeg-dir \
                  --enable-mbstring \
                  --with-mcrypt \
                  --with-mhash \
                  --enable-mysqlnd \
                  --with-mysql=mysqlnd \
                  --with-mysql-sock=/var/run/mysqld/mysqld.sock \
                  --with-mysqli=mysqlnd \
                  --with-pdo-mysql=mysqlnd \
                  --with-openssl \
                  --enable-pcntl \
                  --with-pspell \
                  --enable-shmop \
                  --enable-soap \
                  --enable-sockets \
                  --enable-sysvmsg \
                  --enable-sysvsem \
                  --enable-sysvshm \
                  --enable-wddx \
                  --with-zlib \
                  --enable-zip \
                  --with-readline \
                  --with-curl \
                  --enable-fpm \
                  --with-fpm-user=www-data \
                  --with-fpm-group=www-data"

./configure $CONFIGURE_STRING

make
sudo make install
# PHP INSTALLED

# START POSTGRESQL (PDO)
# check first if you have it via:
# /usr/local/php7/bin/php -m | grep pgsql

cd ext/pdo_pgsql
./configure --with-pdo-pgsql=/usr/local --with-php-config=/usr/local/php7/bin/php-config
make
sudo make install

sudo echo "extension=pdo_pgsql.so" >> /usr/local/php7/lib/php.ini

cd ../pgsql
./configure --with-pgsql=/usr/local --with-php-config=/usr/local/php7/bin/php-config
make
sudo make install

sudo echo "extension=pgsql.so" >> /usr/local/php7/lib/php.ini

# /usr/local/php7/bin/php -m | grep pgsql should now print:
# $ pdo_pgsql
# $ pgsql
