<#
    .SYNOPSIS
        Get a time stamp for the log file
    .DESCRIPTION
        Get a time date and time to create a custom time stamp
    .EXAMPLE
        None
    .NOTES
        Internal function
#>
[CmdletBinding()]
    param (
    )
    
    process{
        return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    }