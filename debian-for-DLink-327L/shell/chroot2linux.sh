#!/bin/sh
#TODO
xlinux_inst_path="/mnt/HD/HD_a2/debian"
mount -o bind /dev ${xlinux_inst_path}/dev/
mount -o bind /proc ${xlinux_inst_path}/proc/
mount -o bind /sys ${xlinux_inst_path}/sys/
chroot "$xlinux_inst_path"

