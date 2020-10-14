function Start-FreshBuild {
    [CmdletBinding()]
    param(
        [string]$jsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json",
        [string]$Exclude = $null,
        [string]$Include = $null,
        [switch]$Step = $false,
        [switch]$UninstallWinGet=$false,
        [switch]$UninstallChocolatey=$false,
        [switch]$UninstallScoop=$false,
        [switch]$InstallWinGet=$false,
        [switch]$InstallChocolatey=$false,
        [switch]$InstallScoop=$false,
        [switch]$NoScript=$false,
        [switch]$UpdateJson=$false
    )

    Push-Location

    try {
        $jsonUrl = "https://gist.github.com/sharpninja/2ad839cb141bc6b968278bd7416931ce/raw/"
        $defaultJsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json";

        if($UpdateJson) {
            Invoke-WebRequest `
            -Uri $jsonUrl `
            -OutFile $defaultJsonConfig                
        }

        if (-not (Test-Path $jsonConfig)) {
            if ($jsonConfig -eq $defaultJsonConfig) {
                Set-Location (Get-Module -Name "FreshBuild").Path
                New-Item $env:USERPROFILE/.freshBuild -ItemType Directory -ErrorAction SilentlyContinue
                Invoke-WebRequest `
                -Uri $jsonUrl `
                -OutFile $defaultJsonConfig                
            }
            else {
                return -1;
            }
        }

        $items = (Get-Content $jsonConfig | ConvertFrom-Json).items

        $downloadFolder = "$env:USERPROFILE/.freshBuild/downloads"

        if($UninstallWinGet) {Uninstall-WinGet}
        if($UninstallChocolatey) {Uninstall-Chocolatey}
        if($UninstallScoop) {Uninstall-Scoop}

        if($InstallWinGet) {Install-WinGet}
        if($InstallChocolatey) {Install-Chocolatey}
        if($InstallScoop) {Install-Scoop}

        if($NoScript) {return 0;}

        if (-not (Test-Path $downloadFolder)) {
            New-Item $downloadFolder -ItemType Directory
        }

        foreach ($item in $items) {
            Write-Host $item.name
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
            if ($Step) {
                Read-Host "Hit enter for next step..."
            }
        }
    }
    finally {
        Pop-Location
    }
}

