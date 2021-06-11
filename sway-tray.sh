#!/bin/sh

CACHE_DIR="${HOME}/.cache/sway-tray"
[[ ! -d ${CACHE_DIR} ]] && mkdir ${CACHE_DIR}

# ===
TEMP_FILE="${CACHE_DIR}/sway-tray-osver-`date +'%y%m%d'`"

if [[ ! -f ${TEMP_FILE} ]]
then
	rm -rf ${CACHE_DIR}/sway-tray-osver-*
	hostnamectl status | grep 'Operating System' | awk '{print $3" "$4}' > ${TEMP_FILE}
fi

TRAY_OSVER=`cat ${TEMP_FILE}`

# ===
LOAD_USE=`cat /proc/stat | egrep '^cpu ' | awk '{ print 1000-($5/($2+$3+$4+$5+$6+$7+$8))*1000 }' | awk -F '.' '{print $1}'`
TRAY_LOAD="🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴"

[[ ${LOAD_USE} -eq 0 ]]                                 && TRAY_LOAD="⚪⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 1 ]]   && [[ ${LOAD_USE} -le 50 ]]   && TRAY_LOAD="🟡⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 51 ]]  && [[ ${LOAD_USE} -le 100 ]]  && TRAY_LOAD="🟠⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 101 ]] && [[ ${LOAD_USE} -le 150 ]]  && TRAY_LOAD="🟠🟡⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 151 ]] && [[ ${LOAD_USE} -le 200 ]]  && TRAY_LOAD="🔴🟠⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 201 ]] && [[ ${LOAD_USE} -le 250 ]]  && TRAY_LOAD="🔴🟠🟡⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 251 ]] && [[ ${LOAD_USE} -le 300 ]]  && TRAY_LOAD="🔴🔴🟠⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 301 ]] && [[ ${LOAD_USE} -le 350 ]]  && TRAY_LOAD="🔴🔴🟠🟡⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 351 ]] && [[ ${LOAD_USE} -le 400 ]]  && TRAY_LOAD="🔴🔴🔴🟠⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 401 ]] && [[ ${LOAD_USE} -le 450 ]]  && TRAY_LOAD="🔴🔴🔴🟠🟡⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 451 ]] && [[ ${LOAD_USE} -le 500 ]]  && TRAY_LOAD="🔴🔴🔴🔴🟠⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 501 ]] && [[ ${LOAD_USE} -le 550 ]]  && TRAY_LOAD="🔴🔴🔴🔴🟠🟡⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 551 ]] && [[ ${LOAD_USE} -le 600 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🟠⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 601 ]] && [[ ${LOAD_USE} -le 650 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🟠🟡⚪⚪⚪"
[[ ${LOAD_USE} -ge 651 ]] && [[ ${LOAD_USE} -le 700 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🟠⚪⚪⚪"
[[ ${LOAD_USE} -ge 701 ]] && [[ ${LOAD_USE} -le 750 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🟠🟡⚪⚪"
[[ ${LOAD_USE} -ge 751 ]] && [[ ${LOAD_USE} -le 800 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🔴🟠⚪⚪"
[[ ${LOAD_USE} -ge 801 ]] && [[ ${LOAD_USE} -le 850 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🔴🟠🟡⚪"
[[ ${LOAD_USE} -ge 851 ]] && [[ ${LOAD_USE} -le 900 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🔴🔴🟠⚪"
[[ ${LOAD_USE} -ge 901 ]] && [[ ${LOAD_USE} -le 950 ]]  && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🔴🔴🟠🟡"
[[ ${LOAD_USE} -ge 951 ]] && [[ ${LOAD_USE} -le 1000 ]] && TRAY_LOAD="🔴🔴🔴🔴🔴🔴🔴🔴🔴🟠"

# ===

MEM_INFO_LIST=( `cat /proc/meminfo | egrep 'MemTotal:|Active:|Inactive:' | awk '{print $2}'` )
TOTAL_MEM_USE=`echo "scale=2; ((${MEM_INFO_LIST[1]}+${MEM_INFO_LIST[2]})/${MEM_INFO_LIST[0]})*10+0.5" | bc | cut -d '.' -f 1`
[[ ${TOTAL_MEM_USE} -eq 0 ]] && TOTAL_MEM_USE=1
MEM_FREE_USE=`echo "10-${TOTAL_MEM_USE}" | bc`
MEM_ACTIVE_USE=`echo "scale=2; ${TOTAL_MEM_USE}*(${MEM_INFO_LIST[1]}/(${MEM_INFO_LIST[1]}+${MEM_INFO_LIST[2]}))+0.5" | bc | cut -d '.' -f 1`
[[ ${MEM_ACTIVE_USE} -eq 0 ]] && MEM_ACTIVE_USE=1
MEM_INACTIVE_USE=`echo "${TOTAL_MEM_USE}-${MEM_ACTIVE_USE}" | bc`
[[ ${MEM_INACTIVE_USE} -le 0 ]] && MEM_INACTIVE_USE=0

[[ ${MEM_ACTIVE_USE} -eq 0 ]]  && AVICE_GAUGE=""
[[ ${MEM_ACTIVE_USE} -eq 1 ]]  && AVICE_GAUGE="🟦"
[[ ${MEM_ACTIVE_USE} -eq 2 ]]  && AVICE_GAUGE="🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 3 ]]  && AVICE_GAUGE="🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 4 ]]  && AVICE_GAUGE="🟦🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 5 ]]  && AVICE_GAUGE="🟦🟦🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 6 ]]  && AVICE_GAUGE="🟦🟦🟦🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 7 ]]  && AVICE_GAUGE="🟦🟦🟦🟦🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 8 ]]  && AVICE_GAUGE="🟦🟦🟦🟦🟦🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 9 ]]  && AVICE_GAUGE="🟦🟦🟦🟦🟦🟦🟦🟦🟦"
[[ ${MEM_ACTIVE_USE} -eq 10 ]] && AVICE_GAUGE="🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦"

[[ ${MEM_INACTIVE_USE} -eq 0 ]]  && INAVICE_GAUGE=""
[[ ${MEM_INACTIVE_USE} -eq 1 ]]  && INAVICE_GAUGE="🟩"
[[ ${MEM_INACTIVE_USE} -eq 2 ]]  && INAVICE_GAUGE="🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 3 ]]  && INAVICE_GAUGE="🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 4 ]]  && INAVICE_GAUGE="🟩🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 5 ]]  && INAVICE_GAUGE="🟩🟩🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 6 ]]  && INAVICE_GAUGE="🟩🟩🟩🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 7 ]]  && INAVICE_GAUGE="🟩🟩🟩🟩🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 8 ]]  && INAVICE_GAUGE="🟩🟩🟩🟩🟩🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 9 ]]  && INAVICE_GAUGE="🟩🟩🟩🟩🟩🟩🟩🟩🟩"
[[ ${MEM_INACTIVE_USE} -eq 10 ]] && INAVICE_GAUGE="🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩"

[[ ${MEM_FREE_USE} -eq 0 ]]  && FREE_GAUGE=""
[[ ${MEM_FREE_USE} -eq 1 ]]  && FREE_GAUGE="⬜"
[[ ${MEM_FREE_USE} -eq 2 ]]  && FREE_GAUGE="⬜⬜"
[[ ${MEM_FREE_USE} -eq 3 ]]  && FREE_GAUGE="⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 4 ]]  && FREE_GAUGE="⬜⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 5 ]]  && FREE_GAUGE="⬜⬜⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 6 ]]  && FREE_GAUGE="⬜⬜⬜⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 7 ]]  && FREE_GAUGE="⬜⬜⬜⬜⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 8 ]]  && FREE_GAUGE="⬜⬜⬜⬜⬜⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 9 ]]  && FREE_GAUGE="⬜⬜⬜⬜⬜⬜⬜⬜⬜"
[[ ${MEM_FREE_USE} -eq 10 ]] && FREE_GAUGE="⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜"

TRAY_MEM="${AVICE_GAUGE}${INAVICE_GAUGE}${FREE_GAUGE}"

# ===
CHECK_NET_CONNECT=`LANG=C nmcli -o | grep " connected"`

if [[ `echo ${CHECK_NET_CONNECT} | wc -w` -ne 0 ]]
then
	TRAY_NET=`echo ${CHECK_NET_CONNECT} | awk '{ if ( $1 == "wlo1:" ) { print "📶 "$4 } else { print "☑️ "$4 } }'`
else
	TRAY_NET="⚠️  offline"
fi

# ===
SINK_NAME="PipeWire"
BASE_VOLUME=`pactl list sinks | grep -A 10 ${SINK_NAME} | grep "Volume:" | head -n 1 | awk -F '/ ' '{print $2}'`
CURRENT_VOL=`echo ${BASE_VOLUME} | tr -d '%'`
MUTE_INFO=`pactl list sinks | grep -A 10 ${SINK_NAME} | grep "Mute:" | awk '{print $2}'`

if [[ ${MUTE_INFO} == "yes" ]]
then
	TRAY_VOLUME="🔇"
else	
	if [[ ${CURRENT_VOL} -le 0 ]]
	then
		TRAY_VOLUME="🔈  0%"
	elif [[ ${CURRENT_VOL} -le 10 ]]
	then
		TRAY_VOLUME="🔈  ${BASE_VOLUME}"
	elif [[ ${CURRENT_VOL} -ge 11 ]] && [[ ${CURRENT_VOL} -le 80 ]]
	then
		TRAY_VOLUME="🔉 ${BASE_VOLUME}"
	elif [[ ${CURRENT_VOL} -ge 81 ]] && [[ ${CURRENT_VOL} -le 100 ]]
	then
		TRAY_VOLUME="🔊 ${BASE_VOLUME}"
	else
		TRAY_VOLUME="🔊100%"
	fi
fi

# ===
TEMP_FILE="${CACHE_DIR}/i3-tray-weather-`date +'%y%m%d%H'`"

if [[ ! -f ${TEMP_FILE} ]]
then
	rm -rf ${CACHE_DIR}/sway-tray-weather-*
	[[ ${TRAY_NET} != "offline" ]] && curl wttr.in/busan?format=3 > ${TEMP_FILE}
else
	if [[ `date +'%M%S'` == "0000" ]]
	then
		[[ ${TRAY_NET} != "offline" ]] && curl wttr.in/busan?format=3 > ${TEMP_FILE}
	fi
fi

if [[ `cat ${TEMP_FILE} | wc -l` -ne 0 ]]
then
	TRAY_WEATHER=`cat ${TEMP_FILE}`
else
	TRAY_WEATHER="🌏 --"
fi

# ===
#TRAY_TIME=`date +'%Y-%m-%d(%a) %H:%M'`
TRAY_TIME=`date +'%m/%d(%a) %H:%M'`

# ===
USER_NAME=`cat /etc/passwd | grep ${USER} | awk -F ':' '{print $5}'`

### Print tray message
echo "${TRAY_OSVER}│${TRAY_LOAD}│${TRAY_MEM}|${TRAY_NET}│${TRAY_VOLUME}│${TRAY_WEATHER}│${TRAY_TIME}│${USER_NAME}│"
