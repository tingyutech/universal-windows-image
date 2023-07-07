. C:\image\guard.ps1

Exec-CommandRetry { choco install rustup.install --version 1.25.1 -y }
Exec-CommandRetry { choco install llvm --version 16.0.6 -y }
Exec-CommandRetry { choco install cmake.install --version 3.26.4 -y }
