function Initialize-FreshBuild {
    param(
        [Switch]$All = $false,
        [switch]$InstallWinGet = $false,
        [switch]$InstallChocolatey = $false,
        [switch]$InstallScoop = $false
    )

    $freshbuildDir = Join-Path $Env:USERPROFILE ".freshbuild"
    $jsonFile = Join-Path $FreshBuildDir "PackageManagers.json"
    
    if (!(Test-Path $freshbuildDir)) {
        $null = New-Item -Path $freshbuildDir -ItemType Directory -Force
    }

    if (Test-Path $jsonFile) {
        [string[]]$installed = Get-Content $jsonFile | ConvertFrom-Json;
    }
    else {
        [string[]]$installed = @();
    }

    if ($InstallWinGet -or $All) { Install-WinGet; $installed += "WinGet" }
    if ($InstallChocolatey -or $All) { Install-Chocolatey; $installed += "Chocolatey" }
    if ($InstallScoop -or $All) { Install-Scoop; $installed += "Scoop" }

    $json = $installed | ConvertTo-Json; 
    if (-not $json) {
        $json = "[]";
    }
    $json | Out-File -Path $jsonFile
}
