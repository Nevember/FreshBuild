function Get-ByScript {
    param(
        [PSObject]$Item=$null
    )
    $script = $item.script;
    Write-Host ("{0}: Installing..." -f $item.name)
    if($item.elevate) {
        $argList = @("-c", $script)
        if($item.parameters) {
            $argList += $item.parameters;
        }
        Start-Process -Wait -Verb RunAs -FilePath powershell -ArgumentList $argList
    } else {
        $block = [Scriptblock]::Create($script)
        $arglist = @();
        if($item.parameters) {
            $argList += $item.parameters;
        }
        Invoke-Command -ScriptBlock $block
    }
    Write-Host ("{0}: Installation complete." -f $item.name)
}