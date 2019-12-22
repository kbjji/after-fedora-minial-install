#!/bin/sh

CACHE_DIR="${HOME}/.cache/sway-tray"
[[ ! -d ${CACHE_DIR} ]] && mkdir ${CACHE_DIR}

# ===
TEMP_FILE="${CACHE_DIR}/sway-tray-osver-`date +'%y%m%d'`"

if [[ ! -f ${TEMP_FILE} ]]
then
	rm -rf ${CACHE_DIR}/sway-tray-osver-*
	hostnamectl status | grep 'Operating System' | awk -F ': ' '{print $2}' > ${TEMP_FILE}
fi

TRAY_OSVER=`cat ${TEMP_FILE}`

# ===
LOAD_USE=`cat /proc/loadavg | awk '{print ($1/4)*100}' | cut -d '.' -f1`
LOAD_STRING=`printf '[%3d%s]' ${LOAD_USE} '%'`

TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴"
[[ ${LOAD_USE} -eq 0 ]]                               && TRAY_LOAD="${LOAD_STRING} ⚪⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 1 ]]  && [[ ${LOAD_USE} -le 5 ]]   && TRAY_LOAD="${LOAD_STRING} 🟡⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 6 ]]  && [[ ${LOAD_USE} -le 10 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 11 ]] && [[ ${LOAD_USE} -le 15 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟡⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 16 ]] && [[ ${LOAD_USE} -le 20 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🟠⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 21 ]] && [[ ${LOAD_USE} -le 25 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🟠🟡⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 26 ]] && [[ ${LOAD_USE} -le 30 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🟠⚪⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 31 ]] && [[ ${LOAD_USE} -le 35 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🟠🟡⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 36 ]] && [[ ${LOAD_USE} -le 40 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🟠⚪⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 41 ]] && [[ ${LOAD_USE} -le 45 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🟠🟡⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 46 ]] && [[ ${LOAD_USE} -le 50 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🟠⚪⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 51 ]] && [[ ${LOAD_USE} -le 55 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🟠🟡⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 56 ]] && [[ ${LOAD_USE} -le 60 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🟠⚪⚪⚪⚪"
[[ ${LOAD_USE} -ge 61 ]] && [[ ${LOAD_USE} -le 65 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🟠🟡⚪⚪⚪"
[[ ${LOAD_USE} -ge 66 ]] && [[ ${LOAD_USE} -le 70 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🟠⚪⚪⚪"
[[ ${LOAD_USE} -ge 71 ]] && [[ ${LOAD_USE} -le 75 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🟠🟡⚪⚪"
[[ ${LOAD_USE} -ge 76 ]] && [[ ${LOAD_USE} -le 80 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🟠⚪⚪"
[[ ${LOAD_USE} -ge 81 ]] && [[ ${LOAD_USE} -le 85 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🟠🟡⚪"
[[ ${LOAD_USE} -ge 86 ]] && [[ ${LOAD_USE} -le 90 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🔴🟠⚪"
[[ ${LOAD_USE} -ge 91 ]] && [[ ${LOAD_USE} -le 95 ]]  && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🔴🟠🟡"
[[ ${LOAD_USE} -ge 96 ]] && [[ ${LOAD_USE} -le 100 ]] && TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🔴🔴🟠"

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
TEMP_FILE="${CACHE_DIR}/sway-tray-rip-`date +'%y%m%d'`"

if [[ ! -f ${TEMP_FILE} ]]
then
	rm -rf ${CACHE_DIR}/sway_tray_rip-*
	curl -s ifconfig.me > ${TEMP_FILE}
fi

TRAY_IP="📶 `cat ${TEMP_FILE}`"

# ===
SINK_DEVICE="hdmi-stereo-extra3"
BASE_VOLUME=`pactl list sinks | grep -A 10 ${SINK_DEVICE} | grep "Volume:" | head -n 1 | awk -F '/ ' '{print $2}'`
CURRENT_VOL=`echo ${BASE_VOLUME} | tr -d '%'`
MUTE_INFO=`pactl list sinks | grep -A 10 ${SINK_DEVICE} | grep "Mute:" | awk '{print $2}'`

if [[ ${MUTE_INFO} == "yes" ]]
then
	TRAY_VOLUME="🔇"
else	
	if [[ ${CURRENT_VOL} -le 0 ]]
	then
		TRAY_VOLUME="🔈   0%"
	elif [[ ${CURRENT_VOL} -le 10 ]]
	then
		TRAY_VOLUME="🔈   ${BASE_VOLUME}"
	elif [[ ${CURRENT_VOL} -ge 11 ]] && [[ ${CURRENT_VOL} -le 80 ]]
	then
		TRAY_VOLUME="🔉  ${BASE_VOLUME}"
	elif [[ ${CURRENT_VOL} -ge 81 ]] && [[ ${CURRENT_VOL} -le 100 ]]
	then
		TRAY_VOLUME="🔊  ${BASE_VOLUME}"
	else
		TRAY_VOLUME="🔊 100%"
	fi
fi

# ===
TRAY_TIME=`date +'%Y-%m-%d(%a) %l:%M %p'`

### Print tray message
echo "${TRAY_OSVER} │ ${TRAY_LOAD} │ ${TRAY_MEM} │ ${TRAY_IP} │ ${TRAY_VOLUME} │ ${TRAY_TIME}"
