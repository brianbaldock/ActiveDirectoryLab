function New-OUStructure {
    <#
        .SYNOPSIS
            Create the OU structure for the lab
        .DESCRIPTION
            Tests for existance of an OU Structure and generates a pre-formatted OU structure for the lab if none is found.
        .PARAMETER CompanyName
            The name of the company to be used for the OU Structure
        .PARAMETER DomDN
            The DN of the domain to be used for the OU Structure
        .PARAMETER OULayout
            The OU Structure to be used for the lab, formatted as comma seperated string array
        .PARAMETER LogLocation
            The location to save the log file
        .EXAMPLE
            New-OUStructure -CompanyName "Lab" -DomDN $DomDN -OULayout $OULayout -LogLocation $LogLocation -LogFile $LogFile
        .NOTES
            Internal function
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]$CompanyName,
        [String]$DomDN,
        [String]$OULayout,
        [String]$LogLocation,
        [String]$LogFile
    )
    process {
        if(!(Get-ADOrganizationalUnit -Filter {Name -like $CompanyName})){
            try{
                New-ADOrganizationalUnit -DisplayName "$($CompanyName)" -Name "$($CompanyName)" -Path $DomDN.DistinguishedName
                foreach($OU in $OULayout){
                    if(!(Get-ADOrganizationalUnit -Filter {Name -like $OU})){
                        try{
                            New-ADOrganizationalUnit -DisplayName "$($OU)" -Name "$($OU)" -Path "OU=$($CompanyName),$($DomDN.DistinguishedName)"
                            if!(Get-ADOrganizationalUnit -Filter {Name -like $OU}){
                                .\Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(.\Get-TimeStamp.ps1) - Error attempting to create the OU $($OU) under $($CompanyName)"
                                Write-Output "Error attempting to create the $($OU) under $($CompanyName)"
                            }
                            else{
                                .\Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(.\Get-TimeStamp.ps1) - Created the OU $($OU) under $($CompanyName)"
                                Write-Output "Succesfully created the OU $($OU) under $($CompanyName)"
                            }
                        }
                        catch{
                            .\Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(.\Get-TimeStamp.ps1) - Error attempting to create the OU $($OU) under $($CompanyName)"
                            Write-Output "Error attempting to create the OU $($OU) under $($CompanyName)"
                        }
                    }
                }
            }
            catch{
                .\Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(.\Get-TimeStamp.ps1) - Error attempting to create a new root OU structure based on $($CompanyName)"
                Write-Output "Error attempting to create a new root OU structure based on $($CompanyName)"
            }
        }
    }
}