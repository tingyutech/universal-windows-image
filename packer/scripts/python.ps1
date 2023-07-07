. C:\image\guard.ps1

Exec-CommandRetry { choco install python311 --version 3.11.4 -y }
Exec-CommandRetry { choco install python310 --version 3.10.11 -y }
Exec-CommandRetry { choco install python39 --version 3.9.13 -y }
