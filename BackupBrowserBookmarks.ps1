$AllUsers = Get-ChildItem -Path "$($ENV:SystemDrive)\Users"
$AllUsers | ForEach-Object {
	Try { 
		if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks") {
			$path = "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
			#$output_path = "$($ENV:SystemDrive)\temp\Bookmark_backup_$($_.Name)"
			$onedrive_path = "$($ENV:onedrive)\Bookmark_Backup\Bookmark_backup_$($_.Name)"
			Copy-Item -Path $path -Destination $onedrive_path
		}
	} Catch { 
		Out-Null
	}
}