Write-Host "Downloading bootstrapper..."
iwr https://aka.ms/vs/16/release/vs_enterprise.exe -OutFile C:\image\vs2019.exe
Write-Host "Installing VS 2019 ..."
Start-Process -Wait -FilePath C:\image\vs2019.exe -ArgumentList @(
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
)