function Get-ByChocolatey {
    param(
        [PSObject]$Item=$null
    )
    #$command = (Get-Command $command).Source;

    if($item.parameters){
        $parameters = @("install", "`"" + $item.name + "`"", $item.parameters)
    } else {
        $parameters = @("install", "`"" + $item.name + "`"")
    }

    Write-Host ("{0}: Parameters: {1}" -f $Item.name, $parameters)

    if($command) {
        if($item.elevate){
            return Start-Process -Wait -Verb RunAs -FilePath $command -ArgumentList $parameters
        } else {
            return Start-Process -Wait -NoNewWindow -FilePath $command -ArgumentList $parameters
        }
    } else {
        throw ("No command matching {0} was found." -f $item.command);
    }
}