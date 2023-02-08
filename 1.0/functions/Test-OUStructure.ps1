<#
    .SYNOPSIS
        Test the OU structure for a company, returns false if not found
    .DESCRIPTION
        Test the OU structure for a company, returns false if not found
    .PARAMETER ouName
        The name of the OU to be tested
    .PARAMETER logLocation
        The location to save the log file
    .PARAMETER logFile  
        The name of the log file
    .EXAMPLE
        Test-OUStructure -ouName $ouName -logLocation $logLocation -logFile $logFile
    .NOTES
        Internal function
#>

[CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
        HelpMessage = "The name of the OU to be tested")]
        [String] $ouName,

        [Parameter(Mandatory = $True,
        HelpMessage = "The location to save the log file")]
        [String] $logLocation,

        [Parameter(Mandatory = $True,
        HelpMessage = "The name of the log file")]
        [String] $logFile
    )
    process {
        if(Get-ADOrganizationalUnit -Filter {Name -like $ouName}){
            Save-Output -logLocation $logLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Found the OU $($ouName)"
            Write-Verbose "Found the OU $($ouName)"
            return $true
        }
        else{
            Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Unable to find the OU $($ouName)"
            Write-Verbose "Unable to find the OU $($ouName)"
            return $false
        }
    }
