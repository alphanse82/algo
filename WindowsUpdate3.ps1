function InstallWindowsUpdate ($retryCount) {
        
    ((Get-WindowsUpdate)  | Select-Object KB, IsMandatory, DownloadPriority, Title ) | ConvertTo-Json | Out-File "C:\WindowsUpdateList\Allupdates_.log" -Force
    Install-WindowsUpdate -AcceptAll -IgnoreRebootRequired -IgnoreUserInput -Confirm:$false
}


$path = "C:\WindowsUpdateList"

if ( $false -eq (Test-Path $path)) {
    mkdir $path    
}

Set-ExecutionPolicy Unrestricted -Force

Import-Module PSWindowsUpdate

# adding Microsoft update to Server
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -AddServiceFlag 7 -Confirm:$false

$retryCount = 0;

Get-WUHistory | Out-File "C:\WindowsUpdateList\UpdateHistry_pre.log" -Force
InstallWindowsUpdate $retryCount
Get-WUHistory | Out-File "C:\WindowsUpdateList\UpdateHistry_post.log" -Force