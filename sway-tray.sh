#!/bin/sh

# ===
TRAY_OS=`uname -r`

# ===
PER_MIN_LOAD=`cat /proc/loadavg | awk '{print $1}'`
CPU_CORE=`cat /proc/cpuinfo| grep ^processor | wc -l`
USE_LOAD=`echo "scale=2; (${PER_MIN_LOAD}/${CPU_CORE})*100" | bc | sed 's/\.[0-9]*$//'`
LOAD_STRING=`printf '[%3d%s]' ${USE_LOAD} '%'`

TRAY_LOAD="${LOAD_STRING} 🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴"
[[ ${USE_LOAD} -ge 1 ]] && [[ ${USE_LOAD} -le 5 ]]    && TRAY_LOAD="${LOAD_STRING} 🟡⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 6 ]] && [[ ${USE_LOAD} -le 10 ]]   && TRAY_LOAD="${LOAD_STRING} 🟠⚪⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 11 ]] && [[ ${USE_LOAD} -le 15 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟡⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 16 ]] && [[ ${USE_LOAD} -le 20 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠⚪⚪⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 21 ]] && [[ ${USE_LOAD} -le 25 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟡⚪⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 26 ]] && [[ ${USE_LOAD} -le 30 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠⚪⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 31 ]] && [[ ${USE_LOAD} -le 35 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟡⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 36 ]] && [[ ${USE_LOAD} -le 40 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠⚪⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 41 ]] && [[ ${USE_LOAD} -le 45 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟡⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 46 ]] && [[ ${USE_LOAD} -le 50 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠⚪⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 51 ]] && [[ ${USE_LOAD} -le 55 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟡⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 56 ]] && [[ ${USE_LOAD} -le 60 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠⚪⚪⚪⚪"
[[ ${USE_LOAD} -ge 61 ]] && [[ ${USE_LOAD} -le 65 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟡⚪⚪⚪"
[[ ${USE_LOAD} -ge 66 ]] && [[ ${USE_LOAD} -le 70 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠⚪⚪⚪"
[[ ${USE_LOAD} -ge 71 ]] && [[ ${USE_LOAD} -le 75 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠🟡⚪⚪"
[[ ${USE_LOAD} -ge 76 ]] && [[ ${USE_LOAD} -le 80 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠🟠⚪⚪"
[[ ${USE_LOAD} -ge 81 ]] && [[ ${USE_LOAD} -le 85 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠🟠🟡⚪"
[[ ${USE_LOAD} -ge 86 ]] && [[ ${USE_LOAD} -le 90 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠🟠🟠⚪"
[[ ${USE_LOAD} -ge 91 ]] && [[ ${USE_LOAD} -le 95 ]]  && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠🟠🟠🟡"
[[ ${USE_LOAD} -ge 96 ]] && [[ ${USE_LOAD} -le 100 ]] && TRAY_LOAD="${LOAD_STRING} 🟠🟠🟠🟠🟠🟠🟠🟠🟠🟠"

# ===
SINK_DEVICE="hdmi-stereo-extra3"
BASE_VOLUME=`pactl list sinks | grep -A 10 ${SINK_DEVICE} | grep "Volume:" | head -n 1 | awk -F '/ ' '{print $2}'`
CURRENT_VOL=`echo ${BASE_VOLUME} | tr -d '%'`
MUTE_INFO=`pactl list sinks | grep -A 10 ${SINK_DEVICE} | grep "Mute:" | awk '{print $2}'`

if [[ ${MUTE_INFO} == "yes" ]]
then
	TRAY_VOLUME="🔇"
else	
	if [[ ${CURRENT_VOL} -le 30 ]]
	then
		TRAY_VOLUME="🔈 ${BASE_VOLUME}"
	elif [[ ${CURRENT_VOL} -lt 0 ]]
	then
		TRAY_VOLUME="🔈"
	elif [[ ${CURRENT_VOL} -gt 31 ]] && [[ ${CURRENT_VOL} -le 80 ]]
	then
		TRAY_VOLUME="🔉 ${BASE_VOLUME}"
	elif [[ ${CURRENT_VOL} -gt 81 ]] && [[ ${CURRENT_VOL} -le 100 ]]
	then
		TRAY_VOLUME="🔊 ${BASE_VOLUME}"
	else
		TRAY_VOLUME="🔊 100%"
	fi
fi

# ===
TRAY_TIME=`date +'%Y-%m-%d(%a) %l:%M %p'`

### Print tray message
echo "${TRAY_OS} | ${TRAY_LOAD} | ${TRAY_VOLUME} | ${TRAY_TIME}"
