function Get-ByScoop {
    param(
        [PSObject]$Item=$null
    )
    $parameters = @("-c", $command, "install", $item.name)

    if($item.parameters){
        $parameters += [string[]]$item.parameters;
    }

    if($command) {
        if($item.elevate){
            return Start-Process -Wait -Verb RunAs -FilePath powershell -ArgumentList $parameters
        } else {
            return Start-Process -Wait -NoNewWindow -FilePath powershell -ArgumentList $parameters
        }
    } else {
        throw ("No command matching {0} was found." -f $item.command);
    }
}
