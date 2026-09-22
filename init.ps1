#Requires -PSEdition Core
#Requires -Version 7.6

Remove-Item "$HOME\.scripts" -Recurse -Force -ErrorAction Ignore
Copy-Item scripts "$HOME\.scripts" -Recurse -Force -ErrorAction Ignore
