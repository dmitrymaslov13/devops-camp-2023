#!/bin/bash

readonly NUMBER_OF_ARGUMENTS=2

if [[ "$#" -ne ${NUMBER_OF_ARGUMENTS} ]]; then
  echo "This script requires two arguments"
  exit 1
fi

# Constants
readonly OUTPUT_FOLDER_PATH="./"
readonly PATHS="$*"

########################################
# Create file with random base64 string in output foled path
# Globals:
#   OUTPUT_FOLDER_PATH
# Arguments:
#   File name.
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
  echo "EOF"
  echo ""
}

mkdir -p ${OUTPUT_FOLDER_PATH}

for path in ${PATHS}; do
  if [[ -d ${path} ]]; then
    echo "${path} - it's a directory"
    continue 
  fi

  if [[ -f ${path} ]]; then
    show_file_content "${path}"
  else
    create_file $(get_file_name "${path}")
  fi
done
