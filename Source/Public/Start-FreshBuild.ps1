function Start-FreshBuild {
    [CmdletBinding()]
    param(
        [string]$jsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json",
        [string]$Exclude = $null,
        [string]$Include = $null,
        [switch]$Search = $false
    )

    Push-Location

    try {
        $defaultJsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json";

        if (-not (Test-Path $jsonConfig)) {
            if ($hsonConfig -eq $defaultJsonConfig) {
                Set-Location (Get-Module -Name "FreshBuild").Path
                New-Item $env:USERPROFILE/.freshBuild -ItemType Directory
                New-Item $env:USERPROFILE/.freshBuild/.vs_answers -ItemType Directory
                Copy-Item en-US/Content/FreshInstall.json -Destination $defaultJsonConfig
                Copy-Item en-US/Content/.vs_answers/* -Destination $env:USERPROFILE/.freshBuild/.vs_answers
            } else {
                return -1;
            }
        }

        $items = Get-Content $jsonConfig | ConvertFrom-Json

        if (-not $Search) {
            $downloadFolder = "$env:USERPROFILE/.freshBuild/downloads"

            if (-not (Test-Path $downloadFolder)) {
                New-Item $downloadFolder -ItemType Directory
            }

            foreach ($item in $items) {
                if (-not ($item -is [string])) {
                    if ((-not($Exclude -and ($item.name -Match $Exclude))) -and 
                        (($null -eq $Include) -or 
                            ($item.name -match $Include))) {
                        Write-Host ("{0}: Beginning Installation." -f $item.name)
                        [PSObject]$typed = $item;
                        Install-Software -Item $typed
                        Write-Host ("{0}: Finished Installation." -f $item.name)
                        Write-Host
                    }
                }
            }
        }
    }
    finally {
        Pop-Location
    }
}

