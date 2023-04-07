#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILES=( $( find "${DIRECTORY_PATH}" -type f ) )

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
  echo "${file_name: 0: 1}${file_name_without_first_symbol%.*}"
}

##################################
# Get path to file dir
# Globals:
#   None
# Arguments:
#   Path to file 
# Outputs:
#   Writes path to file to stdout
##################################
get_path_to_file_dir() {
  local file_path="${1}"
  echo "${file_path%/*}"
}

####################################
# Get file name
# Globals:
#   None
# Arguments:
#   Path to file 
# Outputs:
#   Writes file name to stdout
####################################
get_file_name() {
  local file_path="${1}"
  echo "${file_path##*/}"
}

####################################################
# Get path to file without extenstion 
# Globals:
#   None
# Arguments:
#   Path to file 
# Outputs:
#   Writes path to file without extenstion to stdout
####################################################
get_path_to_file_without_extenstion() {
  local file_path="${1}"
  local file_dir="$( get_path_to_file_dir "${file_path}" )"
  local file_name="$( get_file_name "${file_path}" )"
  echo "${file_dir}/$( get_file_name_without_extenstion "${file_name}" )"
}

for file_path in "${FILES[@]}"; do
  get_path_to_file_without_extenstion "${file_path}"
done
