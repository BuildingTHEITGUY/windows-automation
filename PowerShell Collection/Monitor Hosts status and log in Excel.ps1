# Import the required module for Excel manipulation
Import-Module -Name "ImportExcel"

# Define the list of hosts
$hosts = "ip", "hostname1", "www.google.com"

# Create an empty array to store the results
$results = @()

# Loop through each host and check the status
foreach ($myhost in $hosts) {
    $pingResult = Test-Connection -ComputerName $myhost -Count 1 -Quiet

    $status = if ($pingResult) { "Up" } else { "Down" }

    # Create a custom object with host and status
    $result = [PSCustomObject]@{
        Host = $myhost
        Status = $status
    }

    # Add the result to the results array
    $results += $result
}

# Path to the Excel file
$excelFile = "F:\Host Monitor\results.xlsx"

# Check if the Excel file exists
if (Test-Path $excelFile) {
    # If the file exists, update the existing worksheet with the results
    $results | Export-Excel -Path $excelFile -WorksheetName "Status" -AutoSize -Append
}
else {
    # If the file doesn't exist, create a new worksheet and save the results
    $results | Export-Excel -Path $excelFile -WorksheetName "Status" -AutoSize
}