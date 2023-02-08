
<#
    .SYNOPSIS
        Create the users according to CSV file
    .DESCRIPTION
        Tests for existance of an OU Structure and generates a pre-formatted OU structure for the lab if none is found.
    .PARAMETER companyName
        The name of the company to be used for the OU Structure
    .PARAMETER domainDN
        The DN of the domain to be used for the OU Structure
    .PARAMETER ouLayout
        The OU Structure to be used for the lab, formatted as comma seperated string array
    .PARAMETER logLocation
        The location to save the log file
    .EXAMPLE
        Invoke-UserCreation -companyName $companyName -domainDN $domainDN -logLocation $logLocation -logFile $logFile
    .NOTES
        Internal function
    #>

[CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, 
        HelpMessage = "The name of the company to be used for the OU Structure")]
        [String] $companyName,

        [Parameter(Mandatory = $True)]
        [String] $domainDN,
        [Parameter(Mandatory = $True)]
        [array] $userList,
        [Parameter(Mandatory = $True)]
        [String] $logLocation,
        [Parameter(Mandatory = $True)]
        [String] $logFile
    )
    process {
        if(!(Test-OUStructure -ouName $companyName)){
            try{
                New-OUStructure -companyName $companyName -domainDN $domainDN -ouLayout $ouLayout -logLocation $LogLocation -logFile $logFile
            }
            catch{
                Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Launching New-OUStructure failed with the following error: $($_.Exception.Message) Source: Invoke-UserCreation"
            }
        }
        else{
            Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - OU Structure exists for $($companyName). Commencing users creation. Source: Invoke-UserCreation"
        }
    }
