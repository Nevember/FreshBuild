function Search-FreshBuild {
    [CmdletBinding()]
    param(
        [string]$jsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json",
        [string]$Exclude = $null,
        [string]$Include = $null,
        [switch]$Search = $false
    )

    Write-Host "Seach: "
    if ($Include) { Write-Host ('Include: {0}' -f $Include) }
    if ($Exclude) { Write-Host ('Exclude: {0}' -f $Exclude) }   
}