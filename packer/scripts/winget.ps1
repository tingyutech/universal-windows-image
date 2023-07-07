. C:\image\guard.ps1

$appxUrl = 'https://github.com/microsoft/winget-cli/releases/download/v1.6.1573-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$licenseUrl = 'https://github.com/microsoft/winget-cli/releases/download/v1.6.1573-preview/ba27c402ae29410eb93cfa9cb27f1376_License1.xml '

Write-Host "Downloading winget ..."
$ProgressPreference = 'SilentlyContinue'
Exec-CommandRetry {
  Invoke-WebRequest $appxUrl -OutFile $env:Temp\winget.msixbundle
}

Exec-CommandRetry {
  Invoke-WebRequest $licenseUrl -OutFile $env:Temp\license.xml
}

Write-Host "Installing winget ..."
Add-AppxProvisionedPackage -Online `
  -PackagePath $env:Temp\winget.msixbundle `
  -LicensePath $env:Temp\license.xml `
  -Verbose

Write-Host "Cleanup ..."
Remove-Item -Force $env:Temp\winget.msixbundle
Remove-Item -Force $env:Temp\license.xml
