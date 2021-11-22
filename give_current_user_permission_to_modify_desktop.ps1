$path = 'C:\Users\Public\Public Desktop','C:\Users\Public\Desktop'
$currentuser = (Get-ComputerInfo | select 'CsUserName'  -expandproperty 'csusername')
$path | foreach {
	$ACL = Get-ACL -Path $_
	$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($currentuser,"FullControl","Allow")
	$ACL.SetAccessRule($AccessRule)
	$ACL | Set-Acl -Path $_
}