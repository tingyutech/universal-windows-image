. C:\image\guard.ps1

Exec { git clone --branch 2023.06.20 --depth=1 https://github.com/microsoft/vcpkg C:\vcpkg }
Exec { & C:\vcpkg\bootstrap-vcpkg.bat -disableMetrics }
