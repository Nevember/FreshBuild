function Get-ByInstaller {
    param(
        [PSObject]$Item=$null
    )
    $name = $item.Name
    $parameters = $item.parameters;
    $path = Join-Path $downloadFolder -ChildPath $item.fileName

    $destination = Get-Installer $item -Destination $path

    if($destination -ne $path){
        throw "Not downloaded: $path, received $destination";
    }       

    if(Test-Path $path) {            
        Write-Host ("{0}: Installing from {1}." -f $name, $path)

        $stdOut = "./standardOut.txt"
        $stdError = "./standardError.txt";

        Remove-Item $stdError, $stdOut -ErrorAction SilentlyContinue

        switch ($Item.command) {
            'msiexec' { 
                $parameters = @("/package", $path) + $parameters;
                $path = (Get-Command $Item.command).Source; 
            }                    
        }

        if($path){
            if($Item.elevate){
                $process = Start-Process -FilePath $path `
                    -Verb RunAs `
                    -ArgumentList $parameters `
                    -RedirectStandardOutput $stdOut `
                    -RedirectStandardError $stdError `
                    -Wait `
                    -PassThru
            } else {
                $process = Start-Process -FilePath $path `
                    -NoNewWindow `
                    -ArgumentList $parameters `
                    -RedirectStandardOutput $stdOut `
                    -RedirectStandardError $stdError `
                    -Wait `
                    -PassThru
            }
        } else {
            throw "`$path is not set.";
        }

        if($process.ExitCode -ne 0){
            Write-Host ("{0}: ExitCode: {1}" -f $Item.name, $process.ExitCode)
            Get-Content $stdOut -ErrorAction SilentlyContinue | Write-Host
            Get-Content $stdError -ErrorAction SilentlyContinue | Write-Error
        }

        Write-Host ("{0}: Install of {1} yielded: {2}" -f $name, $path, $process.ExitCode)
    }
}
