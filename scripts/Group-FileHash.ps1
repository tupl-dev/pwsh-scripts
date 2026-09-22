<#
.SYNOPSIS
    Groups files with the same hash.

.PARAMETER Path
    Specifies the paths to the files to hash.

.PARAMETER Algorithm
    Specifies the hashing algorithm to use on the file. Defaults to 'SHA256'.
    Posible algorithms are 'SHA1', 'SHA256', 'SHA384', 'SHA512' and 'MD5'.

.PARAMETER Unique
    Specifies to only output the files that do not match any other file.

.PARAMETER Grouped
    Specifies to only output the files that match other files.

.EXAMPLE
    Get-ChildItem -File | Group-FileHash
    Groups the hash for all files under the current directory.

.EXAMPLE
    Get-ChildItem -File | Group-FileHash -Unique
    Groups the hash for all files under the current directory, but only output files that do not match any other file.
#>

#Requires -PSEdition Core
#Requires -Version 7.6

[CmdletBinding(DefaultParameterSetName = 'ShowAll')]
param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'File not found: {0}')]
    [string[]] $Path,

    [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5')]
    [string] $Algorithm = 'SHA256',

    [Parameter(ParameterSetName = 'ShowUnique')]
    [switch] $Unique,

    [Parameter(ParameterSetName = 'ShowGrouped')]
    [switch] $Grouped
)

begin {
    Set-StrictMode -Version Latest
    $outputs = [System.Collections.Generic.List[PSCustomObject]]::new()
}

process {
    foreach ($item in $Path) {
        try {
            $resolved = Resolve-Path -LiteralPath $item -ErrorAction Stop
            if (Test-Path -LiteralPath $resolved.Path -PathType Container) {
                continue
            }

            $hash = Get-FileHash -LiteralPath $resolved.Path -Algorithm $Algorithm -ErrorAction Stop
            $outputs.Add([PSCustomObject]@{
                    Path = $hash.Path
                    Hash = $hash.Hash
                })
        }
        catch {
            $PSCmdlet.WriteError($_)
        }
    }
}

end {
    $groups = $outputs | Group-Object -Property Hash
    $groupId = 0
    foreach ($group in $groups) {
        $groupId++
        if ($Unique -and !($group.Count -eq 1)) {
            continue
        }
        if ($Grouped -and ($group.Count -eq 1)) {
            continue
        }

        foreach ($item in $group.Group) {
            [PSCustomObject]@{
                Group = $groupId
                Path  = $item.Path
                Hash  = $group.Name
            }
        }
    }
}
