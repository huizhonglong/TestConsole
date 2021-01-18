param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$installChannelUri
)

$vs = Get-Process devenv -ErrorAction SilentlyContinue
if ($vs) {
  $vs.CloseMainWindow()
  Start-Sleep -Seconds 5
  if (!$vs.HasExited) {
    $vs | Stop-Process -Force
  }
}

$updateVSLogFile = "c:\workspace\UpdateVS.log"
if (Test-Path $updateVSLogFile) {
    Remove-Item -Force $updateVSLogFile
  }

Set-Content -Path $updateVSLogFile -Force -Value (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
Add-Content -Path $updateVSLogFile -Force -Value $installChannelUri
$vsInstanceManagerPath = "C:\vsonline\vsoagent\bin\VSInstanceManager.exe"
$installProcess = Start-Process $vsInstanceManagerPath -ArgumentList "update --installChannelUri `"$installChannelUri`"" -PassThru
$installProcess.WaitForExit()
Add-Content -Path $updateVSLogFile -Force -Value (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
Add-Content -Path $updateVSLogFile -Force -Value "Updating completed with exit code - $($installProcess.ExitCode)"
