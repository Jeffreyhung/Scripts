function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

Try {
    Write-Output "$(Get-TimeStamp)" | Out-File C:\temp\DSA_Uninstall_log.txt -Append
    (Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq 'Dell SupportAssist Remediation '}).Uninstall() | Out-File C:\temp\DSA_Uninstall_log.txt -Append
}Catch {
    Write-Output "$(Get-TimeStamp) $_" | Out-File C:\temp\DSA_Uninstall_log.txt -Append
}

Try {
    Write-Output "$(Get-TimeStamp)" | Out-File C:\temp\DSA_Uninstall_log.txt -Append
    (Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq 'Dell Update - SupportAssist Update Plugin'}).Uninstall() | Out-File C:\temp\DSA_Uninstall_log.txt -Append
}Catch {
    Write-Output "$(Get-TimeStamp) $_" | Out-File C:\temp\DSA_Uninstall_log.txt -Append
}

Try {
    Write-Output "$(Get-TimeStamp)" | Out-File C:\temp\DSA_Uninstall_log.txt -Append
    (Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq 'Dell SupportAssist'}).Uninstall() | Out-File C:\temp\DSA_Uninstall_log.txt -Append
}Catch {
    Write-Output "$(Get-TimeStamp) $_" | Out-File C:\temp\DSA_Uninstall_log.txt -Append
}