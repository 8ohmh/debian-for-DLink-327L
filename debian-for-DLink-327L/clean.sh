#!/bin/sh
export now_date="$(date +"%Y%m%d%H%M%S")"
export addon_name="debian"
#remove link
export the_1st_parm="$1"
export the_2nd_parm="$2"
export curr_path="$(readlink -f "$0")"
export curr_dir="$(dirname "$curr_path")"

export disk_path="/mnt/HD/HD_a2"
export nas_prog_path="${disk_path}/Nas_Prog"
export addon_path="${nas_prog_path}/${addon_name}"
. "${addon_path}/setvars.sh"
if [ -z "$log_path" ]; then
   export log_path="${addon_path}/${addon_name}_addon_${now_date}_log.txt"
fi
printf "\n$0\n" >> "$log_path"
