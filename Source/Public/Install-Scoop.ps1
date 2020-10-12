function Install-Scoop {
    $item = ('{
        "name": "Scoop",
        "source": "direct",
        "script": "iwr -useb get.scoop.sh | iex" }' | ConvertFrom-Json);

    Get-ByInstaller $item;
}

