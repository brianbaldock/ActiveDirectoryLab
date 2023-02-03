function Save-Output {
    <#
        .SYNOPSIS
            Save the output to a log file
        .DESCRIPTION
            Save the output to a log file
        .EXAMPLE
            Save-Output -LogLocation $LogLocation -LogFile $LogFile -InputString $InputString -ErrorAction stop
        .NOTES
            Internal function
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]$LogLocation,
        [string]$LogFile, 
        [string]$InputString
    )
    process {
        try {
            $InputString | Out-File -FilePath (Join-Path -Path $LogLocation -ChildPath $LogFile) -Encoding UTF8 -Force -Append -ErrorAction Stop
        }
        catch {
            Write-Output "ERROR: writing to: $(Join-Path -Path $LogLocation -ChildPath $LogFile)"
        }
    }
}