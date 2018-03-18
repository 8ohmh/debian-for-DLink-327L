#!/bin/sh
# by Holger Ohmacht aka 8ohmh
#PATH=/usr/bin:$PATH
export the_1st_parm="$1"
export the_2nd_parm="$2"
export the_3rd_parm="$3"
export now_date="$(date +"%Y%m%d%H%M%S")"
export addon_name="debian"
export fdebug="y"
export curr_path="$(readlink -f "$0")"
export curr_dir="$(dirname "$curr_path")"

#export addon_path="$(readlink -f "$curr_dir")"
#export nas_prog_path="$(readlink -f "${curr_dir}/../")"

export disk_path="/mnt/HD/HD_a2"
export nas_prog_path="${disk_path}/Nas_Prog"
export addon_path="${nas_prog_path}/${addon_name}"
export setvar_path="$(readlink -f "${addon_path}/setvars.sh")"

echo "ap: $addon_path"
echo "np: $nas_prog_path"

. "${setvar_path}"

if [ -z "$log_path" ]; then
   export log_path="${addon_path}/debian_addon_${now_date}_log.txt"
fi

echo "setvar_path: ${setvar_path}"
echo "pwd: '$PWD'"
echo "${backup_log_dirpath}/${log_name}"

echo "__________________________________________________" >> "$log_path"

printf '"%ls" start.sh\n' "$0" >> "$log_path"
date >> "$log_path"
printf 'parms: $1 "%ls"\n' "$1" >> "$log_path"
printf 'parms: $2 "%ls"\n' "$2" >> "$log_path"
printf 'path: basename $0 = "%ls"\n' "$(basename "$0")" >> "$log_path"
printf 'path: dirname $0 = "%ls"\n' "$(dirname "$0")" >> "$log_path"
printf 'path: pwd "%ls"\n' "$(pwd)" >> "$log_path"

printf '"%ls": debian install path: "%ls"\n' \
   "$0" \
   "$xlinux_inst_path" \
   >> "$log_path"

if [ -d "$xlinux_inst_path" ]; then
   echo >> "$log_path"
   printf '"%ls": %ls install path already exists: "%ls"\n' \
      "$0" \
      "$xlinux_name" \
      "$xlinux_inst_path" \
      >> "$log_path"
fi

# TODO put into install.sh
echo >> "$log_path"
printf '\n"%ls": create links\n' "$0" >> "$log_path"

#<apt-mirror>
killall wget
ln -sf "${addon_webpath}" "${addon_website}" 2>&1 >> "$log_path"
#</apt-mirror>

echo >> "$log_path"
printf '"%ls": %ls folder: "%ls"\n' \
   "$0" "$xlinux_name" "$xlinux_inst_path" >> "$log_path"
echo >> "$log_path"
printf   '"%ls": addon_path: "%ls"\n' \
   "$0" "$addon_path" >> "$log_path"

echo >> "$log_path"
printf   '"%ls": copying "%ls"\n' \
   "$0" "$do_debian_dlink" >> "$log_path"
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&" >> "$log_path"

printf  '"%ls": file "%ls" contains:\n<source>\n%ls\n</source>\n' \
   "$0" \
   "${do_xlinux_dlink_path}" \
   "$ashellfile" >> "$log_path"
   printf   '"%ls": copying scripts !!!TODO LINKS INSTEAD\n' \
      "$0" >> "$log_path"
   echo "${shell_scripts_path}" >> "$log_path"

echo ">>>>>>>>>>> $chrootautostart_script_path" >> "$log_path"
printf '"%ls": %ls folder: "%ls"\n' \
   "$0" "$xlinux_name" "$xlinux_inst_path" >> "$log_path"
cp -b "$chrootautostart_script_path" \
    "${disk_path}/chroot2${xlinux_name}.sh"

printf '"%ls": flag_do_dlink_script\n'  "$0" >> "$log_path"
if [ "$flag_do_dlink_script" = "y" ]; then
   echo "xxxxxxxxxxxxxxxxxxxxxxxxxx" >> "$log_path"
   printf  '\n"%ls": start do linux dlink \n\t"%ls"... ' \
    "$0" \
    "${do_xlinux_dlink_path}" >> "$log_path"
   printf "\nxxxxxxxxxxxxxxxxxxxxxxxxxx" >> "$log_path"
   sh "${do_xlinux_dlink_path}"  \
      "${do_xlinux_log_path}" \
      "/${chrootautostart_file}" 2>&1 >> "$log_path"
   echo "done" >> "$log_path"
fi
printf '"%ls": EOF EOF EOF\n\n' "$0" >> "$log_path"
#<old>
#mkdir -pm 777 "${xlinux_inst_path}/zzz-backup/debian_addon"
#cp "${chrootautostart_script_path}"\
#   "${xlinux_inst_path}/chroot_autostart.sh"
#killall wgetdo_xlinux_log_path
#ln -sf "${app_path}/shell/${do_debian_dlink}" \
#  "/${do_debian_dlink}" >> "$log_path"
#ln -sf "${app_path}/shell/${chrootscript}" \
#   "/${chrootscript}" >> "$log_path"
#ln -sf "${xlinux_inst_path}" "${debian_root_path}" 2>&1 >> "$log_path"
#ls -al "${debian_inst_path}/etc/apt/aptmirror/" 2>&1 >> "$log_path"
#cat "${shell_scripts_path}/${postmirror}" 2>&1 >> "$log_path"
#printf '"%ls": executing cmd "%ls"\n\n' "$0" "$cmd" >> "$log_path"
#eval "$cmd"
#cmd="cp '${shell_scripts_path}/${postmirror}' '${debian_inst_path}/etc/apt/aptmirror/${postmirror}.backup'"
#printf '"%ls": executing cmd "%ls"\n\n' "$0" "$cmd" >> "$log_path"
#eval "$cmd"
#cat "${app_path}/shell/${do_debian_dlink}" 2>&1 >> "$log_path"
#ashellfile="$(cat "${addon_path}/shell/${do_debian_dlink}" 2>&1)"
#printf '"%ls": apt-mirror: "%ls"\n"%ls"\n' "$0" "" ""
#printf 'path: cwd "%ls"\n' "$(cwd)" >> "$log_path"
#the_1st_parm="$1"
#the_2nd_parm="$2"
#echo "pwd $PWD"
#echo "$0"
#FILL=$(printf "%.1s" "~"{1..36})
#FMT="\n%.36s\n"
##printf "\n$FMT\n" "lspci $FILL"
#flag_run_chroot_script="y"
#disk_path="/mnt/HD/HD_a2"
#nas_prog_path="${disk_path}/Nas_Prog"
#addon_path="${nas_prog_path}/debian"
#log_path="${addon_path}/log.txt"
#debian_name="debian"
#debian_chroot_path="/${debian_name}"
#debian_from_addon_path="${addon_path}/debian"
#debian_inst_path="${disk_path}${debian_chroot_path}"
#debian_root_path="$debian_inst_path"
#do_debian_dlink="do_debian_dlink.sh"
#chrootscript="chrootscript.sh"
#postmirror="postmirror.sh"
#debian_ebian_from_addon_path="${addon_path}/debian"
#debian_inst_path="${disk_path}${debian_chroot_path}"
#debian_root_path="$debian_inst_path"
#do_debian_dlink="do_debian_dlink.sh"
#chrootscript="chrootscript.sh"
#postmirror="postmirror.sh"
#debian_conf_filename="debian_inst_path"
#debian_conf_filepath="${addon_path}/${debian_conf_filename}"
#shell_scripts_path="${addon_path}/shell"
# neu: apt_www_path="${web_path}/debian_mirror/mirror"
#apt_mirror_path="${debian_inst_path}/mirror/"
#apt_www_path="${web_path}/debian_mirror"
#dst_web_path="/var/www/debian_addon"conf_filename="debian_inst_path"
#debian_conf_filepath="${addon_path}/${debian_conf_filename}"
#shell_scripts_path="${addon_path}/shell"
# neu: apt_www_path="${web_path}/debian_mirror/mirror"

#if [ -d "$1" ]; then
   #echo
   ##app_path="$1"
#else
   #mkdir -pm 777 "${addon_path}"
#fi
#cp -f "${do_xlinux_dlink_path}" \
   #"/${do_debian_dlink}" 2>&1  >> "$log_path"
#cp -b -f \
   #"${shell_scripts_path}/${do_debian_dlink}" \
   #"${debian_inst_path}/${do_debian_dlink}" 2>&1 >> "$log_path"
#cmd="cp -b -f '${shell_scripts_path}/${postmirror}' '${debian_inst_path}/etc/apt/aptmirror/${postmirror}'"
   #printf '"%ls": file "${disk_path}/debian_inst_path" contains "%ls"\n' \
      #"$0" \
      #"$debian_inst_path" \
      #>> "$log_path"
#if [ -r "${debian_conf_filepath}" ]; then
   #x_inst_path="$(cat "${xlinux_inst_filepath}")"
#else
   #debian_inst_path="${disk_path}/${debian_name}"
   #mkdir -pm 755 "${debian_inst_path}"
#fi
#chrootfilename="${chrootscript}"
#</old>
