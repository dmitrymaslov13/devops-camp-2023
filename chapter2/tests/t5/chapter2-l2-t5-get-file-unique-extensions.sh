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

  if [[ "${file_name}" != *.* ]]; then
    return 0
  fi

  if [[ "${file_name: 0 : 1}" != "." ]]; then
    echo "${file_name#*.}"
    return 1
  fi
  
  local dotfile_name_without_first_dot="${file_name: 1 }" 

  if [[ ${dotfile_name_without_first_dot} == *.* ]]; then
    echo "${dotfile_name_without_first_dot#*.}"
  fi
}

for file_path in ${FILE_PATHES}; do
  get_file_extenstion "${file_path##*/}"
done | sort -u
