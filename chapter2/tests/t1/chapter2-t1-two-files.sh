output=output
mkdir -p ${output}

# Create file with base64 string with 700 permission
# arg1 path
function createFile {
  local out=./${output}/$1
  echo $RANDOM | base64 > ${out}
  chmod 700 ${out}
}

# Get file name from path
# arg1 path
function getFileName {
  echo "$1"| sed "s|.*\/||"
}

# Show file content
function showFile {
  echo ===
  echo $1
}

for i in $*; do
  if [[ -e $1 ]] 
  then
    showFile $1
  else
    createFile $(getFileName $1)
  fi
done