function Get-Profile 
{
 <#
  .SYNOPSIS
  Retrieves user profiles from a computer using WMI.
  .DESCRIPTION
  Retrieves a specific user profile, or all profiles from a computer or list of computers, using WMI.   
  .EXAMPLE
  Get-Profile -Identity accountName -computer computerName
  .EXAMPLE
  Get-Profile -Identity AccountOne,AccountTwo -ComputerName computerOne,ComputerTwo
  .EXAMPLE
  Get-Profile -Identity * -ComputerName computerName
  .PARAMETER Identity
  The AD User account, or list of accounts, of the profile(s) to be retrieved.
  .PARAMETER ComputerName
  The computers or servers to get the profiles from.
  .PARAMETER Credential
  Optionally, supply an account to run the command as. 
  #>
    param(
        [Parameter(Mandatory=$True,
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$True
                    )]
        [Alias('User','Username')]
        $Identity,
        [Parameter(Mandatory=$True,
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$True)]
        [Alias('Computer','Server')]
        $ComputerName,
        [Parameter(Mandatory=$False)]
        [Alias('Cred','RunAs')]
        $Credential
    )

    $dc = (Get-ADDomainController).Name

    $Proflist =@()

    foreach ($comp in $ComputerName) 
    { 
    foreach ($User in $Identity) 
    {
        if ($user -eq "*") 
        {
            if ($Credential) 
            {
                $wmiProfs = Get-WmiObject -computername $comp -class Win32_UserProfile -Filter "Special=False" -Credential $Credential
            }
            else
            {
                $wmiProfs = Get-WmiObject -computername $comp -class Win32_UserProfile -Filter "Special=False"
            }
        }
        else
        {
            if ($Credential)
            {
                $usid = (Get-ADUser $User -Server $dc -Credential $Credential).SID.Value 
                $wmiProfs = Get-WmiObject -computername $comp -class Win32_UserProfile -Filter "SID='$usid'" -Credential $Credential
            }
            else
            {
                $usid = (Get-ADUser $User -Server $dc).SID.Value 
                $wmiProfs = Get-WmiObject -computername $comp -class Win32_UserProfile -Filter "SID='$usid'"
            }
        }
        $Proflist = $Proflist + $wmiProfs
    }
    }
    if ($Proflist.Count -gt 1) 
    {      
        return $($proflist| fl LastDownloadTime,LastUploadTime,LastUseTime,Loaded,LocalPath,RoamingConfigured,RoamingPath,RoamingPreference,SID,Special,Status,PSComputername)
    }
    else
    {    
        return $Proflist
    }
}