#!/bin/bash

#COMP2101 - Lab 1
#Author: Joseph Smith - 200340294
#Date February 1st, 2023

#This is just an intro message to the user

echo "System info for $(hostname -f):"

#This command is to display the FQDN

echo The FQDN of this machine is: $(hostname -f)

#This command is to display operating system name and version

echo The operating system and version is: $(hostnamectl | grep -w 'Operating System:'| sed 's/^.*: //')

#This command is to display the IP addresses that don't start in 127 (a little ugly but it works

echo "The IP Adresses for this machine are (if blank there are no addresses that do not start with 127): "$(hostname -i | grep -v '^127')

#These commands are to show usage information for the root filesystem. Quite rough but I'm still learning :)

cd
echo Available space on the root filesystem: 
df . -l -H

#This is the end of the script. exit not needed but why not, it is fun :)
echo "Good Bye! :)"
exit
