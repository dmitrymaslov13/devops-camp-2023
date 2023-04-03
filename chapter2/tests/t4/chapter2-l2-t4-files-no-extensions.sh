#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILES=( $( find "${DIRECTORY_PATH}" -type f ) )


get_file_name_without_extenstion() {
  local file_name="${1}" 
  local file_name_without_first_symbol="${file_name: 1 : ${#file_name} }"
  echo "${file_name: 0: 1}${file_name_without_first_symbol%.*}"
}

get_file_dir() {
  local file_path="${1}"
  echo "${file_path%/*}"
}

get_file_name() {
  local file_path="${1}"
  echo "${file_path##*/}"
}

get_file_name_path_without_extenstion() {
  local file_path="${1}"
  local file_dir=$( get_file_dir ${file_path} )
  local file_name=$( get_file_name ${file_path} )
  echo "${file_dir}/$( get_file_name_without_extenstion ${file_name} )"
}

for file_path in "${FILES[@]}"; do
  echo $( get_file_name_path_without_extenstion "${file_path}" )
done
