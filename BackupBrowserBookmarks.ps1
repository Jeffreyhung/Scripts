# Get all the user profiles on the machine
$AllUsers = Get-ChildItem -Path "$($ENV:SystemDrive)\Users"
# loop through all the user profiles
$AllUsers | ForEach-Object {
	Try { 
		# Check if user has Chrome installed and if the Bookmark file exist
		if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks") {
			$path = "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
			#$output_path = "$($ENV:SystemDrive)\temp\Bookmark_backup_$($_.Name)"
			$onedrive_path = "$($ENV:onedrive)\Bookmark_Backup\Bookmark_backup_$($_.Name)"
			# Copy the bookmark to user's onedrive folder
			Copy-Item -Path $path -Destination $onedrive_path
		}
	} Catch { 
		Out-Null
	}
}