#!/bin/bash

trap _rb_finish EXIT

version='0.1.0'

. ./rocksbuilder_functions.sh

my_path=$(_rb_abspath "$0")
my_dir=$(dirname "${my_path}")
my_name=$(basename "${my_path}")
my_date=$(date )

readonly version
readonly my_path
readonly my_dir
readonly my_name
readonly my_date

export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin

. ${my_dir}/../../../etc/profile.d/rocks-binaries.sh
. ${my_dir}/../../../etc/profile.d/rocks-devel.sh

usage () {
	cat <<EOF
  usage: ${my_name}
EOF
}

while getopts h args
do
	case $args in
	h) usage; exit 0 ;;
	*) usage; exit 1 ;;
	esac
done

main() {
	for test in $(find "${my_dir}/tests" -name "*.sh"); do
		. "$test"
	done

	printf "\n"
	echo "${my_date} Finished initial startup"
}

main "$@"
