#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILE_PATHES=( $( find "${DIRECTORY_PATH}" -type f ) )
readonly FILE_NAMES="${FILE_PATHES[*]##*/}"

(
  for file_name in ${FILE_NAMES}; do
    echo "${file_name}"
  done
) | sort -u
