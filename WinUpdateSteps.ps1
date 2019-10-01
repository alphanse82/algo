
mkdir C:\\WindowsUpdateList
$testvariable = 30
Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -AddServiceFlag 7 -Confirm:$false
$lst = Get-WUInstall -MicrosoftUpdate -AcceptAll -UpdateType Software -IgnoreReboot -IgnoreUserInput -Confirm:$false
$lst | ConvertTo-Json | Out-File C:\\WindowsUpdateList\\Allupdates.log -Force
$kblst =  $lst | Where-Object DownLoadPriority -lt 2 |Select-Object KB
$kblst | ConvertTo-Json | Out-File C:\\WindowsUpdateList\\selectedUpdate.log -Force
Get-WUInstall -KBArticleID $kblst  -AcceptAll -Install -IgnoreReboot -IgnoreUserInput -Confirm:$false