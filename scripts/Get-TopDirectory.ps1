<#
 .SYNOPSIS
    Gets the top directories by size.

 .PARAMETER Path
    The paths to search for directories. Defaults to the current working directory.

 .PARAMETER Top
    The number of top directories to return. Defaults to 10.

 .EXAMPLE
    Get-TopDirectory -Top 5
    Returns the top 5 largest directories in the current working directory.

 .EXAMPLE
    Get-TopDirectory -Path "C:\Windows" -Top 10
    Returns the top 10 largest directories in "C:\Windows".
#>

#Requires -PSEdition Core
#Requires -Version 7.6

[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path $_ -PathType Container }, ErrorMessage = 'Directory not found: {0}')]
    [string[]] $Path = $PWD.ProviderPath,

    [Parameter()]
    [ValidateRange(1, [int]::MaxValue)]
    [int] $Top = 10
)

begin {
    Set-StrictMode -Version Latest
}

process {
    foreach ($targetPath in $Path) {
        $outputs = [System.Collections.Generic.List[PSCustomObject]]::new()
        $subDirs = Get-ChildItem -Path $targetPath -Directory -ErrorAction Ignore
        foreach ($dir in $subDirs) {
            $sum = Get-ChildItem -Path $dir.FullName -File -Recurse -ErrorAction Ignore | Measure-Object -Property Length -Sum
            $size = $sum -and $sum.Sum ? [long]$sum.Sum : 0L

            $outputs.Add([PSCustomObject]@{
                    Path   = $dir.FullName
                    Size   = $size
                })
        }
        $outputs | Sort-Object -Property Size -Descending | Select-Object -First $Top
    }
}
