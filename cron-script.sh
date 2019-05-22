#!/usr/bin/zsh
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color
PUSHOVERUSER=''
PUSHOVERAPITOKEN=''

# Log errors
trap "logger 'Uptime monitor crashed'; exit 0;" 1 2 3 6

# Called as islive url title
function isLive() {

	if curl -Is $1 2>&1 | grep -q 'HTTP.* 200'; then
		echo $GREEN 'UP: ' "${2:-$1}"
	else
		echo $RED 'DOWN: ' "${2:-$1}"
		curl -f -X POST -d "token=${PUSHOVERAPITOKEN}&user=${PUSHOVERUSER}&title=DOWNTIME&message=${2:-$1} IS DOWN&url=${1}&priority=1" https://api.pushover.net/1/messages.json
	fi

	# Reset terminal color
	echo $NC
}

isLive 'https://www.google.com/' 'Google'
isLive 'https://www.doesnotexistatall123456789.com/' 'BSURL'