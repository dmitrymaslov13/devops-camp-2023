#!/bin/bash

set -eou pipefail

readonly BACKUP_MANIFEST_URL='https://gist.githubusercontent.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/030a82af2489bc353cec370779cfd06852668e29/velero.yaml'
readonly KUBE_NAMESPACES_URL='https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/0e57e62984b69ff16c9b9159776e145f6d4feecf/kubernetes-namespaces.txt'


#########################################
# Get backup manifest 
# Arguments:
#   Backup mainfest
# Outputs:
#   Included namespaces
#########################################
get_included_namespaces_from_backup() {
  local -r backup="${1}"
  echo "${backup}" | yq ".spec.source.helm.values" -r | yq ".schedules[].template.includedNamespaces[]" -r
}

###############################################
# Fetch data.
# Arguments:
#  URL 
# Outputs:
#   Fetch result or or terminates the script 
###############################################
fetch_data() {
  local -r url="$1"
  local response_status
  response_status=$(curl -I --silent "${url}" | head -n 1 | cut -d' ' -f2)

  if [[ "${response_status}" != 200 ]]; then
    echo "Fetch error. Url with problem: ${url}. Status code:${response_status}" >&2;
    exit 1;
  fi

  curl --silent "${url}"
}

backup_manifest=$(fetch_data "${BACKUP_MANIFEST_URL}")
namespaces_from_backup=$(get_included_namespaces_from_backup "${backup_manifest}")

kube_namespaces=$(fetch_data "${KUBE_NAMESPACES_URL}")

comm -13 <(echo "${namespaces_from_backup}" | sort -u) <(echo "${kube_namespaces}" | sort -u) 
