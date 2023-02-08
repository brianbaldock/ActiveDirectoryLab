<#
    .SYNOPSIS
        Generate a random password for a user
    .DESCRIPTION
        Generates a random password for the user and outputs the password. This function is borrowed from Armin Reiter: https://arminreiter.com/2021/07/3-ways-to-generate-passwords-in-powershell/
    .EXAMPLE
        New-RandomPassword -length 8 -amountOfNonAlphanumeric = 1
    .NOTES
        Internal function
#>

[CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int] $length,
        [int] $amountOfNonAlphanumeric = 1
    )
    process{
        Add-Type -AssemblyName 'System.Web'
        return [System.Web.Security.Membership]::GeneratePassword($Length, $AmountOfNonAlphanumeric)
    }

