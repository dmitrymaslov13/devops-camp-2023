#!/bin/bash

readonly BACKUP_MANIFEST_URL='https://gist.githubusercontent.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/030a82af2489bc353cec370779cfd06852668e29/velero.yaml'
readonly KUBE_NAMESPACES='https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/0e57e62984b69ff16c9b9159776e145f6d4feecf/kubernetes-namespaces.txt'

#########################################
# Get backup manifest 
# Globals:
#   BACKUP_MANIFEST_URL
# Outputs:
#   Backup manifest
#########################################
get_backup_manifest() {
  curl --silent "${BACKUP_MANIFEST_URL}"
}

#########################################
# Get backup manifest 
# Arguments:
#   Backup mainfest
# Outputs:
#   Included namespaces
#########################################
get_included_namespaces_from_backup() {
  local backup="${1}"
  echo "${backup}"| yq ".spec.source.helm.values" -r | yq '.schedules[].template.includedNamespaces[]' -r
}

#########################################
# Get kubernetes namespaces
# Globals:
#   KUBE_NAMESPACES 
# Outputs:
#   Kubernetes namespaces
#########################################
get_kube_namespaces() {
  curl --silent "${KUBE_NAMESPACES}"
}

namespaces_from_backup=$( get_included_namespaces_from_backup "$( get_backup_manifest )" )
kube_namespaces=$( get_kube_namespaces )

(
  echo "${namespaces_from_backup}"
  echo "${kube_namespaces}"
) | sort -u | tr " " "\n"
