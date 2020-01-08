#!/bin/sh

APP_BIN_PATH="${HOME}/Apps/bin"
cd ${APP_BIN_PATH}

LINK_LIST=`/usr/bin/ls -l | /usr/bin/grep ^l | /usr/bin/grep '/var/lib/flatpak/exports/bin/' | /usr/bin/awk '{print $9}'`
for UNLINK_EXE in ${LINK_LIST}
do
	/usr/bin/unlink ${UNLINK_EXE}
done

FLATPAK_APP_LIST=`/usr/bin/flatpak list --app --columns=application | /usr/bin/grep -v 'Application ID'`
for APP in ${FLATPAK_APP_LIST}
do
	APP_COMMAND=`/usr/bin/flatpak info -m ${APP} | /usr/bin/grep "^command" | /usr/bin/awk -F '=' '{print $2}'`
	/usr/bin/ln -s /var/lib/flatpak/exports/bin/${APP} ${APP_COMMAND}
done
