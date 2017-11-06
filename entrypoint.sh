#!/usr/bin/env sh

if [ ! $(ls /etc/nginx) ]; then
	echo "Initializing nginx directory..."
	rsync -r /tmp/nginx/* /etc/nginx
	echo "Done."
fi

if [ ! -d /run/nginx ]; then
	mkdir /run/nginx
fi

if [ ! -d /var/www/html ]; then
	mkdir /var/www/html
fi


php-fpm -D
nginx