function Install-WinGet {
    $item = ('{
        "name": "WinGet",
        "source": "direct",
        "url": "",
        "script": "invoke-webrequest https://github.com/microsoft/winget-cli/releases/download/v.0.2.2521-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -outfile $env:USERPROFILE/.freshBuild/downloads/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle; & $env:USERPROFILE/.freshBuild/downloads/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle",
        "parameters": [
            "/quiet",
            "/passive",
            "/norestart"
        ]}' | ConvertFrom-Json);

    Get-ByScript $item;
}
