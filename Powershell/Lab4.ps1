##############################
##Powershell Lab4 - COMP2101##
##Joseph Smith - 200340294####
##############################

"SYSTEM INFORMATION REPORT:
"

"------------------------
System Hardware Report
------------------------"

Get-WmiObject win32_computersystem

"------------------------
Operating System Report
------------------------"
Get-WmiObject -Class win32_operatingsystem |
        foreach {
            New-Object -TypeName psobject -Property @{
                OSName = $_.Name
                OSVersion = $_.Version
                }
        } 
        ft -AutoSize OsName,
                     Version

"------------------------
Processor Report
------------------------"

Get-WmiObject -Class win32_processor |
        foreach {
            New-Object -TypeName psobject -Property @{
                Speed = $_.MaxClockSpeed
                NumberOfCores = $_.NumberOfCores
                L1CacheSize = $_.L1CacheSize
                L2CacheSize = $_.L2CacheSize
                L3CacheSize = $_.L3CacheSize
                }
        } 
        ft -AutoSize Speed,
                     NumberOfCores,
                     L1CacheSize,
                     L2CacheSize,
                     L3CacheSize

"------------------------
RAM Report
------------------------"

$totalCapacity = 0

Get-WmiObject -Class win32_physicalmemory |
        foreach {
            New-Object -TypeName psobject -Property @{
                Vendor = $_.Manufacturer
                Model = "data unavailable"
                "Size(MB)" = $_.capacity/1mb
                Bank = $_.banklabel
                Slot = $_.devicelocator
                }
            $totalCapacity += $_.capacity/1mb
        } |
            ft -auto Vendor,
                      Model,
                     "Size(MB)",
                      Bank,
                      Slot

"Total RAM: ${totalCapacity}MB
"

"------------------------
Disk Report
------------------------"

$diskdrives = Get-CIMInstance CIM_diskdrive

foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Vendor=$disk.Manufacturer
                                                               Model=$disk.Model
                                                               "SizeFree(GB)"=$logicaldisks.FreeSpace / 1gb -as [int]
                                                               "SpaceFree(%)"=($logicaldisk.FreeSpace/$logicaldisk.size)*100 -as [int]
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               } | ft
           }
      }
  }

"------------------------
Network Report
------------------------"

Get-ciminstance win32_networkadapterconfiguration |
     Where-Object ipenabled -eq True |
     Select-Object Discription, index, IPAddress, subnetmask, dnsdomain, dnsserver
        ft

"------------------------
Video Card Report
------------------------"

Get-WmiObject -Class win32_videocontroller |
        foreach {
            New-Object -TypeName psobject -Property @{
                Vendor = $_.Name
                Description = $_.Description
                CurrentScreenResolution = ($_.CurrentHorizontalResolution), "X", ($_.CurrentVerticalResolution)
                
                }
        }
#################        
##END OF SCRIPT##
################# 