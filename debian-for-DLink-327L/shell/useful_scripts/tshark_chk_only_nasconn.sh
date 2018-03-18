#!/bin/bash
fip="$1"
now_date=$(date +"%Y%m%d_%H%M%S")
lfnow="tshark_${now_date}_${cip}_${fip}"
lfnwe="${lfnow}.log"
xfnwe="${lfnow}.hex"
echo $fip
cip="$(hostname -I)"
tcmd="tshark -Y '( ip.addr == $cip ) and ( ip.addr == $fip )' "
#| tee -a './${lfnwe}'"
echo "using cmd: '$tcmd'"
eval "$tcmd"
