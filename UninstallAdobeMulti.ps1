Param(
$ScriptFile = "Get-WMIObject -ComputerName $Computer -Class Win32\_Product | Where-Object { $\_.Name -Like 'Adobe Acrobat DC\*'}",
$AdobeComputers = (Import-Csv $PSScriptRoot\UninstallAdobePro.csv),
$MaxThreads = 20,
$OutputType = "Text")

$Computers = $AdobeComputers

Write-Verbose "Killing existing jobs . . ." -Verbose
Get-Job | Remove-Job -Force
Write-Verbose "Done." -Verbose

$Count = 0

ForEach ($Computer in $Computers) {
If ((Test-Path "\\$($Computer.ComputerName)\c$") -eq $True) {



	While ($(Get-Job -State Running).Count -ge $MaxThreads) {

		Write-Progress -ID 0 -Activity "Creating Adobe List" -Status "Waiting for threads to close" -CurrentOperation "$Count threads created - $($(Get-Job -State Running).Count) threads open" -PercentComplete (($Count / $Computers.Count) * 100)

	}

}

Else {

	Write-Verbose "$Computer.ComputerName doesn't ping"

}


$Job = Start-Job -ScriptBlock { $ScriptFile } | Out-Null
Write-Progress -ID 0 -Activity "Creating Computer List" -Status "Starting Threads" -CurrentOperation "$Count threads created - $($(Get-Job -state running).Count) threads open" -PercentComplete (($Count / $Computers.count) * 100)

$Count++
}

$Complete = Get-date
While ($(Get-Job -State Running).count -gt 0){
$ComputersStillRunning = ""
ForEach ($System In $(Get-Job -state running)){$ComputersStillRunning += ", $($System.name)"}
$ComputersStillRunning = $ComputersStillRunning.Substring(2)
Write-Progress  -Activity "Creating Server List" -Status "$($(Get-Job -State Running).count) threads remaining" -CurrentOperation "$ComputersStillRunning" -PercentComplete ($(Get-Job -State Completed).count / $(Get-Job).count * 100)
}

Write-Verbose "Reading All Jobs" -Verbose

$Out = Get-Job $Job Wait-Job
$Job | Receive-Job

If ($OutputType -eq "Text"){
ForEach($Job in Get-Job){
"$($Job.Name)"
"****************************************"
Receive-Job $Job
" "
}
}

ElseIf($OutputType -eq "GridView"){
Get-Job | Receive-Job | Select-Object * -ExcludeProperty RunSpaceID | Out-GridView
}