#!/bin/bash
#
# Script adapted from 'wireless_script' originally written by:
# Ubuntu Forums members - Wild Man, Krytarik
# 
# This script gathers the infos necessary for troubleshooting a wireless
# connection and saves them in a text file, wrapping it in an archive if it
# exceeds the size limit of 19.5 kB for .txt files on the Ubuntu Forums.
#
############################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

NOW_DATE=$(date +"%Y%m%d%H%M%S")
FILEBASE="wireless-info_${NOW_DATE}"
MODMATCHES="(air|ar5|ath[^3]|carl|at7|ipw|iwl|rt[23567l]|r(818|871)|8192[cd]|r92su|ssb|wl|b43|bcma|brcm|ndis|eth[1-9]|firm|etwork)[^[:punct:] ]*"

clear
printf "\n        **** PLEASE WAIT WHILE THE SCRIPT GENERATES THE REPORT ****
  
  If this takes more than 1 minute, you may abort the script by pressing
  \"Ctrl+Z\" on your keyboard.
  
  (Type your Login Password when asked, then press 'Enter')\n\n"

exec 3>&1 4>&2
exec 1> $FILEBASE.tmp 2> /dev/null
if [ "$?" != "0" ]; then
    printf "\nCould not write target file \"$FILEBASE.txt\", aborting.\n\n"
    exit 1
fi

FILL=$(printf "%.1s" "~"{1..36})
FMT="\n%.36s\n"

## Wireless-Info START
printf "\n\t======== Wireless-Info START ========\n"


printf "$FMT\n" "System-Info $FILL"
printf "$(uname -nrm),  $(lsb_release -dcs | sed '/$/ {N; s:\n:, :}')\n"
CPU=$(grep -m1 'model name' /proc/cpuinfo); CPU=${CPU#*: }
MEM=$(free -m | awk 'NR==2 {print $2}')
printf "\nDate   : %s (YYYYMMDD)" "$(date +"%Y%m%d")"
printf "\nCPU    : $CPU\nMemory : $MEM MB\nUptime :"
uptime

## lspci
printf "\n$FMT\n" "lspci $FILL"
lspci -nnk | grep -iA2 net

## lsusb
printf "\n$FMT\n" "lsusb $FILL"
lsusb

## PCMCIA Card Info
printf "\n$FMT\n" "PCMCIA Card Info $FILL"
pccardctl info

## iwconfig
printf "\n$FMT\n" "iwconfig $FILL"
iwconfig

## rfkill
printf "\n$FMT\n" "rfkill $FILL"
RFKILL=$(rfkill list all)
if [ "$RFKILL" ]; then
	WIDTH=$(grep ^[0-9] <<< "$RFKILL" | wc -L)
	printf "%-*s  %s  %s" $WIDTH "      Interface" "Soft blocked" "Hard blocked"
	while read LINE; do
		if [ $(grep -o ^[0-9] <<< "$LINE") ]; then
			printf "\n%-$WIDTH.40s  " "$LINE"
		elif [ $(grep -o '^Soft' <<< "$LINE") ]; then
			printf "%-14s" "    ${LINE#*: }"
		else printf "%s" "    ${LINE#*: }"
		fi
	done <<< "$RFKILL"
fi

## lsmod
printf "\n\n$FMT\n" "lsmod $FILL"
LSMOD=$(lsmod | egrep "(^|[[:punct:] ])(${MODMATCHES}|wmi|ideapad)([[:punct:] ]|$)")
printf "$LSMOD\n"

## module parameters
printf "\n$FMT" "module parameters $FILL"
MODULES=$(awk '{print $1}' <<< "$LSMOD")
	while read LINE
	do
		if [ -d /sys/module/$LINE/parameters ]; then
			printf "\n%-12s %4s: " "$LINE" "($(ls -1 /sys/module/$LINE/parameters | wc -l))"
			PARMS=$(grep -H [[:graph:]] /sys/module/"$LINE"/parameters/*)
			PARMS=$(while read i; do printf "${i##*/} | "; done <<< "$PARMS")
			PARMS=${PARMS//:/=}; PARMS=${PARMS% | }
			printf "$PARMS"
		fi
	done <<< "$MODULES" | sort -d

## nm-tool
printf "\n$FMT\n" "nm-tool $FILL"
NMTOOL=$(nm-tool | egrep -v '^Net|^$|^  (Cap|IPv|Wir|  Car)' | \
		sed -r '/^- Device:/ s/([[:alnum:]][[:alnum:]]:){5}[[:alnum:]][[:alnum:]]/<BT Device>/')
F1=$(($(grep -o '^- Device: .* -' <<< "$NMTOOL" | wc -L)-10)); if [ $F1 -lt 16 ];then F1=16; fi
F2=$(($(grep '^  Type' <<< "$NMTOOL" | wc -L)-19)); if [ $F2 -lt 6 ];then F2=6; fi
F3=$(($(grep '^  Driver' <<< "$NMTOOL" | wc -L)-19)); if [ $F3 -lt 8 ];then F3=8; fi
F4=$(($(grep '^  State' <<< "$NMTOOL" | wc -L)-19)); if [ $F4 -lt 8 ];then F4=8; fi
#F4=14;
F5=9; F6=11; F7=11; F8=14 # State, Default, MAC ID, Speed, WEP/WPA/WPA2
WIDTH=$((F1+F2+F3+F4+F5+F6+F7+F8+7))
P1=$(printf '%0.1s' "="{1..60})
P2=$(printf '%0.1s' "-"{1..160})

FORMAT="%-${F1}s|%-${F2}s|%-${F3}s|%-${F4}s|%-${F5}s|%-${F7}s|%-${F8}s|%-${F6}s"
HEAD=$(printf $FORMAT " Interface & ID" " Type" " Driver" " State" " Default" " Speed" " Support" " HW Addr")
L1=$(printf '%.*so%.*so%.*so%.*so%.*so%.*so%.*so%.*s' $F1 $P1 $F2 $P1 $F3 $P1 $F4 $P1 $F5 $P1 $F7 $P1 $F8 $P1 $F6 $P1)
L2=$(printf '%.*s+%.*s+%.*s+%.*s+%.*s+%.*s+%.*s+%.*s' $F1 $P2 $F2 $P2 $F3 $P2 $F4 $P2 $F5 $P2 $F7 $P2 $F8 $P2 $F6 $P2)

printf "$(head -1 <<< "$NMTOOL")\n"
NMTOOL=$(tail -n +2 <<< "$NMTOOL")
printf -- "$L1\n$HEAD\n$L1"

DEVRANGES=$(printf "$(sed -n '/^- Device/ =' <<< "$NMTOOL")\n$(($(wc -l <<< "$NMTOOL")+1))");
PREV=0
while read CURR; do
	if [ $PREV -eq 0 ]; then PREV=$CURR
	else
		RANGE=$(sed -n "$PREV,$((CURR - 1)) p" <<< "$NMTOOL")
		SUBRANGE1=$(grep 'Freq .* Rate .* Strength ' <<< "$RANGE")
		SUBRANGE2=$(egrep '^    (Address|Prefix|Gateway|DNS)' <<< "$RANGE")
		
		ID=$(grep '^- Dev' <<< "$RANGE"); ID=${ID#*: }; ID=${ID% -*}
		TYPE=$(grep '^  Type' <<< "$RANGE"); TYPE=${TYPE##*    }
		DRVR=$(grep '^  Driver' <<< "$RANGE"); DRVR=${DRVR##*    }
		STATE=$(grep '^  State' <<< "$RANGE"); STATE=${STATE##*    }
		DEF=$(grep '^  Default' <<< "$RANGE"); DEF=${DEF##*    }
		HW=$(grep '^  HW' <<< "$RANGE"); HW=${HW##*    }
		SPEED=$(grep '^    Speed' <<< "$RANGE"); SPEED=${SPEED##*    }
		WEP=$(grep '^    WEP' <<< "$RANGE"); WEP=${WEP##* }; WEP=${WEP/yes/WEP/}; WEP=${WEP/no/}
		WPA=$(grep '^    WPA ' <<< "$RANGE"); WPA=${WPA##* }; WPA=${WPA/yes/WPA/}; WPA=${WPA/no/}
		WPA2=$(grep '^    WPA2 ' <<< "$RANGE"); WPA2=${WPA2##* }; WPA2=${WPA2/yes/WPA2}; WPA2=${WPA2/no/}
		
		printf "\n$FORMAT" " $ID" " $TYPE" " $DRVR" " $STATE" " $DEF" " $SPEED" " $WEP$WPA$WPA2" " $HW"
		if [ "$SUBRANGE1" ]; then
			printf "\n\n$SUBRANGE1"
		fi
		if [ "$SUBRANGE2" ]; then
			SUBRANGE2=${SUBRANGE2//    Address/\\n    Address}
			printf "\n$SUBRANGE2"
		fi
		printf "\n$L2"
		PREV=$CURR
	fi
done <<< "$DEVRANGES"

## NetworkManager.state
printf "\n\n$FMT" "NetworkManager.state $FILL"
cat /var/lib/NetworkManager/NetworkManager.state

## NetworkManager.conf
printf "\n$FMT\n" "NetworkManager.conf $FILL"
grep -v '^#' /etc/NetworkManager/NetworkManager.conf
if [ -f /etc/NetworkManager/nm-system-settings.conf ]; then
    printf "nm-system-settings.conf (used up to 10.04):\n"
    grep -v '^#' /etc/NetworkManager/nm-system-settings.conf
fi

## NM-Connection-Profiles
printf "\n$FMT" "NM WiFi Profiles $FILL"
CON_PROFILES=$(sudo grep -hA40 -B4 '^type=802-11-wireless' /etc/NetworkManager/system-connections/* |\
	egrep '^id=|^permissions|^autoconnect|^ssid|^mac-address|^bssid|^mtu|ipv4|ipv6|^method|ca-cert')
CON_PROFILES=$(while read LINE; do
		if [ "$(grep '^id=' <<< "$LINE")" ]; then
			ID=${LINE##id=}
			printf "\n%-20s : " "$ID"
		else
			echo -e "$LINE \c"
		fi
	done <<< "$CON_PROFILES")
CON_PROFILES=$(sed -r	's/( permissions=[[:graph:]]*)/ |&/; s/ autoconnect=[a-z]*/ |&/; s/ mac-address=[[:graph:]]*/ |&/
			s/ bssid=[[:graph:]]*/ |&/; s/ mtu=[0-9]*/ |&/; s/ \[(ipv[46])\] method(=[a-z]*)/ | \1\2/g
			s/ [[:graph:]]*a-cert[[:graph:]]*/ |&/' <<< "$CON_PROFILES")
CON_PROFILES=$(sed -r 's/(\| .*) (ssid=[[:graph:]]* )/\2\1 /' <<< "$CON_PROFILES")
printf "$CON_PROFILES\n"

## interfaces
printf "\n$FMT\n" "interfaces $FILL"
sed -r 's/wpa-psk [[:graph:]]+/wpa-psk <WPA key removed>/' /etc/network/interfaces

## resolv.conf
printf "$FMT\n" "resolv.conf $FILL"
grep -v '^#' /etc/resolv.conf

## Routes & Ping
printf "\n$FMT\n" "Routes & Ping $FILL"
ROUTE=$(route -n)
printf "$ROUTE\n"
GW=$(awk 'NR==3 {print $2}' <<< "$ROUTE")
if [ "$GW" != "0.0.0.0" ]; then
	ping -nqw4 -c2 "$GW" | sed '/^PING/ d'
	if [ -e /run/nm-dns-dnsmasq.conf ]; then
		DNS=$(sed -n 's:^server=::p' /run/nm-dns-dnsmasq.conf)
	else
		DNS=$(sed -n 's:^nameserver ::p' /etc/resolv.conf)
	fi
	if [ "$DNS" ]; then
		while read LINE; do
			ping -nqw2 -c2 "$LINE" | sed '/^PING/ d'
		done <<< "$DNS"
	fi
fi

## iw reg get
printf "\n$FMT\n" "iw reg get $FILL"
printf "$(locale | sed -n '/IDENT/ s/LC.*=\(.*\)/(Region : \1)/p')\n"
iw reg get

## iwlist chan
printf "\n$FMT\n" "iwlist chan $FILL"
CHAN=$(iwlist chan)
START=""; BUFF1=""; BUFF2="";FLAG=0; BUFFLEN=0
while read LINE; do
	CH=${LINE#*Channel 0}; CH=${CH#*Channel }; CH=${CH% : *}
	if [ ${#LINE} -gt 25 ]; then
		if [ -z "$START" ]; then printf "$LINE\n"
		elif [ $FLAG -eq 0 ]; then printf "          $START%s\n\n          $LINE\n" " - $BUFF1"
		else printf "          $START\n\n          $LINE\n"
		fi
	elif [ -z "$START" ]; then START=${LINE/: /(}; START=${START/z/z)}; COUNT=$((CH + 1))
	elif [ $CH -eq $COUNT ]; then BUFF1=${LINE#*Channel }; BUFF1=${BUFF1/: /(}; BUFF1=${BUFF1/z/z)}; COUNT=$((COUNT + 1)); FLAG=0
	elif [ $FLAG -eq 0 ]; then printf "          $START%s\n" " - $BUFF1"; START=${LINE/: /(}; START=${START/z/z)}; COUNT=$((CH + 1)); FLAG=1
	else printf "          $START\n"; START=${LINE/: /(}; START=${START/z/z)}; COUNT=$((CH + 1))
	fi
	BUFFLEN=${#LINE}
done <<< "$CHAN"
if [ $BUFFLEN -lt 26 ];then printf "          $START%s\n" " - $BUFF1"; fi

## iwlist scan
printf "\n$FMT\n" "iwlist scan $FILL"
IWLIST=$(if [ -t 0 ]; then
    sudo iwlist scan || echo "Aquiring of root rights failed."
elif [ -x /usr/bin/gksudo ]; then
    gksudo iwlist scan || echo "Aquiring of root rights failed."
elif [ -x /usr/bin/kdesudo ]; then
    kdesudo iwlist scan || echo "Aquiring of root rights failed."
else
    echo "No way to aquire root rights found."
fi | grep -v 'IE: Unknown: ') # Filtered out uninteresting lines from the output

if [ "$IWLIST" ]; then
	printf "$IWLIST\n"
fi

## blacklist
printf "\n$FMT" "blacklist $FILL"
for CONFFILE1 in /etc/modprobe.d/*.conf; do
    if [ "$(egrep -v 'alsa-base|blacklist-(firewire|framebuffer|modem|oss|watchdog)|fglrx|nvidia|fbdev|bumblebee' <<< $CONFFILE1)" ]; then
        # filter out default blacklist entries
        BLACKLIST=$(grep '^blacklist' $CONFFILE1 |\
        egrep -v 'evbug|usb(kbd|mouse)|eepro|de4x5|eth1394| snd_|i2c_|prism54|bcm43xx|garmin|asus_acpi|pcspkr|amd76x')
        if [ "$BLACKLIST" ]; then
            printf "\n[%s]\n%s\n" $CONFFILE1 "$BLACKLIST"
        fi
    fi
done

## modinfo
printf "\n$FMT\n" "modinfo $FILL"
MODULNAMES=$(grep -v sparse <<< "$LSMOD" | awk '{print $1}')
for MODULE in $MODULNAMES; do
    printf "[$MODULE]\n"
    modinfo $MODULE | egrep -i 'filename|version:|firmware|depends|parm:'
    echo
done

## udev rules
printf "$FMT" "udev rules $FILL"
egrep '^(#.*device|[^#]|$)' /etc/udev/rules.d/70-persistent-net.rules



## Custom files/entries
printf "\n$FMT\n" "Custom files/entries $FILL"
  # extra modules in /etc/modules
if [ $(egrep -v '^#|^$|^lp|^rtc|^vhba' /etc/modules | wc -l) -eq 0 ]; then
	MODFLAG=0
	STATUS="Default"
else
	MODFLAG=1
	STATUS="Not Default"
fi
printf "%-20s: $STATUS\n" "/etc/modules"

  # extra entries in /etc/rc.local
if [ $(egrep -v '^#|^exit 0|^$' /etc/rc.local | wc -l) -eq 0 ]; then
	RCFLAG=0
	STATUS="Default"
else
	RCFLAG=1
	STATUS="Not Default"
fi
printf "%-20s: $STATUS\n" "/etc/rc.local"

  # extra files in /etc/modprobe.d
CONFFILE2=$(egrep -vl '^#|^black|alias|^$' /etc/modprobe.d/* | cut -d '/' -f 4- | egrep -v '^vmw|^alsa|^oss-')
if [ -z "$CONFFILE2" ]; then
	MODCONFFLAG=0
	STATUS="Default"
else
	MODCONFFLAG=1
	STATUS="Not Default"
fi
printf "%-20s: $STATUS\n" "/etc/modprobe.d"

  # extra files in /etc/pm/(config.d|power.d|sleep.d)
PMFLAG=0
if [ "$(ls /etc/pm/config.d/)" ]; then PMFLAG=1; PCONFLAG=1
else PCONFLAG=0	
fi
if [ "$(ls /etc/pm/power.d/)" ]; then PMFLAG=1; PPOWFLAG=1
else PPOWFLAG=0
fi
SLEEP_D=$(find -L /etc/pm/sleep.d -type f | egrep -v '10_grub-common|10_unattended-upgrades|novatel_3g')
if [ "$SLEEP_D" ]; then PMFLAG=1; PSLFLAG=1
else PSLFLAG=0
fi

if [ $PMFLAG -eq 0 ]; then STATUS="Default"
else STATUS="Not Default"
fi
printf "%-20s: $STATUS\n" "/etc/pm/(cnf|pw|sl)"

  # Parsing Non-Default files/entries
if [ $MODFLAG -eq 1 ]; then
	printf "\n[/etc/modules]\n"
	egrep -v '^#|^$|^lp|^rtc|^vhba' /etc/modules
fi
if [ $RCFLAG -eq 1 ]; then
	printf "\n[/etc/rc.local]\n"
	egrep -v '^#|^$' /etc/rc.local
fi
if [ $MODCONFFLAG -eq 1 ]; then
	printf "\n[/etc/modprobe.d]\n"
	#sed 's/:/ : /' <<< "$CONFFILE2"
	for i in $CONFFILE2; do
		LINES=$(egrep -v '^#|^$' /etc/modprobe.d/"$i")
		if [ $(wc -l <<< "$LINES") -lt 2 ]; then
			printf "%-18s: %s\n" "$i" "$LINES"
		else
			 printf "%-18s: " "$i"
			 sed -n '1 p; 2,$ s/.*/                    &/p' <<< "$LINES"
		fi
	done
fi
if [ $PMFLAG -eq 1 ]; then
	# /etc/pm/config.d/*
	if [ $PCONFLAG -eq 1 ]; then
		for PMCONFIG in /etc/pm/config.d/*; do
			if [ -x "$PMCONFIG" ]; then
				printf "\n[$PMCONFIG] [executable]\n"
			else
				printf "\n[$PMCONFIG]\n"
			fi
			cat "$PMCONFIG"
		done
	fi
	# /etc/pm/power.d/*
	if [ $PPOWFLAG -eq 1 ]; then
		for PMPOWER in /etc/pm/power.d/*; do
			if [ -x "$PMPOWER" ]; then
				printf "\n[$PMPOWER] [executable]\n"
			else
				printf "\n[$PMPOWER]\n"
			fi
			cat "$PMPOWER"
		done	
	fi
	# /etc/pm/sleep.d/*
	if [ $PSLFLAG -eq 1 ]; then
		for PMSLEEP in $SLEEP_D; do
			if [ -x "$PMSLEEP" ]; then
				printf "\n[$PMSLEEP] [executable]\n"
			else
				printf "\n[$PMSLEEP]\n"
			fi
			cat "$PMSLEEP"
		done
	fi
fi

## Kernel boot line
printf "\n$FMT\n" "Kernel boot line $FILL"
cat /proc/cmdline

## dmesg
printf "\n$FMT\n" "dmesg $FILL"
dmesg | egrep "[[:punct:] ]${MODMATCHES}[[:punct:] ]|net|ra[0-4]|wmi"

printf "\n\t======== Done ========\n\n"
exec 1>&3 3>&-
exec 2>&4 4>&-

# filter MAC IDs of interfaces
MAC_FILTER_IFACES=$(sed -r '/NAME="/ !d; s/.*(([[:alnum:]]{2}:){5}[[:alnum:]]{2}).*NAME="(.*)"/s\/\1\/\<MAC \3\>\/I/' /etc/udev/rules.d/70-persistent-net.rules)

# filter MAC IDs from iwlist scan
MAC_FILTER_IWLIST=$(sed -rn '/Cell / p; /ESSID:"/ p' <<< "$IWLIST" | sed -r '/Cell / N; {s/.* Cell ([[:digit:]]{2}).*(([[:alnum:]]{2}:){5}[[:alnum:]]{2}).*ESSID:"(.*)"/s\/\2\/\<MAC C-\1 \4\>\/I/}')

# filter MAC IDs from nm-tool cache
MAC_FILTER_NMTOOL=$(str_prev=""; loop=1
	sed -rn '/, (([[:alnum:]]{2}:){5}[[:alnum:]]{2}), / p' <<< "$NMTOOL" | sort |\
	sed -r 's/ *([[:graph:]].*): .* (([[:alnum:]]{2}:){5}[[:alnum:]]{2}), .*/s\/\2\/\<MAC \1\>\/I/' |\
	while read LINE; do
		if [ "$(echo $LINE | cut -d " " -f 2)" = "$str_prev" ]; then
			let loop=loop+1
		else loop=1
		fi
		sed "s/\(.*MAC \)\(.*\)\(>.\)/\1C-NA \2 $loop\3/" <<< "$LINE"
		str_prev=$(echo "$LINE" | cut -d " " -f 2)
	done)

# Original filter for leftover MAC IDs
MAC_FILTER_GENERAL='s/([[:alnum:]][[:alnum:]]:){5}[[:alnum:]][[:alnum:]]/<MAC ID removed>/'

RESULTS=$(sed -r "$MAC_FILTER_IFACES" $FILEBASE.tmp)
RESULTS=$(sed -r "$MAC_FILTER_IWLIST" <<< "$RESULTS")
RESULTS=$(sed -r "$MAC_FILTER_NMTOOL" <<< "$RESULTS")
sed -r "$MAC_FILTER_GENERAL" <<< "$RESULTS" > $FILEBASE.txt
rm $FILEBASE.tmp

LINE=$(printf "%0.1s" "#"{1..72})
if [ $(stat -c %s $FILEBASE.txt) -gt 19968 ]; then
	tar -czf $FILEBASE.tar.gz $FILEBASE.txt
    rm -f $FILEBASE.txt
    FILENAME="$FILEBASE.tar.gz"
else
	FILENAME="$FILEBASE.txt"
fi
MSG="    DONE! All results saved in -

		 File Name: \t\"$FILENAME\" \n\t\t Directory: \t\"$(pwd)\"

    Please upload the above file or its contents where you are seeking help.

    ------------------------------------------------------------------------
    NOTE: Although we have taken full precaution to filter out all sensitive
          information, it is recommended to take a look at the file yourself
          to be double sure that it contains no sensitive data.
    ------------------------------------------------------------------------"
printf "\n\n    $LINE\n\n$MSG\n\n    $LINE\n\n\n\n"

