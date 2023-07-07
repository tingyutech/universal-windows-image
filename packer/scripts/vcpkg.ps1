. C:\image\guard.ps1

Write-Host "Downloading vcpkg ..."
Exec-CommandRetry { git clone --branch 2023.06.20 --depth=1 https://github.com/microsoft/vcpkg C:\vcpkg }

Write-Host "Bootstraping vcpkg ..."
Exec { & C:\vcpkg\bootstrap-vcpkg.bat -disableMetrics }
