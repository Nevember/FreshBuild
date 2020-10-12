function Get-ByWinget {
    param(
        [PSObject]$Item=$null
    )
    $parameters = @("install", $item.name)

    if($item.parameters){
        $parameters += [string[]]$item.parameters;
    }

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
