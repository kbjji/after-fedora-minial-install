#!/bin/sh

RUN_FLATPAK="yes"

function for_fedora_silverblue() {
	# Fedora Silverblue
	CMD="sudo rpm-ostree"
	${CMD} update
	if [ `rpm -qav | grep rpmfusion | wc -l` -eq 0 ]
	then
		if [[ `cat /etc/os-release | grep OSTREE_VERSION | grep -i rawhide | wc -l` -eq 0 ]]
		then
			${CMD} install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
		else
			${CMD} install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm
		fi
    		echo ""
    		echo "Please Reboot and re-run this script!"
   		echo ""
	else
	  	${CMD} install ffmpeg ffmpeg-libs fuse-exfat gnome-tweaks p7zip unrar xorg-x11-drv-amdgpu xorg-x11-fonts-misc zsh
	  	echo ""
  	fi
}

function for_fedora_release() {
	CMD="sudo dnf -y install"
	# RPMFUSION
	echo "Enable rpmfusion..."
	${CMD} redhat-lsb-core
	if [ `rpm -qv rpmfusion-free-release rpmfusion-nonfree-release | grep -v "is not " | wc -l` -ne 2 ]
	then
		${CMD} \
		http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-`lsb_release -r -s`.noarch.rpm \
		http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-`lsb_release -r -s`.noarch.rpm
	fi
	echo ""
	# X-Server
	echo "Install X-Server..."
	sudo dnf -y groupinstall base-x
	${CMD} mesa-dri-drivers \
	       mesa-dri-drivers.i686 \
	       mesa-filesystem \
	       mesa-filesystem.i686 \
	       mesa-libEGL \
	       mesa-libEGL.i686 \
	       mesa-libGL \
	       mesa-libGL.i686 \
	       mesa-libGLU \
	       mesa-libGLU.i686 \
	       mesa-libgbm \
	       mesa-libgbm.i686 \
	       mesa-libglapi \
	       mesa-libglapi.i686 \
	       libglvnd-opengl \
	       libglvnd-core-devel \
	       libglvnd-devel \
         xorg-x11-fonts-misc
	echo ""
	# LIB ZIP
	echo "Install Archive Library..."
	${CMD} tar \
	       zip \
	       unzip \
	       cabextract \
	       bzip2 \
	       lzip \
	       p7zip \
	       p7zip-plugins \
	       unrar \
	       arj \
	       unace
	echo ""
	# LIB CODEC
	echo "Install Codec..."
	${CMD} gstreamer1 \
	       gstreamer1-plugins-base \
	       gstreamer1-plugins-ugly \
	       gstreamer1-plugins-ugly-free \
	       gstreamer1-plugins-good \
         ffmpeg \
         ffmpeg-libs \
	       x264 \
	       x265 \
	       openh264 \
	       libavdevice
	echo ""
	# DESKTOP
	echo "Select Desktop Environment... Input Number or Name [Default: gnome]"
	echo "Enabled Desktop Environment:
		1.gnome
		2.kde
		3.mate
		4.xfce
		5.cinnamon"
	echo -n "select(10s): "
	read -t 10 TARGET
	if [ z${TARGET} == "z" ]
	then
		TARGET="1"
	fi	
	case $TARGET in
		1|gnome)
			echo "Install GNOME Desktop Environment..."
			${CMD} gdm \
			       NetworkManager-wifi \
			       libevent \
			       gnome-shell \
			       gnome-shell-extension-common \
			       nautilus \
			       file-roller \
			       gnome-software \
			       xdg-user-dirs-gtk \
			       gvfs-mtp \
			       gvfs-fuse
			sudo systemctl enable gdm
		;;
		2|kde)
			echo "Install KDE Desktop Environment..."
			${CMD} kdm \
			       plasma-nm \
			       NetworkManager-wifi \
			       libevent \
			       plasma-desktop \
			       dolphin \
			       ark \
			       apper \
			       xdg-user-dirs \
			       gvfs-mtp \
			       gvfs-fuse
			sudo systemctl enable kdm
		;;
		3|mate)
			echo "Install MATE Desktop Environment..."
			${CMD} lightdm \
			       NetworkManager-wifi \
			       libevent \
			       network-manager-applet \
			       imsettings-mate \
			       mate-themes \
			       mate-desktop \
			       gtk2-engines \
			       metacity \
			       marco \
			       caja \
			       engrampa \
			       yumex-dnf \
			       xdg-user-dirs-gtk \
			       gvfs-mtp \
			       gvfs-fuse
			sudo systemctl enable lightdm
		;;
		4|xfce)
			echo "Install XFCE Desktop Environment..."
			${CMD} lightdm \
			       NetworkManager-wifi \
			       libevent \
			       network-manager-applet \
			       xfce4-session \
			       xfce4-panel \
			       xfce4-settings \
			       xfwm4 \
			       xfdesktop \
			       fedora-icon-theme \
			       xarchiver \
			       yumex-dnf \
			       xdg-user-dirs-gtk \
			       gvfs-mtp \
			       gvfs-fuse
			sudo systemctl enable lightdm
		;;
		5|cinnamon)
			echo "Install CINNAMON Desktop Environment..."
			${CMD} lightdm \
			       NetworkManager-wifi \
			       libevent \
			       network-manager-applet \
			       imsettings-cinnamon \
			       cinnamon \
			       nemo \
			       nemo-fileroller \
			       file-roller \
			       yumex-dnf \
			       xdg-user-dirs-gtk \
			       gvfs-mtp \
			       gvfs-fuse
			sudo systemctl enable lightdm
		;;
		*)
			echo "skip..."
		;;
	esac
	echo ""
	# APP
	echo "Install Application..."
	${CMD} flatpak \
	       firewall-config \
	       PackageKit-gstreamer-plugin \
	       PackageKit-command-not-found \
         zsh \
	       wireless-tools \
	       net-tools \
	       drpm \
	       tuned \
	       bind-utils \
	       gcc \
	       cpp \
	       make \
	       irqbalance \
	       pciutils \
	       lsof \
	       autofs \
	       gtk2-immodule-xim \
	       gtk3-immodule-xim \
	       ibus-hangul \
	       vim
	echo ""
	# BOOT GRAPHCAL
	if [ `sudo systemctl get-default` != "graphical.target" ]
	then
		echo "Change Graphical boot..."
		sudo systemctl set-default graphical.target
		echo ""
	fi
}

if [ `rpm -q --quiet fedora-repos-ostree; echo $?` -eq 0 ]
then
	for_fedora_silverblue
else
	for_fedora_release
	# Enable Flatpak APP
	if [ ${RUN_FLATPAK} == "yes" ]
	then
		echo "Add flathub repo..."
		sudo flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo      
		echo ""
	fi
fi

# END
echo "Complite Jobs.."
