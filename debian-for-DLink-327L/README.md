This is the Debian for DLINK addon
----------------------------------

This addon gives you almost a complete DEBIAN installation on your DLINK NAS, update-able and upgrade-able! Missing is
currently a X11 Server (because there's no graphics card on the DLINK mainboard, but perhaps it is possible to do it with an USB-Graphics card, plugged into the NAS; Post intallation of X11 is possible)

To do some jobs after starting everytime by chrooting into debian, modify file /Nas_Prog/debian/shell/chroot_autostart.sh.

BUT READ THAT FIRST:

To use debian for dlink:

1. Enable in the admin webpage on your NAS the sshd addon and/OR the sshd in Management/SSH/Remote Access SSH
2. In Windows: download and install OpenSSH and PUTTY; In Linux: apt-get install sshd/ssh package
3. then use the script „ssh_dss_nas.sh“ to login into the NAS.
4. There you have to use „chroot2debian.sh“ to get into Debian Chroot or/to use „get2debianaddon.sh“ to get to the Addon folder)
5. BEFORE ANYTHING AT ALL you have to update the debian sources list by the command
„apt-get update“ and then updating your dlink and/or Notebook/PC etc linux installation by
„apt-get dist-upgrade“ and then
- for better Linux using - you HAVE TO INSTALL „mc“ (Midnight commander) by
„apt-get install mc“.
6. It takes some time to install the updates, Then you can use your linux
(Commands are typed in without question marks „)
7. There are some useful scripts in the Addon_dir /mnt/HD/HD_a2/Nas_Prog/debian/shell.
8. PAY ATTENTION: do NOT modify anything there EXCEPT file "chroot_autoscript.sh". It is the autostart file after chrooting

Binaries packed and done by debian community and vterdohleb, while
packaging into addon and shell scripting done by 8ohmh aka Holger Ohmacht.
