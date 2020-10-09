function Install-Software{
    param(
        [PSObject]$Item=$null
    )
    Write-Host $Item

    switch($Item.command){
        "winget" { 
            $result = Get-ByWinget $item 
            if($result) {
                Write-Host $result;
            }
        }

        "scoop" { 
            $result = Get-ByScoop $item 
            if($result) {
                Write-Host $result;
            }
        }
    
        default {
            try{
                if($item.url.length -gt 0)
                {
                    Get-ByDownloadedInstaller $item
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
