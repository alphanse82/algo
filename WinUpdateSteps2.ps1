function InstallWindowsUpdate ($retryCount) {
    $lst = Get-WUList -MicrosoftUpdate -AcceptAll -UpdateType Software -IgnoreReboot -IgnoreUserInput
    $lst | ConvertTo-Json | Out-File "C:\WindowsUpdateList\Allupdates$retryCount.log" -Force

    $kblst =  $lst | Where-Object DownloadPriority -eq 1 |Select-Object KB
    $kblst | ConvertTo-Json | Out-File C:\WindowsUpdateList\selectedUpdate.log -Append -Force

    foreach($kbUpdate in $kblst) {
        Get-WUInstall -KBArticleID $kbUpdate  -AcceptAll -Install -IgnoreReboot -IgnoreUserInput -Confirm:$false
    }

    $updateCount = ($kblst).Count

    if($updateCount -gt 1) {
        $retryCount = $retryCount  + 1

        if($retryCount -lt 2)  {
            InstallWindowsUpdate $retryCount
        }
    } 
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
