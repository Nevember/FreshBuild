function Get-ByScript {
    param(
        [PSObject]$Item=$null
    )
    $script = $item.script;
    Write-Host ("{0}: Installing..." -f $item.name)
    if($item.elevate) {
        Start-Process -Wait -Verb RunAs -FilePath powershell -ArgumentList "-c", $script, $item.parameters
    } else {
        $block = [Scriptblock]::Create($script)
        Invoke-Command -ScriptBlock $block -ArgumentList $item.parameters
    }
    Write-Host ("{0}: Installation complete." -f $item.name)
}