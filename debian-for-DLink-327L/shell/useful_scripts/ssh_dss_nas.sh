#!/bin/bash
# by 8ohmh aka Holger Ohmacht
the_1st_parm="$1"
the_2nd_parm="$2"
echo "$the_1st_parm"
the_user="root@" # TODO
the_server="192.168.178.32" # or nas0020.fritzbox etc

if [ debug_wanted == "y" ]; then
    debug_opts="--vvv -oLogLevel=Debug"
fi

if [ wireshark_wanted == "y" ]; then
    echo
    #TODO
fi

conffile_path="$HOME/.sshdss.conf"

#case "$the_1st_parm" in
#    "") the_server ;;
#esac

# TODO getopt
#a (default)
#a nummer
#a set nummer
#a default 

the_temp_server="$(cat "$conffile_path")" # TODO
#TODO getopt
if [ -z "$the_1st_parm" ]; then
    printf 'last server: "%s"\n'	"$the_temp_server"
    the_server="$the_temp_server"
elif [ "$the_1st_parm" == "set" ]; then
    the_server="$the_2nd_parm"
    printf 'new server: "%s"\n' "$the_server"
    echo "$the_server"  > "$conffile_path"
    the_server="$the_server"
else 
    the_server="$the_temp_server"
fi

printf 'used server: "%ls"\n\n'	"$the_server"

#cmd="ssh -vvv -oLogLevel=Debug -oHostKeyAlgorithms=+ssh-dss ${the_user}'${the_server}'"
cmd="ssh ${debug_opts} -oHostKeyAlgorithms=+ssh-dss ${the_user}${the_server}"
printf 'evaluated commandn:"%s"\n' "$cmd"
eval "$cmd"
