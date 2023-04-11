############################
##COMP2101 - Lab 5##########
##Joseph Smith - 200340294##
############################

param ([switch]$System, [switch]$Disks, [switch]$Network)

Import-Module Module200340294

if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
"------------------------
System Report:
------------------------"
      get-systemReport
      "
      "
      get-diskReport
      "
      "
      get-netReport
} 
    else {

      if ($System) {
        "System Report:
        "
        get-systemReport
        }

      if ($Disks) {
        get-diskReport
        }

      if ($Network) {
        get-netReport
        }
}

#################
##END OF SCRIPT##
#################