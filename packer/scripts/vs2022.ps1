Write-Host "Downloading bootstrapper..."
iwr https://aka.ms/vs/17/release/vs_enterprise.exe -OutFile C:\image\vs2022.exe
Write-Host "Installing VS 2022 ..."
Start-Process -Wait -FilePath C:\image\vs2022.exe -ArgumentList @(
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
)