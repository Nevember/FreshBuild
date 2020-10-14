# FreshBuild

Build up a fresh system with your normal build-out, or customize a build for specfic use-cases using [WinGet](https://github.com/microsoft/winget-cli), [Chocolatey](https://chocolatey.org), [Scoop](https://scoop.sh) or even download and execute installers from any location.

## Getting Started

### Install From PowerShell Gallery

Install into PowerShell (any version 2.0 or higher):

```PowerShell
Install-Module -Name FreshBuild -Scope AllUsers
Import-Module -Name FreshBuild
```

After installing you will need to initialize **FreshBuild** by installing one or more Package Managers:

```PowerShell
# Installs WinGet, Scoop, and Chocolatey
Initialize-FreshBuild -All
```

or any combination of

```PowerShell
# Installs WinGet, Scoop, and Chocolatey
Initialize-FreshBuild -InstallWinGet -InstallScoop -InstallChocolatey
```

Once you have installed package managers, you are ready to build your system.  There is a sample JSON file at [this Gist](https://gist.github.com/sharpninja/2ad839cb141bc6b968278bd7416931ce).  On the first execution of `Start-FreshBuild` this JSON file is downloaded to `$env:USERPROFILE/.freshBuild/FreshInstall.json`.

You can download and edit the json file in one step:

```powershell
Start-FreshBuild -UpdateJson -NoScript; notepad.exe $env:USERPROFILE/.freshBuild/FreshInstall.json
```

> _The `-NoScript` flag tells FreshBuild to do everything except actually perform the steps defined in the JSON file._

The layout of the json file is as follows:

* `items`: Array of object defined as:
  * `name`: Name of the item to install.  This should be wrapped in quotes if it contains spaces (`"\"Name With Space\""`).
  * `source`: One of: `choco`, `scoop`, `winget`, `direct`
  * _optional_ `elevate`: `true` if installation requires elevation, otherwise do not include.
  * _optional_ `url`: Uri to an installer file to download.
  * _optional_ `filename`: Local file of the installer relative to `$env:USERPROFILE:/.freshbuild/downloads`.
  * _optional_ `script`: PowerShell script snippet to acquire and install software.
  * _optional_ `parameters`: Array of **strings** to include as additional parameters.
* `sources`: Not currently used.

#### WinGet Example

```json
{
    "name": "\"Windows Terminal\"",
    "source": "winget",
    "parameters": [ "source", "msstore" ]
}
```

#### Scoop Example

```json
{
    "name": "gitversion",
    "source": "scoop"
}
```

#### Chocolatey Example

```json
{
    "name": "gsudo",
    "source": "choco",
    "elevate": "true"
}
```

> _Due to how Chocolatey works, you should always elevate tasks for it._

#### Download and Execute Installer

```json
{
    "name": "LinqPad 5",
    "source": "direct",
    "url": "https://linqpad.azureedge.net/public/LINQPad5Setup.exe?cache=5.43.0",
    "filename": "LINQPad5Setup.exe",
    "parameters": [
        "/SILENT",
        "/NORESTART"
    ]
}
```

#### Execute a Script

```json
{
    "name": "My Script",
    "source": "direct",
    "script": "Get-Content $env:USERPROFILE/.freshBuild/FreshInstall.json"
}
```

#### Execute a Command

```json
{
    "name": "Tortoise Git",
    "source": "direct",
    "url": "https://download.tortoisegit.org/tgit/2.10.0.0/TortoiseGit-2.10.0.2-64bit.msi",
    "fileName": "TortoiseGit-2.10.0.2-64bit.msi",
    "command": "msiexec",
    "parameters": [
        "/quiet",
        "/passive",
        "/norestart"
    ]
}
```

### Options

`Initialize-FreshBuild` has the following options:

* `-All`: Installs WinGet, Scoop and Chocolatey as per below.
* `-InstallWinGet`: Installs WinGet and adds the `msstore` source.
* `-InstallScoop`: Installs Scoop and adds the `extras` bucket.
* `-InstallChocolatey`: Performs a recommended installation of Chocolatey.

`Start-FreshBuild` has the following options:

* `-JsonConfig <file.json>`: Use the specified json file instead od the default json file.
* `-UpdateJson`: Get the current JSON from [this Gist](https://gist.github.com/sharpninja/2ad839cb141bc6b968278bd7416931ce), overwriting the current json.
* `-NoScript`: Don't execute any installations.  Useful when using the other options.
* `-Step`: Pause after each installation step.
* `-Include <Pattern>`: Only execute installation steps whose name matches the Regex pattern.
* `-Exclude <Pattern>`: Skip installation steps whose name matches the pattern.
* `-UninstallChocolatey`: Uninstall Chocolatey.
* `-UninstallScoop`: Uninstall Scoop.  **Will remove all scoop packages**.
* `-UninstallWinGet`: Uninstall WinGet.
