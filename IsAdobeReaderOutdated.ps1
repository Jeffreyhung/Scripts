If((Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq "64-bit"){
    $var = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*  | Where-Object { $_.DisplayName -match "Adobe Acrobat Reader"} | Select -expandproperty DisplayVersion
}else {
    $var = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -match "Adobe Acrobat Reader"}
}
$version=$args[0]
if ($var -lt $version){
    return $TRUE
}else {
    return $FALSE
}
