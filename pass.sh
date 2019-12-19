#!/bin/sh	
  
# Firefox Quantum Password Query
PROFILE=`cat ${HOME}/.mozilla/firefox/profiles.ini | grep -B 1 "Locked=1" | grep "^Default=" | awk -F "=" '{print $2}'`

if [[ z`whereis -b ffpass | awk '{print $2}'` == "z" ]]
then
	echo "This script used ffpass. To Be Install..."
	echo "Check https://github.com/louisabraham/ffpass"
	pip install --user ffpass
fi

TARGET=$1
if [[ z${TARGET} != "z" ]]
then
	ffpass export -d ${HOME}/.mozilla/firefox/${PROFILE} | egrep -v "^chrome:|^url" | \
	egrep "^http(s)?:\/\/[a-z0-9(-)(_)(@)(.)]*${TARGET}.[a-z0-9(-)(_)(@)(.)]*," | awk -F "," '{printf "%s\n┗ ID: %s | PASS: %s\n\n", $1, $2, $3}'
else
	ffpass export -d ${HOME}/.mozilla/firefox/${PROFILE} | egrep -v "^chrome:|^url" | \
	awk -F "," '{printf "%s\n┗ ID: %s | PASS: %s\n\n", $1, $2, $3}'
fi
