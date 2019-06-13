function Remove-Profile
{
 <#
  .SYNOPSIS
  Removes a user profile from a computer using WMI.
  .DESCRIPTION
  Removes a user profile from a computer using WMI.
  .EXAMPLE
  Remove-Profile -Identity accountname -computer computername
  .PARAMETER Identity
  The AD User account of the profile to be removed.
  .PARAMETER ComputerName
  The computer or server to remove the profile from.
  .PARAMETER Credential
  Optionally, supply an account to run the command as. 
  #>
    param(
        [Parameter(Mandatory=$True,
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$True)]
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

    if ($Credential)
    {
        $profile = Get-Profile -Identity $Identity -ComputerName $ComputerName -Credential $Credential
    }
    else
    {
        $profile = Get-Profile -Identity $Identity -ComputerName $ComputerName 
    }


    if (($profile.Loaded -eq $False) -and ($profile.count -eq $null))
    {
        try
        {
            Write-Output "Attempting to remove profile from $ComputerName"
            Write-Output $profile.SID
            Write-Output $profile.LocalPath
            $profile.delete()
        }
        catch
        {
            Write-Warning $profile
            Write-Warning "Unable to remove profile from $ComputerName"
        }
    }
}