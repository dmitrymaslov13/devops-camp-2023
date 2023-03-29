#!/bin/bash

output=output
mkdir -p ${output}

# Create file with base64 string with 700 permission
# arg1 path
function createFile {
  local out=./${output}/$1
  head -n 10 /dev/urandom | base64 > ${out}
  chmod 700 ${out}
}

# Get file name from path
# arg1 path
function getFileName {
  echo "$1"| sed "s|.*\/||"
}

# Show file content
# arg1 path to file
function showFile {
  echo $1
  echo ===
  cat $1
}

for i in $*; do
  if [[ -e $i ]] 
  then
    showFile $i
  else
    createFile $(getFileName $i)
  fi
done