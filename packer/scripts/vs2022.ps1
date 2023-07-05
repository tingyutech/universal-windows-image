. C:\image\guard.ps1

Write-Host "Downloading bootstrapper..."
iwr https://aka.ms/vs/17/release/vs_enterprise.exe -OutFile C:\image\vs2022.exe
Write-Host "Installing VS 2022 ..."
Start-ProcessCheck -Wait -FilePath C:\image\vs2022.exe -ArgumentList @(
  "--includeRecommended"
  "--passive"
  "--norestart"
  "--force"
  "--installWhileDownloading"
  "--productKey VHF9HNXBBB638P66JHCY88JWH"
  "--addProductLang En-us"
  "--add Microsoft.VisualStudio.Workload.CoreEditor"
  "--add Microsoft.VisualStudio.Workload.ManagedDesktop"
  "--add Microsoft.VisualStudio.Workload.NativeDesktop"
  "--add Microsoft.VisualStudio.Workload.NetCrossPlat"
) -AllowExitCodes @(
  0 # Operation completed successfully
  1641 #	Operation completed successfully, and reboot was initiated
  3010 #	Operation completed successfully, but install requires reboot before it can be used
)