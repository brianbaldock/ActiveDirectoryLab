
<#
    .SYNOPSIS
        Create the OU structure for the lab
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
        New-OUStructure -companyName "Lab" -domainDN $domainDN -ouLayout $ouLayout -logLocation $logLocation -logFile $logFile
    .NOTES
        Internal function
#>

[CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
        HelpMessage = "The name of the company to be used for the OU Structure")]
        [String] $companyName,

        [Parameter(Mandatory = $True,
        HelpMessage = "The distinguished name of the domain to be used for the OU Structure")]
        [String] $domainDN,

        [Parameter(Mandatory = $True,
        HelpMessage = "The OU Structure to be used for the lab, formatted as comma seperated string array")]
        [array] $ouLayout,

        [Parameter(Mandatory = $True,
        HelpMessage = "The location to save the log file")]
        [String] $logLocation,

        [Parameter(Mandatory = $True,
        HelpMessage = "The name of the log file")]
        [String] $logFile
    )
    process {
        if(!(Test-OUStructure -ouName $companyName)){
            try{
                New-ADOrganizationalUnit -DisplayName "$($companyName)" -Name "$($companyName)" -Path $domainDN
                foreach($OU in $ouLayout){
                    if(!(Test-OUStructure -ouName $OU)){
                        try{
                            New-ADOrganizationalUnit -DisplayName "$($OU)" -Name "$($OU)" -Path "OU=$($companyName),$($domainDN)"
                            if(Test-OUStructure -ouName $OU){
                                Save-Output -logLocation $logLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Created the OU $($OU) under OU=$($companyName),$($domainDN)"
                                Write-Verbose "Succesfully created the OU $($OU) under OU=$($companyName),$($domainDN))"
                            }
                            else{
                                Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Creation succeeded but unable to find the OU $($OU) under OU=$($companyName),$($domainDN)"
                                Write-Verbose "Creation succeeded but unable to find the OU $($OU) under OU=$($companyName),$($domainDN)"
                            }
                        }
                        catch{
                            Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Error attempting to create the OU $($OU) under OU=$($companyName),$($domainDN)"
                            Write-Verbose "Error attempting to create the OU $($OU) under OU=$($companyName),$($domainDN)"
                        }
                    }
                    else{
                        Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - OU=$($OU),$($companyName),$($domainDN) already exists."
                        Write-Verbose "OU=$($OU),$($companyName),$($domainDN) already exists."
                    }
                }
            }
            catch{
                Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - Error attempting to create a new root OU structure OU=$($companyName),$($domainDN)"
                Write-Verbose "Error attempting to create a new root OU structure OU=$($companyName),$($domainDN)"
            }
        }
        else{
            Save-Output -LogLocation $LogLocation -logFile $logFile -InputString "$(Get-TimeStamp) - OU=$($companyName),$($domainDN) already exists."
            Write-Verbose "OU=$($companyName),$($domainDN) already exists"
        }
    }
