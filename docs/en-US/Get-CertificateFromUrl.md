---
external help file: ImportCertificate-help.xml
Module Name: ImportCertificate
online version:
schema: 2.0.0
---

# Get-CertificateFromUrl

## SYNOPSIS
Returns a host certificate and/or certificate chain for given host

## SYNTAX

### default (Default)
```
Get-CertificateFromUrl [-Hostname] <String> [<CommonParameters>]
```

### Chain
```
Get-CertificateFromUrl [-Hostname] <String> [-ChainOnly] [<CommonParameters>]
```

### Host
```
Get-CertificateFromUrl [-Hostname] <String> [-HostCertificateOnly] [<CommonParameters>]
```

## DESCRIPTION
Returns a host certificate and/or certificate chain for given host as an array of X509 certificates.
If a certificate doesn't have a chain (self signed) only the certificate will be returned.

## EXAMPLES

### EXAMPLE 1
```
Get-CertificateFromUrl -Hostname google.com
Returns the host certificate and certificate chain of google.com
```

### EXAMPLE 2
```
Get-CertificateFromUrl -Hostname google.com -HostCertificateOnly
Returns the host certificate google.com
```

### EXAMPLE 3
```
Get-CertificateFromUrl -Hostname google.com -ChainOnly
Returns the certificate chain of google.com without the host certificate
```

## PARAMETERS

### -Hostname
Param1 help description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ChainOnly
Only returns the certificate chain without the host certificate

```yaml
Type: SwitchParameter
Parameter Sets: Chain
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostCertificateOnly
Only returns the host certificate without the certificate chain

```yaml
Type: SwitchParameter
Parameter Sets: Host
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Security.Cryptography.X509Certificates.X509Certificate2[]
## NOTES

## RELATED LINKS
