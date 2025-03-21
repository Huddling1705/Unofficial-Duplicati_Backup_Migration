<#
Unpledged3967 @ forum.duplicati.com
as of 2025-03-21
version 1.0

Limitations:
    -  Unfortunately, my own migration failed after 590 files, as google cut of my access at that point.
       Maybe you are more lucky or you backup is smaller.
    -  Speed is, caused by sequential processing of many small (50MB in my case) files, not as great. The upload reaches full upload speed
       of my contract, but the constant starting and stopping makes it a bit slow.
       Took about 1.5 hours with 50Mb/s upload.

Intention:
This tool is made to migrate backups from one source to another. In my case, it was supposed to get a backup off Mega and upload it to Google Drive.
This can also be used to just upload already downloaded backup files (lots of "duplicati-xxxxxx.zip" files )
Which of these options you want will be asked during script.

#>


$BackendTool_path = 'C:\Program Files\Duplicati 2\Duplicati.CommandLine.BackendTool.exe'   # this must be the path to the "Duplicati.CommandLine.BackendTool.exe" - in a standard install, this should be the correct path. Adjust im needed


# you can find the value for $newBackup_Target_URL easily, by selecting the old backup,
# clicking the "Commandline ..." option and copy the value from the 2nd box
# below is an made up example
$newBackup_Target_URL = "googledrive://Testbackup_new?authid=cc7444444444444444%3Aj443jY-O6.7-Di4h-l942" 





#------------------------------------------------------------------------------------------------------------------------------------------------------------



#region code

# Ask the user if they have already downloaded their old backup
$answer = Read-Host "Have you already downloaded your old backup? (y/n)"
while ($answer -notmatch "^(y|n)$") {
    Write-Host "Please enter 'y' for Yes or 'n' for No."
    $answer = Read-Host "Have you already downloaded your old backup? (y/n)"
}

if ($answer -eq "n") {
    # If the answer is 'n'

    # Define, create and navigate to the folder for the old backup
    $old_backup_folder = "$env:temp\__old_backup_folder_duplicati"
    mkdir $old_backup_folder
    cd $old_backup_folder

	$oldBackup_Target_URL = Read-Host "Please provide the Target_URL ( can be found the same way as with the new Target URL; e. g. googledrive://NameofBackup?authid=cc744444444475%3Aj3s3jY-O6.7-Di3h-l9f2 )"
	#$oldBackup_Target_URL = "googledrive://Testbackup?authid=a272f44444444f5579b9fbede5c714b7c%3AxRfR8r_1-4k2qGz8-C1T5" # if you want to statically set your target URL, comment out the previous line, uncomment this one and paste your Target URL

	

    # Get a list of all backup files
    $listOutput = & $BackendTool_path LIST $oldBackup_Target_URL

    # Display the files to be downloaded
    Write-Host @"

------------------------------------------

    The following files will be downloaded:

"@

    $listOutput

    Write-Host @"
    

------------------------------------------

"@


    # Extract only the names
    $fileNames = $listOutput -split "`n" | ForEach-Object {
        if ($_ -match "^duplicati-.*\.zip") {
            $matches[0]
        }
    }



    # Download each file with progress indicator
    $totalFiles = $fileNames.Count
    $currentFile = 1
    foreach ($fileName in $fileNames) {
        Write-Host "Downloading ($currentFile / $totalFiles): $fileName..."
        & $BackendTool_path GET $oldBackup_Target_URL $fileName
        $currentFile++
    }

}
elseif ($answer -eq "y") {
    # If the answer is 'y'

    # Ask the user to provide the path to the folder containing the old backup
    $old_backup_folder = Read-Host "Please enter the path to the folder where the old backup has been downloaded (e.g., D:\downloaded_old_backup)"
    
        # Get a list of all backup files
    #define $listOutput with the contents of $old_backup_folder
    $listOutput = Get-ChildItem -Path $old_backup_folder | ForEach-Object {
    $_.Name
}

    # Display the files to be uploaded
    @"

    The following files will be uploaded:

"@
    $listOutput

    # Extraction not necessary in this case
    $fileNames = $listOutput

}

Write-Host @"

------------------------------------------

"@

cd $old_backup_folder

# Upload the old backup to the new target with progress indicator
$totalFiles = $fileNames.Count
$currentFile = 1
foreach ($fileName in $fileNames) {
    Write-Host "Uploading ($currentFile / $totalFiles): $fileName..."
    & $BackendTool_path PUT $newBackup_Target_URL $fileName
    $currentFile++
}

Write-Host @"

------------------------------------------

If your backup was successfully uploaded and you tested it and it is working, please consider whether you want to delete your downloaded old backup. Its location is:
$old_backup_folder

"@

#endregion