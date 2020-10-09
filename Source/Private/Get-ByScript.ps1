function Get-ByScript {
    param(
        [PSObject]$Item=$null
    )
    $script = $item.script;
    Write-Host ("{0}: Installing..." -f $item.name)
    $argList = @("-c", $script)
    if($item.parameters) {
        $argList += $item.parameters;
    }
    if($item.elevate) {
        try{
            Start-Process -Wait -Verb RunAs -FilePath powershell -ArgumentList $argList
        } catch {
            Write-Error $_
        }
    } else {
        try{
            Start-Process -Wait -NoNewWindow -FilePath powershell -ArgumentList $argList
        } catch {
            Write-Error $_
        }
    }
    Write-Host ("{0}: Installation complete." -f $item.name)
}