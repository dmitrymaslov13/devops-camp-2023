#!/bin/bash
set -eou pipefail

TEMP_PATH="/tmp/nginx/t11"

if [[ ! -e "$(pwd)/.ssl" ]]; then
  echo "Generate SSL..."
  mkdir -p .ssl
  cd .ssl
  mkcert camp-php.local
  cd -
fi

sudo rm -rf "${TEMP_PATH}"

sudo mkdir "${TEMP_PATH}"
sudo cp -r src "${TEMP_PATH}/src"
sudo chown nginx:nginx -R "${TEMP_PATH}"

sudo mkdir -p /var/run/php-fpm
sudo php-fpm --php-ini "$(pwd)/php.ini" -y "$(pwd)/php-fpm.conf" --nodaemonize &
sudo nginx -p "$(pwd)" -c "$(pwd)/nginx.conf"
