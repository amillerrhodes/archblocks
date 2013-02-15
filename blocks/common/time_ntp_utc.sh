#/!bin/bash
#
# TIME

ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc --utc # set hardware clock
_installpkg ntp

systemctl enable ntpd.service

