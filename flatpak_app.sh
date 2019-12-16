#!/bin/sh

COMMAND_NAME=`/usr/bin/echo $0 | /usr/bin/awk -F '/' '{print $NF}'`
APP_BIN_PATH="${HOME}/flatpak-bin"

if [[ ${COMMAND_NAME} == "flatpak_app.sh" ]]
then
	if [[ z$1 == "zupdate" ]]
	then
		cd ${APP_BIN_PATH}
		LINK_LIST=`/usr/bin/ls -l | /usr/bin/grep ^l | /usr/bin/grep flatpak_app.sh | /usr/bin/awk '{print $9}'`
		for UNLINK_EXE in ${LINK_LIST}
		do
			/usr/bin/unlink ${UNLINK_EXE}
		done
		FLATPAK_APP_LIST=`/usr/bin/flatpak list --app --columns=application | /usr/bin/grep -v 'Application ID' | /usr/bin/awk -F '.' '{ if ( $NF == "Client" || $NF == "Application" ) print $(NF-1); else print $NF; }' | /usr/bin/tr "[A-Z]" "[a-z]"`
		for APP in ${FLATPAK_APP_LIST}
		do
			/usr/bin/ln -s `whereis flatpak_app.sh | awk '{print $2}'` ${APP}
		done
		exit 0
	else
		APP_NAME=$1
		if [[ z${APP_NAME} == "z" ]]
		then
			echo "USE: flatpak_app.sh [Application ID] || update"
			exit 0
		fi
	fi
else
	APP_NAME=${COMMAND_NAME}
fi

if [[ z${APP_NAME} != "z" ]]
then			
	APP_ID=`/usr/bin/flatpak list --app --columns=application | /usr/bin/grep -i ${APP_NAME}`
	if [[ z${APP_ID} == "z" ]]
	then
		echo "ERROR: ${APP_NAME} seems to have been uninstalled"
		echo "       Please unlink ${APP_NAME} file"
		exit 1
	fi
	/usr/bin/flatpak run ${APP_ID} $@
fi
