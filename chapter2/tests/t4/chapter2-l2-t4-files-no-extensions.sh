#!/bin/bash
# This script outputs all files from a folder with a subscription argument without extension

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILE_PATHES=$(find "${DIRECTORY_PATH}" -type f)

###################################################
# Get file name without extension
# Globals:
#   None
# Arguments:
#   File name
# Outputs:
#   Writes file name without extenstion to stdout
###################################################
get_file_name_without_extenstion() {
  local file_name="${1}" 
  local file_name_without_first_symbol="${file_name: 1 : ${#file_name} }"
  echo "${file_name: 0: 1}${file_name_without_first_symbol%%.*}"
}

for file_path in $FILE_PATHES; do
  file_dir="${file_path%/*}"
  file_name="${file_path##*/}"
  echo "${file_dir}/$( get_file_name_without_extenstion "${file_name}" )"
done