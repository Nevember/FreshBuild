function Install-Scoop {
    $item = ('{
        "name": "Scoop",
        "source": "direct",
        "script": "iwr -useb get.scoop.sh | iex; scoop bucket add extras" }' | ConvertFrom-Json);

    Get-ByScript $item;
}

function Uninstall-Scoop{
    $scoop = Get-Command scoop;

    if($scoop) {
        . $scoop export | ForEach-Object -process { . $scoop uninstall $_ }
        . $scoop uninstall scoop
    }
}