function Get-SafeAlias {
    <#
.SYNOPSIS
    Removes special char from string so it can be used as an certificate alias
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipeline)]
        [String]
        $Alias
    )
    $pattern = "[^a-zA-Z0-9-_()\W]|`"|\*|`'|=|,| |/"

    return ($Alias -replace $pattern, '')
}