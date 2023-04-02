#!/bin/bash

readonly DIRECTORY_PATH="$1"
readonly FILES=( $( find "${DIRECTORY_PATH}" -type f ) )

echo "${FILES[@]%.*}" | tr " " "\n" 
