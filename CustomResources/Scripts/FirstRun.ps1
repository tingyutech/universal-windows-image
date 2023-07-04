Write-Output "Setting up Auto Login ..."
$arguments = "-ExecutionPolicy Unrestricted -file " + "C:\UniversalImageScripts\SetRandomPassword.ps1" + " -IsRunAsAdmin"
Start-Process "$psHome\powershell.exe" -Wait -Verb runAs -ArgumentList $arguments

Write-Output "Disabling IPv6 ..."
Disable-NetAdapterBinding -InterfaceAlias '*' -ComponentID ms_tcpip6

Write-Host "Setting local execution policy"
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine  -ErrorAction Continue | Out-Null

Write-Output "Create Installer Account ..."
& net user installer Passw0rd_ /add /passwordchg:no /passwordreq:yes /active:yes /Y
& net localgroup Administrators installer /add

Write-Output "Starting WinRM ..."
& winrm quickconfig -q
& winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
& winrm set winrm/config/winrs '@{MaxConcurrentUsers="100"}'
& winrm set winrm/config/winrs '@{MaxProcessesPerShell="0"}'
& winrm set winrm/config/winrs '@{MaxShellsPerUser="0"}'
& winrm set winrm/config '@{MaxTimeoutms="7200000"}'
& winrm set winrm/config/service '@{AllowUnencrypted="true"}'
& winrm set winrm/config/service/auth '@{Basic="true"}'
& winrm set winrm/config/service/auth '@{CredSSP="true"}'
& winrm set winrm/config/client '@{TrustedHosts="*"}'
& netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
& sc.exe config winrm start=auto

Set-Service -Name sshd -StartupType 'Automatic'
Start-Service sshd

Write-Host "Disable Server Manager on Logon"
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask

Write-Host "Disable 'Allow your PC to be discoverable by other PCs' popup"
New-Item -Path HKLM:\System\CurrentControlSet\Control\Network -Name NewNetworkWindowOff -Force

Write-Host "Disable UAC"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 -Force

Write-Host "Enable long path behavior"
# See https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file#maximum-path-length-limitation
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
