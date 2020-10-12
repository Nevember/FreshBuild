function Install-WinGet {
    $item = ('{
        "name": "WinGet",
        "source": "direct",
        "url": "https://github.com/microsoft/winget-cli/releases/download/v.0.2.2521-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle",
        "script": "& \"./downloads/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle\"",
        "parameters": [
            "/quiet",
            "/passive",
            "/norestart"
        ]}' | ConvertFrom-Json);

    Get-ByScript $item;
}
