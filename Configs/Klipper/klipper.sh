#!/bin/bash
#

# test script for initializing and running klipper right from repo directory
# following packages needs to be installed: virtualenv python-dev libffi-dev build-essential

set -e

curdir="$( cd "$( dirname "$0" )" && pwd )"

klipper_src_dir="$1"
[[ -z $klipper_src_dir || ! -d $klipper_src_dir ]] && echo "Klipper directory is missing!" && exit 1
klipper_src_dir="$klipper_src_dir/klippy"
[[ ! -d $klipper_src_dir ]] && echo "Klipper directory is invalid!" && exit 1

config_file="$2"
[[ -z $config_file || ! -f $config_file ]] && echo "Klipper config file is missing" && exit 1

config_file=$(realpath "$config_file")
[[ ! -f $config_file ]] && echo "Klipper config file is missing (after realpath)" && exit 1

action="$3"
[[ $action != "install" && $action != "run" ]] && echo "Action must be 'install' or 'run'" && exit 1

target="$4"
[[ -z $target ]] && echo "Target directory is not provided" && exit 1
target=$(realpath "$target")

mkdir -p "$target"

if [[ $action == "install" ]]; then 
  virtualenv -p python2 "$target"
  "$target/bin/pip" install -r "$klipper_src_dir/../scripts/klippy-requirements.txt"
fi

[[ $action != "run" ]] && exit 0

cd "$klipper_src_dir"
"$target/bin/python" ./klippy.py "$config_file"
