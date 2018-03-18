#!/bin/sh
# by Holger Ohmacht aka 8ohmh
export now_date="$(date +"%Y%m%d%H%M%S")"
export addon_name="debian"
export parm_01="$1" #TODO
export parm_02="$2"
PATH=/usr/bin:$PATH
export PATH

#export app_path="$(dirname "$0")"
export disk_path="/mnt/HD/HD_a2"
export nas_prog_path="${disk_path}/Nas_Prog"
export addon_path="${nas_prog_path}/${addon_name}"
. "${addon_path}/setvars.sh"

if [ -z "$log_path" ]; then
   export log_path="${addon_path}/${addon_name}_addon_${now_date}_log.txt"
fi

echo "$addon_path" > "/mnt/HD/HD_a2/addon_path.txt"
echo "$log_path" > "/mnt/HD/HD_a2/log_path.txt"
cd "$addon_path"
# EXTRACTING DEBIAN
# mv ../debian-wheezy-fullbase-arm.tgz ./
# tar zxf debian-wheezy-fullbase-arm.tgz #TODO into INSTALL

printf "\ninit.sh\n" >> "$log_path"
date >> "$log_path"
printf 'path: 1 "%ls"\n' "$0" >> "$log_path"
printf 'path: 2 "%ls"\n' "$1" >> "$log_path"
printf 'path: 3 "%ls"\n' "$(basename "$0")" >> "$log_path"
printf 'path: 4 "%ls"\n' "$(dirname "$0")" >> "$log_path"
printf 'path: 5 "%ls"\n' "$PWD" >> "$log_path"
cd "$addon_path"
mkdir -pm 755 "${xlinux_chroot_path}"
#echo "${xlinux_chroot_path}" > "${xlinux_inst_filepath}"

if [ ! -z "$addon_path" ]; then
   echo
else
   echo
   #app_path="${addon_path}"
fi

echo "inst path $xlinux_inst_path" >> "$log_path"

# link used shell scripts into several folders
for linkpath in "${xlinux_inst_path}" "/root" "/"; do
   ln -sf "${addon_shellscripts_dirpath}/chroot2linux.sh" \
      "${linkpath}/"
   ln -sf "${addon_shellscripts_dirpath}/get2debianaddonfolder.sh" \
      "${linkpath}/"
   ln -sf "${addon_docs_dirpath}/debian_addon_readme1st.txt" \
      "${linkpath}/"
done

printf '"%ls":$chrootautostart_script_path=\n\t"%ls"\n' \
   "$0" "$chrootautostart_script_path" >> "$log_path"

printf '"%ls": copying "%ls" to relevant dirs "%ls"...' \
   "$0" "$chrootautostart_script_path" \
   "$xlinux_inst_path/" >> "$log_path" # TODO

xlinux_chroot_addon_backup_path="${xlinux_inst_path}/zzz-backup/debian_addon"

mkdir -pm 777 "${xlinux_chroot_addon_backup_path}"
mv \
   "${chrootautostart_script_xlinux_path}" \
   "${xlinux_chroot_addon_backup_path}"
cp -f \
   "${chrootautostart_script_path}" \
   "${chrootautostart_script_xlinux_path}" 2>&1 >> "$log_path"
echo "done" >> "$log_path"

mkdir -pm 777 "${addon_website}"
# webpage,function,css,js,cgi
ln -sf "$addon_webpath" "$addon_website" 2>&1 >> "$log_path"
echo "aw $addon_webpath"
printf '"%ls": setting up addon website:\n' "$0" >> "$log_path"
echo "$addon_webpath/css" >> "$log_path"
ln -s ${addon_webpath}/css/*.css ${addon_website}
ln -s ${addon_webpath}/images/*.png ${addon_website}
ln -s ${addon_webpath}/images/*.jpg ${addon_website}
ln -s ${addon_webpath}/js/*.js ${addon_website}
ln -s ${addon_webpath}/js/jQuery/*.js ${addon_website}
ln -s ${addon_webpath}/js/jScrollPane/images/*.png ${addon_website}
ln -s ${addon_webpath}/js/jScrollPane/scripts/*.js ${addon_website}
ln -s ${addon_webpath}/js/jScrollPane/styles/*.css ${addon_website}
ln -s ${addon_webpath}/js/NiftyCube/*.txt ${addon_website}
ln -s ${addon_webpath}/js/NiftyCube/*.css ${addon_website}
ln -s ${addon_webpath}/js/NiftyCube/*.js ${addon_website}
ln -s ${addon_webpath}/js/curvycorners-2.0.4/*.js ${addon_website}
ln -s ${addon_webpath}/*.html ${addon_website}
ln -sf "${xlinux_inst_path}" "${addon_path}/debian_installation"
# ln -s ${addon_webpath}/web/*.php ${addon_website}
ln -s ${addon_webpath}/web/*.xml ${addon_website}
echo "...done" >> "$log_path"
echo "aw $addon_webpath"
echo "aws $addon_website"
# cp -rfv "${app_path}/"
