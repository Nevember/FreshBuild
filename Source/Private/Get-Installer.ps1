function Get-Installer {
    param (
        [PSObject]$Item=$null,
        [string]$Destination
    )

    if($Item.url -and $Item.url.length -gt 0)
    {
        if(Test-Path $Destination){
            return $Destination;
        }

        Write-Host ("{0}: Downloading {1} to {2}" -f $Item.name, $Item.url, $Destination);
        Invoke-WebRequest $Item.url -OutFile $Destination

        if(-not(Test-Path $Destination)){
            throw ("{0}: Error downloading file." -f $Item.name)
        } else {
            Write-Host ("{0}: Downloaded to: {1}" -f $Item.name, $Destination)
            return $Destination
        }
    }
}

