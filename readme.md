# ImportCertificate

This module can retrieve certificates and certificate chains from a provided URL and import them into a certificate store.

## Install

```powershell
Install-Module ImportCertificate
```

## Usage

### Get-CertificateFromUrl

Get the host certificate and chain (if available) for a given URL.

```powershell
Get-CertificateFromUrl badssl.com 
```

Only get the host certificate for a given URL.

```powershell
Get-CertificateFromUrl self-signed.badssl.com -HostCertificateOnly
```
Retrieve the certificate chain for a given URL.

```powershell
Get-CertificateFromUrl badssl.com -ChainOnly
```

### Import-X509Certificate

Import a X509 certficate to your local trusted root store.
On Windows the certificate will be imported to Trusted Root. If Powershell is running elevated it will use the machine store, if not the user store. 
On Linux it will import to the .net user certificate store and if the user has the id 0 also to the machine CA Certificates.

```powershell
Get-CertificateFromUrl badssl.com -ChainOnly | Import-X509Certificate
```

Import certificate to the user stores only

```powershell
Get-CertificateFromUrl badssl.com | Import-X509Certificate -UserStore
```