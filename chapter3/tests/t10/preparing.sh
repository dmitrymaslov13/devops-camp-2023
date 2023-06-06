#!/bin/bash

mkdir -p ssl
cd ssl
mkcert camp-python.local
mkcert camp-php.local

cd -
mkdir -p logs
cd logs
touch camp-php-access.log camp-php-error_debug.log camp-php-error.log camp-python-access.log camp-python-error_debug.log camp-python-error.log
