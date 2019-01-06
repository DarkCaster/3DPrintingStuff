#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

cd "$script_dir"
echo -n "" > "timestamps.txt"

while IFS= read -r file; do
  stat --printf="%y|" "$file" >> "timestamps.txt"
  echo "$file" >> "timestamps.txt"
done < <(find . -type f -not -name timestamps.txt -not -name save_timestamps.sh -not -name restore_timestamps.sh -not -name *.fcstd1 -not -name *.FCStd1 | sort)

echo "timestamps saved!"
