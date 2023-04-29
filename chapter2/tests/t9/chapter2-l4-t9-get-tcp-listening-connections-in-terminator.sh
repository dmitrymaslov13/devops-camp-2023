#!/bin/bash

# Script listen tcp listening connections and if tcp connection exits then
# send to all zshs with adress and port

readonly PORT_START=10000
readonly PORT_END=10100
readonly HEADER="Local Address:Port   Peer Address:Port"

# Get active zsh pids
# Output:
#   Active zsh PIDs
get_active_zsh_pids() {
	ps -fC zsh --no-headers | awk '{print $2}'
}

# Send message to zshs stdout
# Args:
#   arg1 - Message for sending
#   arg2 - zsh pids separated by "\n"
send_message_to_zshs() {
  local message=${1}
  local zsh_pids=${2} 

  for pid in $zsh_pids; do
    local stdout_path="/proc/$pid/fd/1"
    echo "${message}" >> "${stdout_path}"
  done
}

# Get active tcp listening connections
# Global:
#    PORT_START
#    PORT_END
# Output:
#    Active tcp listening connections 
get_active_tcp_listening_connections() {
  ss -ltn "( sport >= ${PORT_START} && sport <= ${PORT_END} )" --no-header | awk '{ printf "%-20s %-20s\n", $4, $5 }'
}

registered_zsh_pids=""
registered_active_connections=""

while true; do
  active_zsh_pids=$(get_active_zsh_pids)
  new_zsh_pids=$(comm -13 <(echo "${registered_zsh_pids}" | sort) <(echo "${active_zsh_pids}" | sort))
  
  active_connections=$(get_active_tcp_listening_connections)
  new_connections=$(comm -13 <(echo "${registered_active_connections}" | sort) <(echo "${active_connections}" | sort))
  registered_active_connections="${active_connections}"

  if [[ -n "${new_connections}" ]]; then
    send_message_to_zshs "${HEADER}" "${registered_zsh_pids}"
    send_message_to_zshs "${new_connections}" "${registered_zsh_pids}"
  fi

  if [[ -n "${new_zsh_pids}"  ]] && [[ -n "${registered_active_connections}" ]] ; then
    send_message_to_zshs "" "${new_zsh_pids}"
    send_message_to_zshs "${HEADER}" "${new_zsh_pids}"
    send_message_to_zshs "${registered_active_connections}" "${new_zsh_pids}"
  fi

  registered_zsh_pids="${active_zsh_pids}"
done &
