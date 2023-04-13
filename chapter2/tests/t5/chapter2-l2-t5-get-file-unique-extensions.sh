#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILE_PATHES=$(find "${DIRECTORY_PATH}" -type f)

###################################################
# Get file name without extenstion
# Globals:
#   None
# Arguments:
#   File name
# Outputs:
#   Writes file name without extenstion to stdout
###################################################
get_file_extenstion() {
  local file_name="${1}"
  local file_without_first_symbol="${file_name: 1 }" 
  echo "${file_without_first_symbol#*.}"
}

for file_path in ${FILE_PATHES}; do
  get_file_extenstion "${file_path##*/}"
done | sort -u
