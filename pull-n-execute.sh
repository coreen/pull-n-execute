#!/bin/bash

# Coreen Yuen
# pulls script from remote url and executes in single command
# allows for extra http proxy to be specified (optional)
# Usage: ./pull-n-execute.sh <url> <proxy option>

# check for proper usage
if [ $# -lt 1 ]; then
	echo "bad input"
	echo "Usage: ./pull-n-execute.sh [url] [options]"
	echo "options:"
	# `-e` flag tells bash to enable interpretation of backslash escapes
	echo -e "\t-p, --proxy"
	echo -e "\t\tSpecifies the http_proxy url to use for script retrieval."
	exit 1
fi

# use `command -v` over `which` to find if a command exists to avoid launching external process
if ! command -v wget >> /dev/null; then
	# need homebrew to install wget
	if ! command -v brew >> /dev/null; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	brew install wget
fi

URL=$1
# parse url for script name
# ${URL <== from variable URL
#   ##  <== greedy front trim
#   *   <== matches anything
#   /   <== until last delimiter
# }
SCRIPT_NAME=${URL##*/}

# add extra options to `wget` request if specified by user
ADDITIONAL_OPTS=
if [ $# -gt 1 ]; then
	# should always specify the 'url' first before 'options'
        # string indexing => http://tldp.org/LDP/abs/html/string-manipulation.html
	if [ "${1:0:1}" == "-" ]; then
		echo "bad input, [url] MUST be specified before [options]"
		exit 1
	fi
	if [ "$2" == "-p" ] || [ "$2" == "--proxy" ]; then
		ADDITIONAL_OPTS="-e http_proxy=$3"
	fi
fi

wget $ADDITONAL_OPTS $URL
# or can use `ugo+x` or just `+x` instead of octal
chmod 777 $SCRIPT_NAME
./$SCRIPT_NAME

