function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

Write-Output "$(Get-TimeStamp) Script Starts" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
Try {
	Set-ExecutionPolicy Unrestricted -Force  | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Write-Output "$(Get-TimeStamp) Set-ExecutionPolicy Unrestricted Done" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	# Update Windows from Powershell
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Write-Output "$(Get-TimeStamp) Install NuGet Done" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Install-Module PSWindowsUpdate -Force  | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Write-Output "$(Get-TimeStamp) Install PSWindowsUpdate Done" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Import-Module PSWindowsUpdate | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Write-Output "$(Get-TimeStamp) Import PSWindowsUpdate Done" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
	Write-Output "$(Get-TimeStamp) Import GetWindowsUpdate Done" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
}Catch {
    Write-Output "$(Get-TimeStamp) $_" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append
}
Write-Output "$(Get-TimeStamp) Script Ends" | Out-File C:\temp\GetWindowsUpdates_log.txt -Append