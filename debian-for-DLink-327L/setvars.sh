#!/bin/sh
# by 8ohmh
echo "setvars.sh '$0'"
if [ -z "$now_date" ]; then
   export   now_date="$(date +"%Y%m%d%H%M%S")"
fi
if [ -z "$disk_path" ]; then
   export   disk_path="/mnt/HD/HD_a2"
fi
if [ -z "$nas_prog_path" ]; then
   export   nas_prog_path="${disk_path}/Nas_Prog"
fi
# INPUT: $addon_name, $addon_path, $disk_path, $nas_prog_path, $now_date
export now_date="$(date +"%Y%m%d%H%M%S")"
export log_name="${addon_name}_addon_${now_date}_log.txt"
export log_dir="${addon_path}/yyy-logs"
if [ ! -w "$log_dir" ]; then
	mkdir -pm 777 "$log_dir"
fi
export log_path="${log_dir}/${log_name}"
printf '"%ls" begin\n' "$0" >> "$log_path"
printf 'path: $0 "%ls"\n' "$0" >> "$log_path"
printf 'path: $1 "%ls"\n' "$1" >> "$log_path"
printf 'path: basename $0 = "%ls"\n' "$(basename "$0")" >> "$log_path"
printf 'path: dirname $0 = "%ls"\n' "$(dirname "$0")" >> "$log_path"
printf 'path: pwd "%ls"\n' "$(pwd)" >> "$log_path"
#export FILL=$(printf "%.1s" "~"{1..36})
#export FMT="\n%.36s\n"
#printf "\n$FMT\n" "lspci $FILL"
export flag_run_autostart_script="y"
export flag_do_dlink_script="y"
export flagi_run_chroot_scripts="y"
export flag_enable_deb_mirror="y"
export xlinux_name="debian"
export addon_conf_dirpath="${addon_path}/conf"
export addon_shellscripts_dirpath="${addon_path}/shell"
export addon_xlinux_dirpath="${addon_path}/${xlinux_name}"
export addon_webpath="${addon_path}/web"
export addon_docs_dirpath="${addon_path}/docs"
export website_path="/var/www"
export addon_bin_dirpath="${addon_path}/bin"
#export addon_website="${website_path}/${xlinux_name}_addon"
export addon_website="${website_path}/${addon_name}"
export chrootscripts_path="${addon_path}/chrootscripts"
export xlinux_tar_path="${addon_bin_dirpath}/debian-wheezy-fullbase-arm.tgz"
export xlinux_chroot_path="/${xlinux_name}"
export xlinux_inst_path="${disk_path}${xlinux_chroot_path}"
export xlinux_inst_filepath="${addon_conf_dirpath}/${xlinux_name}_inst_path"
export do_xlinux_logname="${now_date}_do_xlinux.log"
export do_xlinux_dlink="do_${xlinux_name}_dlink.sh"
export do_xlinux_dlink_path="${addon_shellscripts_dirpath}/${do_xlinux_dlink}"
export do_xlinux_log_path="${log_dir}/${do_xlinux_logname}"
export chrootautostart_file="chroot_autostart.sh"
export chrootautostart_script_path="${addon_shellscripts_dirpath}/${chrootautostart_file}"
export chrootautostart_script_xlinux_path="${xlinux_inst_path}/${chrootautostart_file}"
export postmirror_file="postmirror.sh"
export postmirror_filepath="${addon_shellscripts_dirpath}/${postmirror_file}"
export chrootscripts_path="${addon_path}/chrootscripts"
export backup_log_dirpath="${addon_path}/yyy-logs"

echo "xlp: $xlinux_inst_filepath"
if [ -r "$xlinux_inst_filepath" ]; then
   echo "xlp: $xlinux_inst_filepath"
   export xlinux_inst_path="$(cat "$xlinux_inst_filepath")"
   echo "new path $xlinux_inst_path"
else
   export xlinux_inst_path="${disk_path}${xlinux_chroot_path}"
   echo  "${xlinux_inst_path}" >> "${xlinux_inst_filepath}"
fi

export apt_mirror_path="${xlinux_inst_path}/mirror"
export shell_scripts_path="${addon_path}/shell"
export chrootautostart_file="chroot_autostart.sh"
export apt_mirror_path="${debian_inst_path}/mirror"
export chrootautostart_file_rel="/${chrootautostart_file}" # relative to xlinux
export chroot_autostart_log_path="/${xlinux_name}/${now_date}_do_${xlinux_name}_log.txt"
export chroot_autostart_dirpath="${addon_shellscripts_dirpath}/chroot_autostart"
export chrootautostart_script_path="${addon_shellscripts_dirpath}/${chrootautostart_file}"

# APT_MIRROR
export lighttpd_conf_dirpath="/etc/lighttpd"
export lighttpd_conf_filepath="${lighttpd_conf_dirpath}/lighttpd.conf"
export deb_mirror_path="${xlinux_inst_path}/debianmirror/"
export aptmirror_website_path="${website_path}/${xlinux_name}mirror"
export aptmirror_etc_path="${xlinux_inst_path}/etc/apt/aptmirror"

#<old>
#  export xlinux_root_path="$xlinux_inst_path"
#apt_www_path="${web_path/debian_mirror"
# neu: apt_www_path="${web_path}/debian_mirror/mirror"
# neu: apt_www_path="${web_path}/debian_mirror/mirror"
#apt_www_path="${web_path}/debian_mirror"
#export ${xlinux_name}_conf_filepath="${addon_path}/${$x{linux_name}_conf_filename}"
#export addon_path="$(readlink -f "${atdir}/../")"
#export nas_prog_path="$(readlink -f "${atdir}/../../")"
#export disk_path="$(readlink -f "${atdir}/../../../")"
#export disk_path="/mnt/HD/HD_a2"
#export nas_prog_path="${disk_path}/Nas_Prog"
#export addon_path="${nas_prog_path}/${xlinux_name}"
#</old>
