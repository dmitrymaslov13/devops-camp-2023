#!/bin/bash
set -eou pipefail

echo "Generate SSL..."
mkdir -p .ssl
cd .ssl
mkcert camp-python.local
cd -

echo "Install python requirments..."
pip install -r requirements.txt

echo "Run server"
uwsgi --ini app.ini & 
sudo nginx -p . -c ./nginx.conf
