. C:\image\guard.ps1

Exec-CommandRetry { choco install vcredist-all --version 1.0.1 -y }
Exec-CommandRetry { choco install powershell-core --version 7.3.5 -y }
Exec-CommandRetry { choco install 7zip-zstd --version 1.5.2.1 -y }
Exec-CommandRetry { choco install git --version 2.41.0 -y }
Exec-CommandRetry { choco install git-lfs --version 3.3.0 -y }
Exec-CommandRetry { choco install gitlab-runner --version 16.0.2 -y }
Exec-CommandRetry { choco install aria2 --version 1.36.0 -y }
Exec-CommandRetry { choco install jq --version 1.6 -y }
Exec-CommandRetry { choco install yq --version 4.33.3 -y }
Exec-CommandRetry { choco install vswhere --version 3.1.4 -y }
Exec-CommandRetry { choco install curl --version 8.1.2 -y }
Exec-CommandRetry { choco install wget --version 1.21.4 -y }
Exec-CommandRetry { choco install nuget.commandline --version 6.6.1 -y }
