function Get-CertificateFromUrl {
    <#
.SYNOPSIS
    Returns a host certificate and/or certificate chain for given host
.DESCRIPTION
    Returns a host certificate and/or certificate chain for given host as an array of X509 certificates. If a certificate doesn't have a chain (self signed) only the certificate will be returned.
.EXAMPLE
    PS C:\> Get-CertificateFromUrl -Hostname google.com
    Returns the host certificate and certificate chain of google.com
.EXAMPLE
    PS C:\> Get-CertificateFromUrl -Hostname google.com -HostCertificateOnly
    Returns the host certificate google.com
.EXAMPLE
    PS C:\> Get-CertificateFromUrl -Hostname google.com -ChainOnly
    Returns the certificate chain of google.com without the host certificate

#>
    [CmdletBinding(DefaultParameterSetName = 'default',
        PositionalBinding = $true,
        HelpUri = 'https://github.com/macces/ImportCertificate',
        ConfirmImpact = 'Low')]
    [OutputType([System.Security.Cryptography.X509Certificates.X509Certificate2[]])]
    Param (
        # Param1 help description
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]$Hostname,

        # Only returns the certificate chain without the host certificate
        [Parameter(Mandatory = $false, 
            ParameterSetName = 'Chain')]
        [switch]$ChainOnly,

        # Only returns the host certificate without the certificate chain
        [Parameter(Mandatory = $false, 
            ParameterSetName = 'Host')]
        [switch]$HostCertificateOnly
    )
    
    begin {}
    
    process {
        # check if hostname or uri
        if ([System.Uri]::IsWellFormedUriString($Hostname, 'Absolute')) {
            $Hostname = ([uri]$Hostname).host
        }

        # depending if using windows PS or PS this works differently
        if ($PSVersionTable.PSVersion -le [version]::Parse("6.0")) {
            Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
            $webRequest = [Net.WebRequest]::Create("https://$hostname")
            $response = $webRequest.GetResponse()
            $cert = $webRequest.ServicePoint.Certificate
            $response.dispose()
            $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::new()
            $chain.build($cert) | Out-Null
            $chain.build($cert) | Out-Null # for some unknown reason you have to call this twice to get the whole chain
            $certificates = $chain.ChainElements.Certificate
        }
        else {
            $Callback = { param($sender, $cert, $chain, $errors) return $true }
            $request = [System.Net.Sockets.TcpClient]::new($hostname, '443')
            $stream = [System.Net.Security.SslStream]::new($request.GetStream(), $true, $Callback)
            $stream.AuthenticateAsClient($hostname)
            $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::new()
            $chain.ChainPolicy.RevocationMode = [System.Security.Cryptography.X509Certificates.X509RevocationMode]::NoCheck
            $chain.ChainPolicy.VerificationFlags = [System.Security.Cryptography.X509Certificates.X509VerificationFlags]::AllowUnknownCertificateAuthority
            $chain.Build($stream.RemoteCertificate) | Out-Null
            $chain.Build($stream.RemoteCertificate) | Out-Null
            $certificates = $chain.ChainElements.Certificate
        }
        if ($HostCertificateOnly.IsPresent) {
            return $certificates[0]
        }
        elseif ($ChainOnly.IsPresent) {
            if ($certificates.count -gt 1) {
                return $certificates[1, ($certificates.count - 1)]
            }
            else {
                Write-Warning "$Hostname didn't return a chain."
                if ($certificates.issuer -eq $certificates.subject) {
                    Write-Warning "It is a self signed certificate"
                }
                return
            }
        }
        return $certificates
    }
    end {}
}