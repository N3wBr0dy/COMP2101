############################
##COMP2101 - Lab 5##########
##Joseph Smith - 200340294##
############################

param ([switch]$SystemReport, [switch]$DisksReport,
       [switch]$NetworkReport)

Import-Module Module200340294

if ($SystemReport -eq $false -and $DisksReport -eq $false -and $NetworkReport -eq $false) {
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