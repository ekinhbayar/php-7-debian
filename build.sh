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
    libpq-dev \
    libxslt1-dev

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
                  --with-gettext \
                  --with-gd \
                  --with-jpeg-dir=/usr \
                  --with-png-dir=/usr \
                  --with-mcrypt \
                  --with-mhash \
                  --enable-calendar \
                  --enable-intl \
                  --enable-exif \
                  --enable-zip \
                  --enable-dba \
                  --enable-ftp \
                  --enable-mbstring \
                  --enable-mysqlnd \
                  --with-mysql=mysqlnd \
                  --with-mysql-sock=/var/run/mysqld/mysqld.sock \
                  --with-mysqli=mysqlnd \
                  --with-pdo-mysql=mysqlnd \
                  --with-kerberos \
                  --with-openssl \
                  --enable-pcntl \
                  --enable-shmop \
                  --enable-soap \
                  --enable-sockets \
                  --enable-sysvmsg \
                  --enable-sysvsem \
                  --enable-sysvshm \
                  --enable-wddx \
                  --enable-xmlreader \
                  --enable-json \
                  --enable-phar \
                  --enable-dom \
                  --with-xsl \
                  --with-pspell \
                  --with-zlib \
                  --with-zlib-dir=/usr \
                  --with-readline \
                  --with-curl \
                  --enable-fpm \
                  --with-fpm-user=www-data \
                  --with-fpm-group=www-data \
                  --enable-debug \
                  --enable-maintainer-zts \
                  --enable-pthreads"

./configure $CONFIGURE_STRING

make
sudo make install
