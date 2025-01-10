function Import-X509Certificate {
    <#
.SYNOPSIS
    Imports one or more certificates into a designated certificate store
.DESCRIPTION
    Imports one or more X509 certificates into a designated certificate store. Stores can be a windows store, a .net core store (linux) and/or CaCerts (linux)
.EXAMPLE
    PS C:\> $myCert | Import-X509Certificate -$X509Certificate $myCert
    Imports all the certificates into trusted root of the machine store on windows and CA Certificates and .net user store on linux
.EXAMPLE
    PS C:\> Get-CertificateFromUrl bing.com  -ChainOnly | Import-X509Certificate -$X509Certificate $myCert -UserStore
     Imports all the certificates into trusted root of the user store on windows and .net user store on linux
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param (
        # Param1 help description
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [System.Security.Cryptography.X509Certificates.X509Certificate2[]]$X509Certificate,
        # Import in user contect
        [Parameter(Mandatory = $false)]
        [switch]$UserStore,
        # sudo Password for linux
        [Parameter(Mandatory = $false)]
        [SecureStringTransformAttribute()]
        [securestring]$SudoPassword

    )
    
    begin {
        function ImportCert ($storeLocation, $X509Certificate) {
            #$certStore = [System.Security.Cryptography.X509Certificates.X509Store]::new([System.Security.Cryptography.X509Certificates.StoreName]::Root, $storeLocation, [System.Security.Cryptography.X509Certificates.OpenFlags]::MaxAllowed);
            $certStore = [System.Security.Cryptography.X509Certificates.X509Store]::new([System.Security.Cryptography.X509Certificates.StoreName]::Root, $storeLocation)
            $certStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::MaxAllowed)
            # Add to windows store or to .net store on linux
            foreach ($cert in $X509Certificate) {
                Write-Verbose "Importing $($cert.subject)"
                $certStore.Add($cert)
            }
            $certStore.Close();
        }
    }
    
    process {
        
        # choose store depending on elevation (windows powershell hasn't an platform property)
        if ($iswindows -or $null -eq $iswindows) {
            if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -And -not $UserStore) {
                Write-Verbose "Importing to Machine Store"
                $storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
                ImportCert $storeLocation $X509Certificate
            }
            else {
                Write-Verbose "Importing  to Current User Store"
                $storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser
                ImportCert $storeLocation $X509Certificate
            }
        }
        elseif ($IsLinux) {
            if ($SudoPassword) {
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SudoPassword )
                $plaintextpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
            }

            if (-not $UserStore) {

                Write-Verbose "Importing to Ca Certificates"
                foreach ($cert in $X509Certificate) {
                    Write-Verbose "Importing $($cert.subject)"
                    $certString = ConvertTo-Base64Certificate -X509Certificate $cert
                    $filename = "$(Get-SafeAlias $cert.Subject).crt"
                    $certFile = "/tmp/$filename"
                    $certString | Add-Content $CertFile -Force -ErrorAction Stop
                    try {
                        #$x = bash -c "sudo cp $CertFile /usr/local/share/ca-certificates/" *>&1
                        $result = Write-Output $plaintextpassword | sudo -S cp $CertFile /usr/local/share/ca-certificates/ 2>&1
                        if ($LASTEXITCODE -ne 0) {
                            throw $result
                        }
                    }
                    catch {
                        throw $_
                    }
                    finally {
                        Remove-Item $certFile -Force
                    }
                     
                }
                
                try {
                    #$x = bash -c "sudo update-ca-certificates" *>&1
                    $result = Write-Output $plaintextpassword | sudo -S update-ca-certificates 2>&1
                    if ($LASTEXITCODE -ne 0) {
                        throw $result
                    }
                }
                catch {
                    throw $_
                }
            }
            Write-Verbose "Importing to .net Current User Store"
            $storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser
            ImportCert $storeLocation $X509Certificate
        }
    }
    end {}
}

