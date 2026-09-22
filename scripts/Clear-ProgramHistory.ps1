<#
.SYNOPSIS
    Clears PowerShell and other program history files.
#>

#Requires -PSEdition Core
#Requires -Version 7.6

[CmdletBinding(SupportsShouldProcess)]
param ()

Set-StrictMode -Version Latest
Remove-Item "$HOME\AppData\Local\nvim-data\shada" -Force -Recurse -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
Remove-Item "$HOME\_viminfo" -Force -Recurse -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
Remove-Item "$HOME\.bash_history" -Force -Recurse -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
Remove-Item "$HOME\.lesshst" -Force -Recurse -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
Remove-Item (Get-PSReadLineOption).HistorySavePath -Force -Recurse -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
Clear-History -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
