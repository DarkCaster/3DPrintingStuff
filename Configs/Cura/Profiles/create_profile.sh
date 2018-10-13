#!/bin/bash

curdir="$( cd "$( dirname "$0" )" && pwd )"

log () {
 echo "[ $@ ]"
}

error() {
 local source="$1"
 local line="$2"
 local ec="$3"
 echo "*** command at $source:$line failed with error code $ec"
 [[ ! -z $temp_dir ]] && echo "cleaning up temporary directory at $temp_dir" && rm -rf "$temp_dir"
 exit $ec
}

trap 'error ${BASH_SOURCE} ${LINENO} $?' ERR

if [[ ! -z $MSYSTEM ]]; then
 log "running on msys"
 compress ()
 {
  local base="$1"
  local source="$2"
  local target="$3"
  1>/dev/null pushd "$base"
  "$curdir/zip_util.bat" "$source" "$target"
  1>/dev/null popd
  return 0
 }
else
 compress ()
 {
  log "TODO"
  return 1
 }
fi

folder_name="$1"
[[ -z $folder_name ]] && echo "usage: create_profile.sh <extracted cura profile directory name>" && exit 1
profile_file="$folder_name.curaprofile"

temp_dir=`mktemp -d`
log "using temp_directory: $temp_dir"

#compress files
log "copying files"
mkdir "$temp_dir/profile"
cp "$folder_name"/* "$temp_dir/profile"

log "creating archive"
compress "$temp_dir" "profile" "profile.zip"

log "creating cura profile file: $profile_file"
mv "$temp_dir/profile.zip" "$profile_file"

log "cleaning up"
rm -rf "$temp_dir"

exit 0
