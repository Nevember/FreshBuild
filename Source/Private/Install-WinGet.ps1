function Install-WinGet {
    $item = ('{
        "name": "WinGet",
        "source": "direct",
        "url": "",
        "script": "Add-AppxPackage https://github.com/microsoft/winget-cli/releases/download/v.0.2.2521-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -InstallAllResources",
    }' | ConvertFrom-Json);

    Get-ByScript $item;
}
