---
external help file: ImportCertificate-help.xml
Module Name: ImportCertificate
online version:
schema: 2.0.0
---

# Import-X509Certificate

## SYNOPSIS
Imports one or more certificates into a designated certificate store

## SYNTAX

```
Import-X509Certificate [-X509Certificate] <X509Certificate2[]> [-UserStore] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Imports one or more X509 certificates into a designated certificate store.
Stores can be a windows store, a .net core store (linux) and/or CaCerts (linux)

## EXAMPLES

### EXAMPLE 1
```
$myCert | Import-X509Certificate -$X509Certificate $myCert
Imports all the certificates into trusted root of the machine store on windows and CA Certificates and .net user store on linux
```

### EXAMPLE 2
```
Get-CertificateFromUrl bing.com  -ChainOnly | Import-X509Certificate -$X509Certificate $myCert -UserStore
 Imports all the certificates into trusted root of the user store on windows and .net user store on linux
```

## PARAMETERS

### -X509Certificate
Param1 help description

```yaml
Type: X509Certificate2[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserStore
Import in user contect

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Inputs (if any)
## OUTPUTS

### Output (if any)
## NOTES
General notes

## RELATED LINKS
