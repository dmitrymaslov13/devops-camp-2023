#!/bin/bash

mkdir -p ssl
cd ssl
mkcert camp-python.local localhost 127.0.0.1 ::1
mkcert camp-php.local localhost 127.0.0.1 ::1

cd -
mkdir -p logs
cd logs
touch camp-php-access.log camp-php-error_debug.log camp-php-error.log camp-python-access.log camp-python-error_debug.log camp-python-error.log
