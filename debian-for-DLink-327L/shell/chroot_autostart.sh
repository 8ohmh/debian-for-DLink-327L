#!/bin/sh
#by 8ohmh aka Holger Ohmacht
export now_date="$(date +"%Y%m%d%H%M%S")"
log_dir="/debian_addon_logs"
mkdir -pm 777 "${log_dir}"
export flag_run_apt_mirror="y"
export flag_print_vars="n"
export flag_mount_hda2_into_chroot="n"
export flag_do_apt_upgrade="n"

#FILL="$(printf "%.1s" "~"{1..36})" #TODO
#FMT="\n%.36s\n"
llp="$(readlink -f "$0")"
dp="$(dirname "$llp")"
#. "/setvars.sh"
log_path="${log_dir}/${now_date}_chrooted.log" #TODO
echo "$llp"
echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> "$log_path"
echo "$0"
echo "$PWD"
printf   '"%ls": param 1: "%ls"\n' "$0" "$1" >> "$log_path"
printf   '"%ls": param 2: "%ls"\n' "$0" "$2" >> "$log_path"
printf   '"%ls": chroot-script "%ls" started at %ls"\n' \
   "$0" "$(date)" >> "$log_path"
printf   '"%ls": PWD: "%ls"\n' "$0" "$PWD" >> "$log_path"
printf   '"%ls": chrooted.log is at "%ls"\n' \
   "$0" "$log_path" >> "$log_path"

if [ "$flag_print_vars" = "y" ]; then
   echo >> "$log_path"
   set >> "$log_path"
fi

if [ "$flag_mount_hda2_into_chroot" = "y" ]; then
   printf '\n"%ls": flag_do_apt_upgrade...' "$0" >> "$log_path"
   printf'"%ls": flag_mount_hda2_into_chroot'  \
      "$0" >> "$log_path"
   mkdir -pm  777 "/disk"
   mount /dev/sda2 "/disk"
   echo "done" >> "$log_path"
fi

if [ "$flag_do_apt_upgrade" = "y" ]; then
   printf '\n"%ls": flag_do_apt_upgrade...' "$0" >> "$log_path"
   apt-get update
   apt-get -q upgrade
   apt-get dist-upgrade
   echo "done" >> "$log_path"
fi

#<@old>
#apt-get --help 2>&1 >> "$log_path"
#printf '\n\n%ls\n\n' "$(cat "/readme.1st")"
#</@old>

#<@nmap local net>
if [ "$flag_do_selftest_nmap" = "y" ]; then
    nmap_log_dir="/nmap_logs"
    mkdir -pm 755 "${nmap_log_dir}"
    nmap --privileged --data-length 512 192.168.178.1-200 2>&1 >> "${nmap_log_dir}/nmap_${now_date}.txt" &
fi
#</@nmap local net>

#<@extraswap>
extraswap_path="/extraswap.bin"
if [ ! -f "$extraswap_path" ]; then
 dd if=/dev/zero of="$extraswap_path"  bs=1G count=5
fi

if [ -f "$extraswap_path" ]; then
 losetup /dev/loop6 "$extraswap_path"
 mkswap /dev/loop6
 swapon /dev/loop6
fi
#</@extraswap>

#<@apt-mirror>
if [ "$flag_run_apt_mirror" = "y" ]; then
    apt-mirror 2>&1 >> "$log_path" &
fi
#</@apt-mirror>

#<@clamav>
if [ "$flag_run_freshclam" = "y" ]; then
    freshclam -d -c 2
fi
#clamscan /debianmirror  2>&1 >> "/clamscan.log" &
#</@clamav>
