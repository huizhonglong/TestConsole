param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$installChannelUri
)

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
  -Argument "-NoProfile -WindowStyle Hidden -command `"& {Set-Content C:\workspace\Test.txt $installChannelUri -Force}`""
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(2)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "MyTestTask" -Description "Test"
