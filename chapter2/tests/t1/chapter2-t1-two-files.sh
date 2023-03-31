#!/bin/bash

# Constants
readonly OUTPUT_FOLDER_PATH="./output"
readonly PATHS=("$@")

########################################
# Create file with random base64 string .
# Arguments:
#   Path to file.
# Returns:
#   None
########################################
function create_file {
  declare -r OUTPUT_FILE_PATH="./${OUTPUT_FOLDER_PATH}/$1"
  head -n 10 /dev/urandom | base64 > "${OUTPUT_FILE_PATH}"
  chmod 700 "${OUTPUT_FILE_PATH}"
}

########################################
# Get file name from path.
# Arguments:
#   Path to file.
# Outputs:
#   Writes filename to stdout
########################################
get_file_name() {
  declare -r FILE_PATH="$1"
  echo "${FILE_PATH}" | sed -e "s|.*\/||"
}

########################################
# Show file content.
# Arguments:
#   Path to file.
# Outputs:
#   Writes filename and file content to stdout
########################################
show_file_content() {
  declare -r FILE_PATH="$1"
  echo "${FILE_PATH}"
  echo "======================="
  cat "${FILE_PATH}"
}

mkdir -p ${OUTPUT_FOLDER_PATH}

for file_path in ${#PATHS[@]}; do
  get_file_name "${file_path}"
  if [[ -e ${file_path} ]]; then
    show_file_content "${file_path}"
  else
    create_file "$(getFileName "${file_path}")"
  fi
done
