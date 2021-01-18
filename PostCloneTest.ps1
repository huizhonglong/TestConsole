$stopAction = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {Stop-Process -Name devenv}"'
$stopTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(60)
Register-ScheduledTask -Action $stopAction -Trigger $stopTrigger -TaskName "StopDevenvTask" -Description "Stop devenv process"

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
  -Argument '-NoProfile -WindowStyle Hidden -command "& {Get-Date | Set-Content C:\workspace\Date.txt -Force}"'
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(2)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "MyTestTask" -Description "Logging time"
