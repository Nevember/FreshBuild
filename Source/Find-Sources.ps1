function Find-Sources{
    param(
        [PSObject]$Item=$null
    )

    $scoopResult = & scoop search $item.name
    $chocoResult = & choco search $item.name
    $winGetResult = & winget search $item.name

}