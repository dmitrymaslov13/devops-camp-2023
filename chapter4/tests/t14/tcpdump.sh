#!/bin/bash
set -eou pipefail

readonly CONTAINER_NAME="t14-nginx"

docker run -d --rm -p 8080:80 --name "${CONTAINER_NAME}" nginx
docker run \
  --rm -it \
  --cap-drop="ALL" \
  --cap-add="NET_ADMIN" --cap-add="NET_RAW" \
  --network container:"${CONTAINER_NAME}" \
  nixery.dev/tcpdump tcpdump -i eth0 -A -nn port 80
