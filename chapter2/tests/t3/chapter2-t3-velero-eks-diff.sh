#!/bin/bash

get_namespaces_from_cluster() {
  curl https://gist.githubusercontent.com/dmitry-mightydevops/297c4e235b61982f21a0bbbf7319ac24/raw/0e57e62984b69ff16c9b9159776e145f6d4feecf/kubernetes-namespaces.txt
}

get_backup_file() {
  curl https://gist.githubusercontent.com/dmitry-mightydevops/016139747b6cefdc94160607f95ede74/raw/030a82af2489bc353cec370779cfd06852668e29/velero.yaml
}

get_namespaces_from_backup() {
  cat "$1"
}

get_backup_file > backupfile.yaml
get_namespaces_from_cluster > namespaces

# schedules.[].includedNamespaces