#!/bin/bash
#
# The script shows all TCP connections in the port range 10000-10100.

readonly PORT_START=10000
readonly PORT_END=10100
readonly TIMEOUT=2

logged_connections=""
connections=""

get_header() {
  ss -ltp | head -n 0 
}

get_tcp_listening_connections_by_ports_range() {
  ss -ltn "( sport >= ${PORT_START} && sport <= ${PORT_END} )" --no-header
}

listen_connections_by_ports_range() {
  while true; do
    connections=$(get_tcp_listening_connections_by_ports_range)

    local new_connections=$( comm -13 <(echo "${logged_connections}" | sort) <(echo "${connections}" | sort))

    if [[ -n "${new_connections}" ]]; then
      echo "${new_connections}" 
    fi

    logged_connections=$( cat <(echo "${logged_connections}") <(echo "${new_connections}")) 
  done
}

listen_connections_by_ports_range

while [[ -z $connections ]]; do
  echo "No TCP listening sockets found bound to ports in ${PORT_START}-${PORT_END} range"
  sleep "$TIMEOUT"
done
