. C:\image\guard.ps1

Exec-CommandRetry -Delay 5000 -Maximum 20 { choco install rustup.install --version 1.25.1 -y }
Exec-CommandRetry -Delay 5000 -Maximum 20 { choco install llvm --version 16.0.6 -y }
Exec-CommandRetry -Delay 5000 -Maximum 20 { choco install cmake.install --version 3.26.4 -y }
