. C:\image\guard.ps1

Exec-CommandRetry -Delay 5000 -Maximum 20 { choco install python311 --version 3.11.4 -y }
Exec-CommandRetry -Delay 5000 -Maximum 20 { choco install python310 --version 3.10.11 -y }
Exec-CommandRetry -Delay 5000 -Maximum 20 { choco install python39 --version 3.9.13 -y }
