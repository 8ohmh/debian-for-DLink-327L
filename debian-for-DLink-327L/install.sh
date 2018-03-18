#!/bin/sh
# by Holger Ohmacht aka 8ohmh
#PATH=/usr/bin:$PATH
export now_date="$(date +"%Y%m%d%H%M%S")"
export addon_name="debian"
export the_1st_parm="$1"
export the_2nd_parm="$2"
export the_install_source_path="$the_1st_parm"
export the_install_dest_path="$the_2nd_parm"
export curr_path="$(readlink -f "$0")"
export curr_dir="$(dirname "$curr_path")"

# In DLINK 32/L NAS LINUX:
# parm_01: "/mnt/HD/HD_a2/Nas_Prog/_install/debian"
# parm_02: "/mnt/HD/HD_a2/Nas_Prog"

export disk_path="/mnt/HD/HD_a2"
export log_path="${disk_path}/${addon_name}_install_log_${now_date}.txt"
export nas_prog_path="${disk_path}/Nas_Prog"
export addon_path="${the_install_dest_path}/${addon_name}"
mkdir -pm 755 "$addon_path"

if [ ! -w "$addon_path" ]; then
   mkdir -pm 755 "$addon_path"
fi
echo "$the_install_source_path" >> "$log_path"

echo "$the_install_dest_path" >> "$log_path"
. "${the_install_source_path}/setvars.sh"

echo "settin vars: done" >> "$log_path"

#. "${the_install_source_path}/setvars.sh"

if [ -z "$log_path" ]; then
   export log_path="${disk_path}/${addon_name}_install_log_${now_date}.txt"
   #export log_path="${addon_path}/log.txt"
fi

current_path="$PWD"
echo "$current_path"

printf "\n" >> "$log_path"
printf '\n"%ls":\n' "$0" >> "$log_path"
printf '"%ls": parm_01: "%ls"\n' "$0" "$the_1st_parm" >> "$log_path"
printf '"%ls": parm_02: "%ls"\n' "$0" "$the_2nd_parm" >> "$log_path"
ls -alr "ls: $the_1st_parm" >> "$log_path"

#printf '%ls\n' "${path_des}/debian" > "/mnt/HD/HD_a2/debian_inst_path"

printf '"%ls": creating %ls "%ls" folder...\n' \
   "$0" "$xlinux_name" "$xlinux_inst_path" >> "$log_path"
mkdir -pm 777 "$xlinux_inst_path"  >> "$log_path"
backup_path="${disk_path}/backup_old_addon/${now_date}"
mkdir -pm 777 "${backup_path}"

if [ -r "${addon_path}" ]; then
	rsync --force --progress --remove-source-files \
		"${addon_path}/" "${backup_path}/"
fi

rsync -aW --progress --stats  \
	"${the_install_source_path}/" "${addon_path}/"  >> "$log_path"

tar -zx -C "$xlinux_inst_path" -f "${xlinux_tar_path}" 2>&1 >> "$log_path"
printf  '%ls' "$debian_path" > "/mnt/HD/HD_a2/debian_path"
printf  '%ls' "$web_path" > "/mnt/HD/HD_a2/debian_path"
#printf 'creatin : "%ls"\n' "$web_path" >> "$log_path"
#mkdir -pvm 777 "$web_path"  >> "$log_path"
#ln -svf ${path_src}/web/* "$web_path" 2>&1 >> "$log_path"
#ls -alR "$path_src" >> "$log_path"
#cp -fvr "${path_src}/webpage/" "$web_path" 2>&1 >> "$log_path"

#ln -sv ${path_des}/webpage "$web_path" 2>&1 >> "$log_path"

