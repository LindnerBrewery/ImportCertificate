# transformation class that transforms a clear text password to a secure string
class SecureStringTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # if a securestring was submitted...
        if ($inputData -is [SecureString])
        {
            # return as-is:
            return $inputData
        }
        # if the argument is a string...
        elseif ($inputData -is [string])
        {
            # convert to secure string:
            return $inputData | ConvertTo-SecureString -AsPlainText -Force
        }
        # anything else throws an exception:
        throw [System.InvalidOperationException]::new('Unexpected error.')
    }
}
# Dot source public/private functions
$public  = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'public/*.ps1')  -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'private/*.ps1') -Recurse -ErrorAction Stop)
foreach ($import in @($public + $private)) {
    try {
        . $import.FullName
    }
    catch {
        throw "Unable to dot source [$($import.FullName)]"
    }
}

Export-ModuleMember -Function $public.Basename