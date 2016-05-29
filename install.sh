#!/bin/bash
BASEDIR=$(dirname "$0")
cd $BASEDIR

# Create a dir for storing PHP module conf
mkdir /usr/local/php7/etc/conf.d

# Symlink php-fpm to php7-fpm
ln -s /usr/local/php7/sbin/php-fpm /usr/local/php7/sbin/php7-fpm

# Add config files
cp php-src/php.ini-production /usr/local/php7/lib/php.ini
cp conf/www.conf /usr/local/php7/etc/php-fpm.d/www.conf
cp conf/php-fpm.conf /usr/local/php7/etc/php-fpm.conf
cp conf/modules.ini /usr/local/php7/etc/conf.d/modules.ini

# Add the init script
cp conf/php7-fpm.init /etc/init.d/php7-fpm
chmod +x /etc/init.d/php7-fpm
update-rc.d php7-fpm defaults

### INSTALL POSTGRESQL (PDO)
# you can check if you have it already via:
# /usr/local/php7/bin/php -m | grep pgsql

cd php-src/ext/pdo_pgsql
/usr/local/php7/bin/phpize
./configure --with-pdo-pgsql=/usr/local --with-php-config=/usr/local/php7/bin/php-config
make
sudo make install

sudo echo "extension=pdo_pgsql.so" >> /usr/local/php7/lib/php.ini

cd ../pgsql
/usr/local/php7/bin/phpize
./configure --with-pgsql=/usr/local --with-php-config=/usr/local/php7/bin/php-config
make
sudo make install

sudo echo "extension=pgsql.so" >> /usr/local/php7/lib/php.ini

# /usr/local/php7/bin/php -m | grep pgsql should now print:
# $ pdo_pgsql
# $ pgsql

cd ../

### INSTALL PTHREADS

PTHREADS_VERSION=3.1.6

wget https://pecl.php.net/get/pthreads-$PTHREADS_VERSION.tgz
tar xzf pthreads-$PTHREADS_VERSION.tgz
cd pthreads-$PTHREADS_VERSION
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make
sudo make install
cd $BASEDIR/../
rm -rf pthreads-$PTHREADS_VERSION/

### INSTALL APCu

APCU_VERSION=5.1.3

wget https://pecl.php.net/get/apcu-$APCU_VERSION.tgz
tar xzf apcu-$APCU_VERSION.tgz
cd apcu-$APCU_VERSION
/usr/local/php7/bin/phpize
./configure --with-php-config=/usr/local/php7/bin/php-config
make
sudo make install
cd $BASEDIR/../
rm -rf apcu-$APCU_VERSION/

rm -rf install
rm -rf package.xml

# Create symlink to php7
ln -s /usr/local/php7/bin/php /usr/local/bin/php7
chmod +x /usr/local/bin/php7

service php7-fpm start
