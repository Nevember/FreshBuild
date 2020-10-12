function Install-Software{
    param(
        [PSObject]$Item=$null
    )
    Write-Host $Item

    switch($Item.source){
        "winget" { 
            $command= $env:USERPROFILE + "/AppData/Local/Microsoft/WindowsApps/winget.exe";
            $result = Get-ByWinget $item 
            if($result) {
                Write-Host $result;
            }
        }

        "scoop" { 
            $command= $env:USERPROFILE + "/scoop/shims/scoop.ps1";
            $result = Get-ByScoop $item 
            if($result) {
                Write-Host $result;
            }
        }

        "choco" { 
            $command="C:/ProgramData/chocolatey/bin/cinst.exe";
            $result = Get-ByChocolatey $item 
            if($result) {
                Write-Host $result;
            }
        }
    
        default {
            try{
                if($item.url.length -gt 0)
                {
                    Get-ByInstaller $item
                } elseif($item.script) {
                    Get-ByScript $item
                } elseif($item.command) {
                    Get-ByCommand $item
                }
            } catch {
                Write-Error $_
                throw $_       
            }
        }
    }
}
