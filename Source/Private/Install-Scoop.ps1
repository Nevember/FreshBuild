function Install-Scoop {
    $item = ('{
        "name": "Scoop",
        "source": "direct",
        "script": "iwr -useb get.scoop.sh | iex; scoop add bucket extras" }' | ConvertFrom-Json);

    Get-ByScript $item;
}

