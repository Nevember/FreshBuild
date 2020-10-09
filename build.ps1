#requires -Module Configuration
<#
    .Synopsis
        This is just a bootstrapping build, for when ModuleBuilder can't be used to build ModuleBuilder
#>
[CmdletBinding()]
param(
    # A specific folder to build into
    $OutputDirectory,

    # The version of the output module
    [Alias("ModuleVersion")]
    [string]$SemVer
)
# Sanitize parameters to pass to Build-Module
$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot -StackName FreshBuildStackFrame

$ModuleName = 'FreshBuild'

if (-not $Semver) {
    if ($semver = gitversion -showvariable SemVer) {
        $null = $PSBoundParameters.Add("SemVer", $SemVer)
    }
}

try {
    # Build ModuleBuilder with ModuleBuilder:
    Write-Verbose "Compiling FreshBuild module"
    $OFS = "`n`n"
    $Source = Get-ChildItem Source -File -Recurse -Filter *.ps1 |
        Sort-Object DirectoryName, Name |
        Get-Content -Encoding UTF8 -Delimiter ([char]0)
    $Source += "`nExport-ModuleMember -Function *-*"

    Get-Module $ModuleName -ErrorAction Ignore | Remove-Module
    New-Module $ModuleName ([ScriptBlock]::Create($Source)) |
        Import-Module -Verbose:$false -DisableNameChecking

    $item = Get-Item Source/build.psd1
    $fullPath = $item.FullName;

    # Build new output
    Import-Module ModuleBuilder
    $ParameterString = $PSBoundParameters.GetEnumerator().ForEach{ '-' + $_.Key + " '" + $_.Value + "'" } -join " "
    Write-Verbose "Build-Module $fullPath $($ParameterString) -Target CleanBuild"
    Build-Module -SourcePath $fullPath @PSBoundParameters -Target CleanBuild -Passthru -OutVariable BuildOutput | Split-Path
    Write-Verbose "Module build output in $(Split-Path $BuildOutput.Path)"

    # Clean up environment
    Remove-Module $ModuleName -ErrorAction SilentlyContinue -Verbose:$false

} finally {
    Pop-Location -StackName FreshBuildStackFrame
}
