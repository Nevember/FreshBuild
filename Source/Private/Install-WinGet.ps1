function Install-WinGet {
    $item = ('{
        "name": "WinGet",
        "source": "direct",
        "url": "",
        "script": "Add-AppxPackage https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -InstallAllResources"
    }' | ConvertFrom-Json);

    Get-ByScript $item;

    '{
        // For documentation on these settings, see: https://aka.ms/winget-settings
        // "source": {
        //    "autoUpdateIntervalInMinutes": 5
        // },
        "experimentalFeatures": {
            "experimentalMSStore": true
        }
    }' | Out-File "$env:USERPROFILE\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
}

function Uninstall-WinGet {
    $winget = Get-AppxPackage Microsoft.DesktopAppInstaller;
    
    if ($winget) { 
        $winget | Remove-AppxPackage
    }
}
