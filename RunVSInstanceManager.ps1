param(	
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$installChannelUri
)

$updateVSLogFile = "c:\test\UpdateVS.log"

if (Test-Path $updateVSLogFile) {
    Remove-Item -Force $updateVSLogFile
  }
$vsInstanceManagerPath = "C:\vsonline\vsoagent\bin\VSInstanceManager.exe"
$installProcess = Start-Process $vsInstanceManagerPath -ArgumentList "update --installChannelUri `"$installChannelUri`"" -PassThru
$installProcess.WaitForExit()
Set-Content -Path $updateVSLogFile -Force -Value $installProcess.ExitCode