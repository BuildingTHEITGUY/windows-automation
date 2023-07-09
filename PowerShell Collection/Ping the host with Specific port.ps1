$hostname = "www.aasath.com"
$port = 443

$timeout = 2000  # Timeout in milliseconds

$tcpClient = New-Object System.Net.Sockets.TcpClient

try {
    $tcpClient.SendTimeout = $timeout
    $tcpClient.ReceiveTimeout = $timeout
    $tcpClient.Connect($hostname, $port)
    
    if ($tcpClient.Connected) {
        Write-Host "Ping successful. Port $port is open."
    }
    else {
        Write-Host "Ping unsuccessful. Port $port is closed."
    }
}
catch {
    Write-Host "Ping unsuccessful. Error: $_"
}
finally {
    $tcpClient.Dispose()
}