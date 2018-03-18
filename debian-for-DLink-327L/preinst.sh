#!/bin/sh
export now_date="$(date +"%Y%m%d%H%M%S")"
# by Holger Ohmacht aka 8ohmh
#PATH=/usr/bin:$PATH
export now_date="$(date +"%Y%m%d%H%M%S")"
export addon_name="debian"
export fdebug="y"
export the_1st_parm="$1"
export the_2nd_parm="$2"
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
   export log_path="${addon_path}/${addon_name}_addon_${now_date}_log.txt"
fi
echo "setvar_path: ${setvar_path}"
echo "pwd $PWD"
echo "${backup_log_dirpath}/${log_name}"

##stop daemon
#kill -9 `pidof utelnetd` 2>/dev/null

##remove link
#rm -f /usr/bin/utelnetd  2> /dev/null

##cmd on reinstall
#rm -rf $path_des

##copy file to installed directory
#cp -R $path_src $path_des
