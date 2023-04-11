##Powershell Lab 3 - COMP2101
##Joseph Smith - 200340294

# Get network adapter configuration objects
$adapters = Get-CimInstance -Class Win32_NetworkAdapterConfiguration

# Filter report to only contain enabled adapters
$enabledAdapters = $adapters | Where-Object {$_.IPEnabled -eq $true}

# Select properties for final report
$adapterReport = $enabledAdapters | Select-Object Description, Index, IPAddress, SubnetMask, DNSDomain, DNSServerSearchOrder

# Output put in format table for human readability
$adapterReport | Format-Table -AutoSize
