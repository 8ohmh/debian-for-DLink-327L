#!/bin/sh
# by 8ohmh aka Holger Ohmacht
export fdebug="y"
echo "$0"

# Relativer Fuck
curr_path="$(readlink -f "$0")"
export the_1st_parm="$1"
export the_2nd_parm="$2"
echo "$the_1st_parm"
echo "$the_2nd_parm"
if [ ! -z "$the_1st_parm" ]; then
   do_xlinux_log_path="$1"
fi
curr_dir="$(dirname "$curr_path")"
#export addon_path="$(readlink -f "${curr_dir}/../")"
echo "ap: $addon_path"
#export nas_prog_path="$(readlink -f "${addon_path}/../")"
echo "np: $nas_prog_path"
#export disk_path="$(readlink -f "${nas_prog_path}/../")"
echo "dp: $disk_path"
echo "pwd $PWD"
export disk_path="/mnt/HD/HD_a2"
export nas_prog_path="${disk_path}/Nas_Prog"
export addon_path="${nas_prog_path}/debian"
log_path="$do_xlinux_log_path"
echo "${backup_log_dirpath}/${do_xlinux_logname}"

setvar_path="$(readlink -f "${addon_path}/setvars.sh")"
echo "setvar_path: ${setvar_path}"
if [ ! -r "$setvar_path" ]; then
   echo "ERROR: missing setvar.sh"
   exit
fi
. "$setvar_path"

killall wget

if [ -z "$do_xlinux_log_path" ]; then
   do_xlinux_log_path="${addon_path}/${now_date}_do_linux.log"
fi

log_path="$do_xlinux_log_path"
echo "${backup_log_dirpath}/${do_xlinux_logname}"
#mv "$log_path" "${backup_log_dirpath}/${now_date}_${do_xlinux_logname}"
#rm -f "$log_path"

if [ "$fdebug" = "y" ]; then
printf '%ls: passed 1st parm "%s"\n' \
   "$0" "$the_1st_parm" >> "$log_path"
printf '%ls: passed 2nd parm "%s"\n' \
   "$0" "$the_2nd_parm" >> "$log_path"
echo  "dp $disk_path"
echo  "np $nas_prog_path"
echo  "ap $addon_path"
echo  "lp $log_path"
echo  "$addon_conf_dirpath"
echo  "$addon_shellscripts_dirpath"
echo  "$addon_webpath"
echo  "$xlinux_chroot_path"
echo  "$addon_xlinux_dirpath"
echo  "$xlinux_inst_path"
echo  "$xlinux_inst_filepath"
echo  "$chrootautostart_file"
echo  "$addon_xlinux_dirpath"
echo  "$do_xlinux_dlink_path"
echo  "$chrootautostart_script_path"
echo  "$postmirror_filepath"
echo  "$lighttpd_conf_filepath"
echo  "$website_path"
echo  "$aptmirror_website_path"
echo  "$deb_mirror_path"
fi

echo "" >> "$log_path"
echo "$0: start" >> "$log_path"
echo "$(date)" >> "$log_path"

export log_path

# creating useful links
for destpath in "/home/root" "/"; do
   ln -sf \
      "${addon_shellscripts_dirpath}/chroot2linux.sh" \
      "${destpath}/chroot2${xlinux_name}.sh"
done

for destpath in "/home/root" "/" "$disk_path"; do
   ln -sf \
      "${xlinux_inst_path}" \
      "$destpath"
done

# <apt-mirror>
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >> "$log_path" # TODO FMT
echo "setting up postmirror and lighttpd" >> "$log_path" # TODO FMT
if [ "$flag_enable_deb_mirror" = "y" ]; then
   printf '\n"%ls": setting lighttpd dir listing active=enable... ' \
      "$0" >> "$log_path"
   #TODO
   echo 'dir-listing.activate = "enable"' >> "/etc/lighttpd/lighttpd.conf"
   echo "done" >> "$log_path"

   printf '"%ls": setting up "apt-mirror": \n\twebserver_path= "%ls"\n\tdeb_mirror_path= "%ls"\n\n' \
      "$0" \
      "$aptmirror_website_path" \
      "$deb_mirror_path" >> "$log_path"
   ln -sf "${deb_mirror_path}" "${aptmirror_website_path}"
   echo "... done" >> "$log_path"

   cmd="cp '${shell_scripts_path}/postmirror.sh' '${xlinux_inst_path}/etc/apt/aptmirror/postmirror.sh'"
   printf '"%ls": executing cmd "%ls"... ' "$0" "$cmd" >> "$log_path"
   #eval "$cmd"
   echo "done" >> "$log_path"
fi
#</apt-mirror>

# CHROOTING HERE!!!!
printf '"%ls": Now  changing the root filesystem to "%ls"... ' \
   "$0" "$xlinux_inst_path" >> "$log_path"
mount -o bind /dev ${xlinux_inst_path}/dev/  2>&1 >> "$log_path"
mount -o bind /proc ${xlinux_inst_path}/proc/  2>&1 >> "$log_path"
mount -o bind /sys ${xlinux_inst_path}/sys/  2>&1 >> "$log_path"
echo "done" >> "$log_path"

echo "yyyyyyyyyyyyyyyyyyyyyyyyy" >> "$log_path" #TODO FMT
printf '"%ls": chrootautostart log is at "%ls"!!!\n\n' \
    "$0" "${chroot_autostart_log_path}" >> "$log_path"
cp -fb "${setvar_path}" "${xlinux_inst_path}/setvar.sh"
cmd="chroot '${xlinux_inst_path}' '${chrootautostart_file_rel}'"
printf   '"%ls": chroot command:\t"%ls"\n' "$0" "$cmd" >> "$log_path"
eval "$cmd"

echo "'$0': EOF EOF" >> "$log_path"

#<old>
#chrootautostart_file_rel
#ls -al "${aptmirror_etc_path}/" 2>&1 >> "$log_path"
   #cat "${shell_scripts_path}/postmirror.sh" 2>&1 >> "$log_path"
   #cmd="ls -al '${debian_inst_path}/etc/apt/aptmirror/' >> '$log_path'"
   #printf '"%ls": executing cmd "%ls"... ' "$0" "$cmd" >> "$log_path"
   #eval "$cmd"
#eval "$cmd"
#cat "$chrootscript_path" >> "$log_path"
#mount -t proc proc /proc
#cat "$chrootscript_path" >> "$log_path"
    #cmd="cp -b -f '${shell_scripts_path}/postmirror.sh' '${debian_inst_path}/etc/apt/aptmirror/postmirror.sh'"
    #printf '"$0": shellscriptpath:\n\t"%ls"\n\t"%ls"\n' "$0" \
    #"${shell_scripts_path}/postmirror.sh" \
    #"${debian_inst_path}/etc/apt/aptmirror" >> "$log_path"
#mkdir -pm 755 "$addon_path"
#mkdir -pm 777 "$debian_inst_path"
#ln -svf "$chrooted_log_path" "$log_path"
#chmod 777 "$chrooted_log_path"
#cp -bf "${addon_path}"
#cp -bf "${addon_path}"
#if [ "" = "the_2nd_parm" ]; then
#    chrootscript_path="/chrootscript.sh"
#else
#    chrootscript_path="$the_2nd_parm"
#    # TODO
#fi
#cat "$setvar_path"
#sh "./setvars.sh"
#the_1st_parm="$1"
#the_2nd_parm="$2"
#cp -f "${chrootautostart_script_path}" "/"
#cp -f "${chrootautostart_script_path}" "${disk_path}"
#cat   "$debian_conf_filepath"
#FILL=$(printf "%.1s" "~"{1..36})
#FMT="\n%.36s\n"
#printf "\n$FMT\n" "lspci $FILL"
#disk_path="/mnchrootautostart_script_patht/HD/HD_a2"
#addon_path="${nas_prog_path}/debian" # TODO
#log_path="${addon_path}/do_deb_log.txt"
#debian
#shell_scripts_path="${addon_path}/shell"
#chroot_autostart_path="${shell_scripts_path}/autostart"
#chrootscripts_path="${addon_path}/chrootscripts" # relative to debian_inst_path
#export chrooted_log_path="${debian_inst_path}/log.txt"
#addon_log_path="${addon_path}/log.txt"
#cat "$chrootautostart_script_path"
#echo "a"
#printf '"%ls": new log_path: "%ls"\n' \
   #"$0" "$log_path" >> "$log_path" # TODO
#cat "${chrootautostart_script_path}"
#printf '%ls: passed log_path "%s"\n' \
#  "$0" "$chrooted_log_path"  >> "$log_path"

#if [ "" = "the_1st_parm" ]; then
    #echo
    ##log_path="$the_1st_parm"
#fi
#printf '%ls: passed 1st parm "%s"\n' \
   #"$0" "$the_1do_xlinux_log_pathst_parm"  >> "$log_path"
#printf '%ls: passed 1st parm "%s"\n' \
   #"$0" "$the_1st_parm"  >> "$log_path"
#</old>

