$ver = "" # acrobat version (Pro / Std / Reader)
$release ="" #acrobat release
# get acrobat release version
$var = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion
foreach ($element in $var) {
	if ( ($element.DisplayName -like "*Acrobat*") -And ($element.Displayname -notlike "*Reader*") -And ($element.Displayname -notlike "*Custom*") -And ($element.Displayname -notlike "*Plug*")) {
		$release = $element.DisplayVersion
		break
	}elseif ( ($element.DisplayName -like "*Acrobat Reader*") -And ($element.Displayname -notlike "*Extended*")) {
		$ver = 'Reader'
		$release = $element.DisplayVersion
	}elseif ( ($element.DisplayName -like "*Adobe Reader*") -And ($element.Displayname -notlike "*Extended*")) {
		$ver = 'Reader'
		$release = $element.DisplayVersion
	}
}

#get acrobat version (Pro / Std / Reader)
if (Test-Path -Path 'C:\ProgramData\*.Adobe'){ # check if the adobe regid file folder exist
	cd C:\ProgramData\*.Adobe
	#check if the regid file exsit
	if ((Test-Path -Path 'regid.1986-12.com.adobe_V6{}Acrobat*') -or (Test-Path -Path 'regid.1986-12.com.adobe_V7{}Acrobat*')){
		$var = Get-Content "regid.1986-12*" | Out-String
		
		if($var.Contains("<swid:activation_status>activated")){
			if ($var.Contains("<swid:serial_number>9101")){
				$ver = 'STD'
			}elseif ($var.Contains("<swid:serial_number>9707")){
				$ver = 'PRO'
			}else{
				$ver = 'Other'
			}
		}else{
			if ($var.Contains("<swid:serial_number>9101")){
				$ver = 'Unlicensed_STD'
			}elseif ($var.Contains("<swid:serial_number>9707")){
				$ver = 'Unlicensed_PRO'
			}else{ 
				$ver = 'Unlicensed_Other'
			}
		}
		
	}else{ #folder exist but regid file not exist
		if ($ver -ne 'Reader'){
			$ver = 'Error'
		}
	}
}else { # folder does not exist
	if ($ver -ne 'Reader'){ 
		$ver = 'None'
	}
}

Set-Content -Path 'C:\temp\Acrobat_version.txt' -Value $ver
Set-Content -Path 'C:\temp\Acrobat_release_version.txt' -Value $release
