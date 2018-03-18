#!/bin/bash
# by 8ohmh aka Holger Ohmacht
the_1st_parm="$1"
the_2nd_parm="$2"
echo "$the_1st_parm"
the_user="root\@" # TODO
the_mountp="/nas0020"
the_server="192.168.178.32" # or nas0020.fritzbox etc
#TODO getopt
if [ debug_wanted == "y" ]; then
    debug_opts="--vvv -oLogLevel=Debug"
fi

if [ wireshark_wanted == "y" ]; then
    echo
    #TODO
fi

conffile_path="$HOME/.sshdss.conf"

#case "$the_1st_parm" in
    #"") the_server ;;
#esac

the_default_server="$(cat "$conffile_path")" # TODO
#TODO getopt
if [ -z "$the_1st_parm" ]; then
    printf 'default server: "%s"\n'	"$the_default_server"
	the_server="$the_default_server"
elif [ "$the_1st_parm" == "set" ]; then
    the_server="$the_2nd_parm"
    printf 'The NEW DEFAULT server: "%s"' "$the_server"
    echo "$the_2nd_parm"  > "$conffile_path"
    #the_server="$the_server"
elif [ "$the_1st_parm" == "newdefault" ]; then
	if [ "$the_2nd_parm" != "" ]; then
		printf 'Setting new default server to "%ls"\n\n' "$the_2nd_parm"
		echo "$the_2nd_parm" > "$conffile_path"
	fi
fi

#cmd="ssh -vvv -oLogLevel=Debug -oHostKeyAlgorithms=+ssh-dss ${the_user}'${the_server}'"

cmd="$(printf 'sshfs %ls -oallow_other -oHostKeyAlgorithms=+ssh-dss %ls%ls %ls' "${debug_opts}" "${the_user}" "${the_server}:/" "${the_mountp}")"
printf 'evaluated commands:"%s"\n' "$cmd"
eval "$cmd"
