$path = "C:\WindowsUpdateList"

if ( $false -eq (Test-Path $path)) {
    mkdir $path    
}

Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -AddServiceFlag 7 -Confirm:$false
