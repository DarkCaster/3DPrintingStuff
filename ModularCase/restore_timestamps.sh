#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

cd "$script_dir"

while IFS= read -r file; do
  if [[ $file =~ (.*)"|"("./".*) ]]; then
    filename="${BASH_REMATCH[2]}"
    ts="${BASH_REMATCH[1]}"
    if [[ -f $filename ]]; then
      touch -m --date="$ts" "$filename"
    else
      echo "file $filename is missing"
    fi
  else
    echo "failed to parse line $file"
  fi
done < "timestamps.txt"

echo "timestamps restored!"
