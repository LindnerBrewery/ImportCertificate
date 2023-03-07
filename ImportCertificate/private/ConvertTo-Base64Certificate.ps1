function ConvertTo-Base64Certificate {
    <#
.SYNOPSIS
    Converts a X509 certificate to a base64 representation
.DESCRIPTION
    Converts a X509 certificate to a base64 representation
.EXAMPLE
    PS C:\> ConvertTo-Base64Certificate -$X509Certificate $myCert
    Returns a base64 representation of $myCert
#>
    [CmdletBinding(DefaultParameterSetName = 'default',
        PositionalBinding = $true,
        HelpUri = 'https://github.com/macces/ImportCertificate',
        ConfirmImpact = 'Low')]
    [OutputType([String])]
    Param (
        # Param1 help description
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$X509Certificate
    )
    
    begin {}
    
    process {
        # convert x509 to base64 cert
        [String]$certString = $null
        $certString += "-----BEGIN CERTIFICATE-----`n"
        $byte = $X509Certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert, "InsertLineBreaks")
        $certString += [System.Convert]::ToBase64String($byte, 'InsertLineBreaks')
        $certString += "`n-----END CERTIFICATE-----"
        $certString
    }
    
    end {}
}