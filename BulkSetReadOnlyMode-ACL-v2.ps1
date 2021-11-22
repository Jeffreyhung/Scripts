<#
    Required:
        -Must be run Administrator mode using Administrator account
	Input:
		-Input file must be save as .txt 
		-One path per line (no space at the end of each line)
		-Save the input file to the same location of the script
		-Update the name of the input file for -InputFilePath parameter
	
	Limitation:
		-Add 100 paths at a time per input file
		
	Example:
		1. Set to ReadOnly ModeFor HomeDrive:
            .\BulkSetReadOnlyMode-ACL.v2.ps1 -InputFilePath "PathInput.txt" -ModeFor HomeDrive
#>

param
(    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $InputFilePath,

	#This param to control LOCK DOWN for FileShare or HomeDrive
	[Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ModeFor
)

# Read Input file
$Entries = Get-Content -Path $InputFilePath

# Check number of input records
if ($Entries.Count -eq 0 -or $Entries.Count -gt 100)
{
    Write-Host $("Unexpected paths count: [{0}]" -f $Entries.Count) -ForegroundColor Red
    return 
}

# Log OutPut Params
$LogOutputs = @()
$LogFile = "Log-" + $InputFilePath

# Set required security
$Rights = "Write, Delete, ReadPermissions, DeleteSubdirectoriesAndFiles, ChangePermissions, TakeOwnership"	
$RuleType = "Deny"
$PropogationSettings = "None"
$InheritSettings = "Containerinherit, ObjectInherit"

function AddDenyPermission($user, $item, $accessRule){
    $LogOutputs += "`r`n --> Processing Deny Permission for : " + $item.FullName
    $acl = Get-Acl $item.FullName
    $denyAcl = $acl.Access | Where-Object {$_.AccessControlType -eq "Deny" -and $_.IdentityReference -eq $user}
    
    if ($denyAcl -eq $null -and $item.Name -ne "Viewpoint_Files"){
        $acl.SetAccessRule($accessRule)
        #Set the ACL
	    $acl | Set-Acl -Path $item.FullName    
        #Write-Host "--> Deny Acl Added : " $item.FullName -ForegroundColor Green
        $LogOutputs += "`r`n    Log: Deny ACL Added : " + $item.FullName
    }
    else{        
        #Write-Host "--> Deny Acl Exists : " $item.FullName -ForegroundColor Yellow
        $LogOutputs += "`r`n    Log: Deny ACL Exists : " + $item.FullName
    }       
}

function CreateViewPointFolder($homeDrive, $user){
    $LogOutputs += "`r`n    Log: Processing ViewPoint_Files Folder creation"
    $DirectoryToCreate = $homeDrive+"\Viewpoint_Files"
    try{

        if (-not (Test-Path -LiteralPath $DirectoryToCreate)) 
        {
            try
            {            
                New-Item -Path $DirectoryToCreate -ItemType Directory -ErrorAction Stop | Out-Null #-Force
                write-host "Creating Viewpoint_Files folder" -ForegroundColor Green
            }
            catch
            {
                $LogOutputs += "`r`n    Error: Unable to create directory ViewPoint_Files. Error was: $_"
                Write-Error -Message "Unable to create directory '$DirectoryToCreate'. Error was: $_" -ErrorAction Stop
            }
            $LogOutputs += "`r`n    Log: Successfully created ViewPoint_Files Folder"
                write-host "Created Viewpoint_Files folder" -ForegroundColor Green
        }
        else {
            $LogOutputs += "`r`n    Log: ViewPoint_Files Folder already exists."
        }
        $LogOutputs += "`r`n    Log: Removing Inheritance for ViewPoint_Files Folder : " +$DirectoryToCreate
        icacls $DirectoryToCreate /inheritance:d
        RemoveDenyAcl $DirectoryToCreate $user

        $items = Get-ChildItem -Path $DirectoryToCreate -Recurse
        foreach ($item in $items){
            RemoveDenyAcl $item.FullName $user
        }
    }
    catch{
        $LogOutputs += "`r`n    ERROR: No Access to : " +$DirectoryToCreate
    }
}

function RemoveDenyAcl($path, $user){
    $acl = Get-Acl -Path $path
    $denyAcl = $acl.Access | Where-Object {$_.AccessControlType -eq "Deny" -and $_.IdentityReference -eq $user}
    if ($denyAcl -ne $null) {
        $LogOutputs += "`r`n    Log: Removing Deny ACL for : "+$DirectoryToCreate
        $acl.RemoveAccessRule($denyAcl)
        Set-Acl -Path $path -AclObject $acl
        $LogOutputs += "`r`n    Log: Removed Deny ACL for : "+$DirectoryToCreate
    }
}


if ($ModeFor -eq "HomeDrive")
{
    $LogOutputs = "STARTED PROCESSING HOMEDRIVE LOCKDOWN: " + (Get-Date).ToString()
    Foreach ($Entry in $Entries)
	{
        $LogOutputs += "`r`n  Processing started for : " + $Entry + " - " + (Get-Date).ToString()
		$Path = $Entry
		$user = "mmrgrp\" + $Entry.split("\")[4]        

        $FolderPerm = $user, $Rights, $InheritSettings, $PropogationSettings, $RuleType    	
        $FolderAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $FolderPerm
        
        $FilePerm = $user, $Rights, $RuleType
        $FileAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule $FilePerm        

        # Get all root folders and subfolders and items
        
        if(Test-Path -Path $Path)
        {
            CreateViewPointFolder $Path $user

            AddDenyPermission $user (Get-Item $Path) $FolderAccessRule            

            $items = Get-ChildItem -Path $Path -Recurse

            Foreach ($item in $items)
            {            
                try 
                {
		            # Change to READONLY mode for HomeDrive

	                if ($item.PSIsContainer){                        
                        if ($item.Name -eq "Viewpoint_Files"){
                            $LogOutputs += "`r`n     --> Excluding Deny Acl on Folder: " + $item.FullName
                        }
                        else{
                            AddDenyPermission $user $item $FolderAccessRule          
                            $LogOutputs += "`r`n     --> Deny Acl Added to Folder: " + $item.FullName
                        }
                    }
                    else{
                        AddDenyPermission $user $item $FileAccessRule          
                        $LogOutputs += "`r`n     --> Deny Acl Added to File: " + $item.FullName                    
                    }
                }
                catch 
                {
                    $LogOutputs += "`r`n    Log: Failed to Set Readonly mode to: " + $item.FullName
                    Write-host "ERROR: Set Readonly mode to All items: " $item.FullName -BackgroundColor Red -ForegroundColor White
                }
            }
        }
        else
        {
            $LogOutputs += "`r`n  ERROR: Failed to find the path " + $Path
            Write-host "`r`nERROR: Path is not valid: " $Path -BackgroundColor Red -ForegroundColor White
        }
        $LogOutputs += "`r`n  Processing Ended for : " + $Entry + " - " + (Get-Date).ToString()        
    }
    $LogOutputs += "`r`nEND PROCESSING HOMEDRIVE LOCKDOWN: " + (Get-Date).ToString()
    $LogOutputs | Out-File $LogFile
}
else 
{
	Write-Host "ModeFor parameter is only either HomeDrive or FileShare" -ForegroundColor Red
}

Write-Host ""
Write-Host "Script Completed: All paths are in readonly mode"