# [Unofficial] Duplicati-Backup-Migration




**Author:** Unpledged3967 from [forum.duplicati.com](https://forum.duplicati.com)  
**Date:** 2025-03-21  
**Version:** 1.0  


## Limitations

- Unfortunately, my own migration failed after 590 files, as Google cut off my access at that point. Maybe you are more lucky or your backup is smaller.
- Speed is affected by the sequential processing of many small (50MB in my case) files. The upload reaches the full upload speed of my contract, but the constant starting and stopping makes it a bit slow. It took about 1.5 hours with a 50Mb/s upload.


## Intention

This tool is made to migrate backups from one source to another using Duplicati.CommandLine.BackendTool.exe. In my case, it was supposed to get a backup off Mega and upload it to Google Drive.

This can also be used to just upload already downloaded backup files (lots of "duplicati-xxxxxx.zip" files). Which of these options you want will be asked during the script.
