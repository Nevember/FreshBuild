function Install-Software{
    param(
        [PSObject]$Item=$null
    )
    Write-Host $Item

    switch($Item.source){
        "winget" {             
            $command= $env:USERPROFILE + "/AppData/Local/Microsoft/WindowsApps/winget.exe";

            if(-not(Test-Path $command)) {
                Install-WinGet
            }

            $result = Get-ByWinget $item 
            if($result) {
                Write-Host $result;
            }
        }

        "scoop" { 
            $command= $env:USERPROFILE + "/scoop/shims/scoop.ps1";

            if(-not(Test-Path $command)) {
                Install-Scoop
            }

            $result = Get-ByScoop $item 
            if($result) {
                Write-Host $result;
            }
        }

        "choco" { 
            $command="C:/ProgramData/chocolatey/bin/cinst.exe";

            if(-not(Test-Path $command)) {
                Install-Chocolatey
            }

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
