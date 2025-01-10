BeforeAll {
    
    $testsFolder = [System.IO.DirectoryInfo]::new($PSScriptRoot)
    $rootFolder = $testsFolder.Parent
    Import-Module (Join-Path $rootFolder.fullname ImportCertificate) -Force
}

Describe 'Get-CertificateFromUrl' {
    Context 'When the function is called with a valid hostname' {
        It 'Should return a list of System.Security.Cryptography.X509Certificates.X509Certificate2' {
            $result = Get-CertificateFromUrl -Hostname 'google.com'
            foreach ($r in $re) {
                $r | Should -BeOfType System.Security.Cryptography.X509Certificates.X509Certificate2
            }
            
        }

        It 'Should return the host certificate and certificate chain by default' {
            $result = Get-CertificateFromUrl -Hostname 'google.com'
            $result.Count | Should -BeGreaterThan 2
        }

        It 'Should return only the host certificate if -HostCertificateOnly switch is used' {
            $result = Get-CertificateFromUrl -Hostname 'google.com' -HostCertificateOnly
            $result.Count | Should -Be 1
        }

        It 'Should return only the certificate chain if -ChainOnly switch is used' {
            $allCerts = Get-CertificateFromUrl -Hostname 'google.com'
            $result = Get-CertificateFromUrl -Hostname 'google.com' -ChainOnly
            ($allCerts.count - $result.Count) | Should -Be 1
        }
        It 'Should return only the host certificate because self signed' {
            $result = get-certificateFromUrl -Hostname https://self-signed.badssl.com/
            $result.Count | Should -Be 1
        }
        It 'Thows an error because no certificate' {
            { get-certificateFromUrl -Hostname localhost.local } | Should -Throw 
        }

    }
}