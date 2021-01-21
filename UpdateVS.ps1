param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$installChannelUri
)

# Stop all devenv related processes
$vs = Get-Process devenv -ErrorAction SilentlyContinue
if ($vs) {
  $vs.CloseMainWindow()
  Start-Sleep -Seconds 5
  if (!$vs.HasExited) {
    $vs | Stop-Process -Force
  }
}

Get-Process Microsoft.ServiceHub.Controller -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process serviceHub.IdentityHost -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process serviceHub.VSDetouredHost -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process serviceHub.SettingsHost -ErrorAction SilentlyContinue | Stop-Process -Force

$updateVSLogFile = "c:\workspace\TestConsole\UpdateVS.log"
if (Test-Path $updateVSLogFile) {
    Remove-Item -Force $updateVSLogFile
  }

$resultFile = "c:\workspace\TestConsole\result.log"
if (Test-Path $resultFile) {
    Remove-Item -Force $resultFile
  }
  
Set-Content -Path $updateVSLogFile -Force -Value (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
Add-Content -Path $updateVSLogFile -Force -Value $installChannelUri
$vsInstanceManagerPath = "C:\vsonline\vsoagent\bin\VSInstanceManager.exe"
$installProcess = Start-Process $vsInstanceManagerPath -ArgumentList "update --installChannelUri `"$installChannelUri`"" -PassThru
$installProcess.WaitForExit()
$exitCode = $installProcess.ExitCode
Add-Content -Path $updateVSLogFile -Force -Value (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
Add-Content -Path $updateVSLogFile -Force -Value "Updating completed with exit code - $exitCode"
Set-Content -Path $resultFile -Force -Value $exitCode
