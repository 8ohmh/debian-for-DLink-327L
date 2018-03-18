#!/bin/bash
fip="$1"
now_date=$(date +"%Y%m%d_%H%M%S")
echo $fip
cip="$(hostname -I)"
lfn="'${HOME}/tshark_${now_date}_${cip}_${fip}.log"
pcplfn="${HOME}/tshark_${now_date}_${cip}_${fip}.pcap"
#tcmd="tshark -n -Y \"( ip.addr == $cip ) and ! ( ip.addr == $1 )\" | tee \"./${lfn}\""
tcmd="tshark -n -w \"${pcplfn}\""
echo "using cmd: '$tcmd'"
eval "$tcmd" 


