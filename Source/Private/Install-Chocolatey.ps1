function Install-Chocolatey {
    $item = ('{
        "name": "Chocolatey",
        "source": "direct",
        "script": "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(\"https://chocolatey.org/install.ps1\"))",
        "elevate": true }' | ConvertFrom-Json);

    Get-ByScript $item;
}
