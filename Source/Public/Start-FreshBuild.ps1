function Start-FreshBuild {
    [CmdletBinding()]
    param(
        [string]$jsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json",
        [string]$Exclude = $null,
        [string]$Include = $null,
        [switch]$Step = $false,
        [switch]$InstallWinGet=$false,
        [switch]$InstallChocolatey=$false,
        [switch]$InstallScoop=$false,
        [switch]$NoScript=$false
    )

    Push-Location

    try {
        $defaultJsonConfig = "$env:USERPROFILE/.freshBuild/FreshInstall.json";

        if (-not (Test-Path $jsonConfig)) {
            if ($jsonConfig -eq $defaultJsonConfig) {
                Set-Location (Get-Module -Name "FreshBuild").Path
                New-Item $env:USERPROFILE/.freshBuild -ItemType Directory -ErrorAction SilentlyContinue
                Invoke-WebRequest `
                    -Uri https://gist.githubusercontent.com/sharpninja/2ad839cb141bc6b968278bd7416931ce/raw/63a2717e56fe4cc876f419660392d8a7aca12879/FreshInstall.json `
                    -OutFile $defaultJsonConfig                
            }
            else {
                return -1;
            }
        }

        $items = (Get-Content $jsonConfig | ConvertFrom-Json).items

        $downloadFolder = "$env:USERPROFILE/.freshBuild/downloads"

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

