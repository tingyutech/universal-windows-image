Write-Host "Downloading vclibs ..."
iwr https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile $env:Temp\vclibsx64.appx
iwr https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx -OutFile $env:Temp\vclibsx86.appx

Write-Host "Installing packages ..."
Add-AppxPackage -Verbose $env:Temp\vclibsx64.appx
Add-AppxPackage -Verbose $env:Temp\vclibsx86.appx

Write-Host "Cleanup ..."
Remove-Item -Force $env:Temp\vclibsx64.appx
Remove-Item -Force $env:Temp\vclibsx86.appx
