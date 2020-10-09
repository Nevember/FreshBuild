function Get-ByCommand {
    param(
        [PSObject]$Item=$null
    )
    if(-not $item.command) { throw "Expected command, none provided." }
    $command = (Get-Command $item.command).Source;
    $argList = @()
    if($item.parameters) {
        $argList += $item.parameters;
    }
    if($command) {
        if($item.elevate){
            return Start-Process -Wait -Verb RunAs -FilePath $command -ArgumentList $argList
        } else {
            return Start-Process -Wait -NoNewWindow -FilePath $command -ArgumentList $argList
        }
    } else {
        throw ("No command matching {0} was found." -f $item.command);
    }
}
