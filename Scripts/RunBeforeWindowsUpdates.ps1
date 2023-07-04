Write-Host "Uninstalling Windows Defender ..."
Uninstall-WindowsFeature -Name Windows-Defender

Write-Host "Installing .Net FX 3.5 ..."
dism /online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /NoRestart /Source:C:\UnattendResources\CustomResources\SxS

$sshdService = Get-Service -Name sshd -ErrorAction SilentlyContinue
if ($sshdService -eq $null) {
  Write-Host "Deploying OpenSSH Server ..."
  Start-Process msiexec.exe -Wait -ArgumentList "/i C:\UnattendResources\CustomResources\OpenSSH-Win64-v9.2.2.0.msi /passive /norestart"

  if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
  } else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
  }

  Set-Service -Name sshd -StartupType 'Manual'
}
