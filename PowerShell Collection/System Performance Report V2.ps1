# CPU Usage Information
$cpuUsage = (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

# Memory Usage Information
$memory = Get-WmiObject Win32_OperatingSystem
$memoryUsage = ($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize * 100

# Drive Space Usage Information
$diskUsage = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } |
    ForEach-Object {
        $usedSpace = $_.Size - $_.FreeSpace
        $usagePercentage = ($usedSpace / $_.Size) * 100
        [PSCustomObject]@{
            Drive = $_.DeviceID
            Usage = "$([Math]::Round($usagePercentage, 2))%"
        }
    }

# Network Bandwidth Usage
$networkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
$networkUsage = Get-NetAdapterStatistics -Name $networkAdapter.Name

# Calculate Network Bandwidth
$receivedBytes = $networkUsage.ReceivedBytes | Measure-Object -Sum | Select-Object -ExpandProperty Sum
$sentBytes = $networkUsage.SentBytes | Measure-Object -Sum | Select-Object -ExpandProperty Sum

# Display Network Bandwidth
$receivedMB = $receivedBytes / 1MB
$sentMB = $sentBytes / 1MB

# Process CPU and Memory Usage Infromation
$processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

# View System Uptime
$uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

# Display Performance Metrics
Write-Host "------- System Performance Metrics -------"
Write-Host "CPU Usage: $cpuUsage%"
Write-Host "Memory Usage: $([Math]::Round($memoryUsage, 2))%"
#Write-Host "------- Disk Space Usage -------:"
$diskUsage | Format-Table -Property Drive, Usage -AutoSize
Write-Host "------- Network Metrics -------"
Write-Host "Network Bandwidth (Received): $receivedMB MB"
Write-Host "Network Bandwidth (Sent): $sentMB MB"
Write-Host "Top 5 Processes by CPU and Memory Usage:"
$processes | Format-Table -Property Name, CPU, WorkingSet -AutoSize
Write-Host "------- System Uptime -------"
Write-Host "$($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"
