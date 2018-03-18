#!/bin/bash
disk_path="/mnt/HD/HD_a2/"
app_path="${disk_path}/Nas_Prog/debian"
log_path="${app_path}/log.txt"
debian_path="${disk_path}/debian/"
umount /dev/ >> "$log_path"
umount /proc/
umount /sys/  >> "$log_path"
umount -lf "$debian_path"
