<#
    .SYNOPSIS
        Test-CSVPath - Test the path to a specific CSV file, returns false if not found
    .DESCRIPTION
        Test the path to a specific CSV file, returns false if not found
    .PARAMETER csvPath
        The path to the CSV file to be tested
    .PARAMETER logLocation
        The location to save the log file
    .PARAMETER logFile
        The name of the log file
    .EXAMPLE
        Test-CSVPath -csvPath $csvPath -logLocation $logLocation -logFile $logFile
    .NOTES
        Internal function
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $True,
    HelpMessage = "The path to the CSV file to be tested")]
    [String] $csvPath,

    [Parameter(Mandatory = $True,
    HelpMessage = "The location to save the log file")]
    [String] $logLocation,

    [Parameter(Mandatory = $True,
    HelpMessage = "The name of the log file")]
    [String] $logFile
)
process {
    if(Test-Path $csvPath){
        Save-Output -logLocation $logLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Found the CSV file $($csvPath)"
        Write-Verbose "Found the CSV file $($csvPath)"
        return $true
    }
    else{
        Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Unable to find the CSV file $($csvPath)"
        Write-Verbose "Unable to find the CSV file $($csvPath)"
        return $false
    }
}