#!/bin/bash

IFS=$'\n'
readonly DIRECTORY_PATH="$1"
readonly FILES=( $( find "${DIRECTORY_PATH}" -type f ) )

for file in "${FILES[@]}"; do
  echo "${file%.*}"
done
