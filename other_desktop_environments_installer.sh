#!/bin/sh

CMD="sudo rpm-ostree install"

echo "Select Desktop Environment... Input Number or Name (The terminal emulator will not be installed!)"
echo "Enabled Desktop Environment:
	1. kde
	2. mate
	3. xfce
	4. cinnamon
	5. deepin
	6. lxde
"
echo -n "select(10s): "
read -t 10 TARGET
case $TARGET in
	1|kde) ${CMD} plasma-nm plasma-desktop dolphin ;;
	2|mate) ${CMD} network-manager-applet imsettings-mate mate-themes mate-desktop gtk2-engines marco caja ;;
	3|xfce) ${CMD} network-manager-applet xfce4-session xfce4-panel xfce4-settings xfwm4 xfdesktop fedora-icon-theme ;;
	4|cinnamon) ${CMD} network-manager-applet imsettings-cinnamon cinnamon nemo ;;
	5|deepin) ${CMD} deepin-desktop deepin-file-manager ;;
	6|lxde) ${CMD} network-manager-applet lxde-common pcmanfm lxappearance-obconf fedora-icon-theme ;;
	*) echo "Do Not thing"; exit 0 ;;
esac
