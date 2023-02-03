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
        [array]$OULayout,
        [String]$LogLocation,
        [String]$LogFile
    )
    process {
        if(!(Get-ADOrganizationalUnit -Filter {Name -like $CompanyName})){
            try{
                New-ADOrganizationalUnit -DisplayName "$($CompanyName)" -Name "$($CompanyName)" -Path $DomDN
                foreach($OU in $OULayout){
                    if(!(Get-ADOrganizationalUnit -Filter {Name -like $OU})){
                        try{
                            New-ADOrganizationalUnit -DisplayName "$($OU)" -Name "$($OU)" -Path "OU=$($CompanyName),$($DomDN)"
                            if(!(Get-ADOrganizationalUnit -Filter {Name -like $OU})){
                                Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(Get-TimeStamp) - Error attempting to create the OU $($OU) under $($CompanyName)"
                                Write-Verbose "Error attempting to create the $($OU) under $($CompanyName)"
                            }
                            else{
                                Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(Get-TimeStamp) - Created the OU $($OU) under OU=$($CompanyName),$($DomDN)"
                                Write-Verbose "Succesfully created the OU $($OU) under OU=$($CompanyName),$($DomDN))"
                            }
                        }
                        catch{
                            Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(Get-TimeStamp) - Error attempting to create the OU $($OU) under OU=$($CompanyName),$($DomDN)"
                            Write-Verbose "Error attempting to create the OU $($OU) under OU=$($CompanyName),$($DomDN)"
                        }
                    }
                    else{
                        Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(Get-TimeStamp) - OU=$($OU),$($CompanyName),$($DomDN) already exists."
                        Write-Verbose "OU=$($OU),$($CompanyName),$($DomDN) already exists."
                    }
                }
            }
            catch{
                Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(Get-TimeStamp) - Error attempting to create a new root OU structure OU=$($CompanyName),$($DomDN)"
                Write-Verbose "Error attempting to create a new root OU structure OU=$($CompanyName),$($DomDN)"
            }
        }
        else{
            Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString "$(Get-TimeStamp) - OU=$($CompanyName),$($DomDN) already exists."
            Write-Verbose "OU=$($CompanyName),$($DomDN) already exists"
        }
    }
}