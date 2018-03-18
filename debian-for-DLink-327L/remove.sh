#!/bin/sh
# by Holger Ohmacht aka 8ohmh
#PATH=/usr/bin:$PATH
export now_date="$(date +"%Y%m%d%H%M%S")"
export addon_name="debian"
export the_1st_parm="$1" # addon path 
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
echo "$parm_01" >> "$log_path"
echo "$parm_02" >> "$log_path"
backup_path="${disk_path}/addon_backup/${addon_name}/${now_date}"
. "${addon_path}/setvars.sh"
mkdir -pm 755 "$backup_path"
rsync -aW --remove-source-files "${addon_path}/" "$backup_path/"

current_path="$PWD"
echo "$current_path" >> "$log_path"
echo "$PATH" >> "$log_path"

