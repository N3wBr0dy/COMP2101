#!/bin/bash

###
#Author: Joseph Smith - 200340294
#Script name - netid.sh
#Script purpose - This script generates a per network interface information report
#COMP2101 - Lab4
###

###
#While loop to check conditional arguments
###

while [ $# -gt 0 ]; do
  case "$1" in
    -v)
      echo "Verbose mode enabled"
      verbose="yes"
      ;;
    eth*|enp*|ens*)
      interfaces=$1
      ;;
    *)
      echo "Invalid option: $1 - exiting script"
      exit 1
      ;;
  esac
  shift
done

###
# Once per host report
###

[ "$verbose" = "yes" ] && echo "Gathering host information"

my_hostname="$(hostname)"

[ "$verbose" = "yes" ] && echo "Identifying default route"

default_router_address=$(ip r s default| awk '{print $3}')
default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"

external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####


###
# Per-interface report
###

###
#If loop to check if user selected an interface
###

if [ -z "$interfaces" ]; then
  interfaces=$(ip -o link show | awk -F': ' '!/lo/{print $2}')
else
  echo "Network interface $interfaces selected"
fi

[ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interfaces"

###
#This loops through each interface and generates a report
###

for interface in $interfaces
do

[ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"

ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"

network_address=$(ip route list dev $interface scope link|cut -d ' ' -f 1)
network_number=$(cut -d / -f 1 <<<"$network_address")
grep -q "$network_number" /etc/networks || $(echo "COMP2101-$interface $network_number" |sudo tee -a /etc/networks)
network_name=$(getent networks $network_number|awk '{print $1}')

###
#Loops to check if there is network information in the variables
###

if [ -z "$ipv4_address" ]; then
  ipv4_address="Information unavailable"
  ipv4_hostname="Information unavailable"
fi

if [ -z "$network_address" ]; then
  network_address="Information unavailable"
fi

if [ -z "$network_number" ]; then
  network_name="Information unavailable"
fi

###
#This section is to organize output
###

cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
done

###
# End of per-interface report
###

###
#End of script
###
