#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILE_PATHES=( $( find "${DIRECTORY_PATH}" -type f ) )
readonly DIR_WITH_FILE_PATHES="${FILE_PATHES[@]%/*}"

(
  for dir_path in ${DIR_WITH_FILE_PATHES}; do
    echo "${dir_path}"
  done
) | uniq -u