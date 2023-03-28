function createFile {
  echo $RANDOM | base64 > $1
  chmod 700 $1
}

function showFile {
  echo $1
  echo ===
  cat $1
}

for i in $*; do
  if [[ -e $1 ]] 
  then
    showFile $1
  else
    createFile $1
  fi
done