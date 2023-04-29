#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILE_PATHES=$( find "${DIRECTORY_PATH}" -type f )

for file_path in ${FILE_PATHES}; do
  echo "${file_path##*/}"
done | sort -u
