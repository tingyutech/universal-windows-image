. C:\image\guard.ps1

Write-Host "Downloading VS 2019 bootstrapper..."
Exec-CommandRetry {
  Invoke-WebRequest https://aka.ms/vs/16/release/vs_enterprise.exe -OutFile C:\image\vs2019.exe
}

Write-Host "Installing VS 2019 ..."
Start-ProcessCheck C:\image\vs2019.exe -ArgumentList @(
  "--includeRecommended"
  "--passive"
  "--norestart"
  "--force"
  "--installWhileDownloading"
  "--productKey BF8Y8GN2QHT84XBQVY3BRC4DF"
  "--addProductLang En-us"
  "--add Microsoft.VisualStudio.Workload.CoreEditor"
  "--add Microsoft.VisualStudio.Workload.ManagedDesktop"
  "--add Microsoft.VisualStudio.Workload.NativeDesktop"
  "--add Microsoft.VisualStudio.Workload.NetCoreTools"
) -AllowExitCodes @(
  0 # Operation completed successfully
  1641 #	Operation completed successfully, and reboot was initiated
  3010 #	Operation completed successfully, but install requires reboot before it can be used
)