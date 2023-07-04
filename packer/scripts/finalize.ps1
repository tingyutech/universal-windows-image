Write-Host "Restting installer password ..."
Add-Type -AssemblyName System.Web
$Password = [System.Web.Security.Membership]::GeneratePassword(64, 8)
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
Get-LocalUser -Name "installer" | Set-LocalUser -Password $SecurePassword

Write-Host "Setting Default SSH Shell to pwsh ..."
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell `
  -Value "C:\Program Files\Powershell\7\pwsh.exe" -PropertyType String -Force

Write-Host "Remove auto login registry ..."
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Force -Verbose -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Force -Verbose -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Force -Verbose -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonCount" -Force -Verbose -ErrorAction SilentlyContinue

Write-Host "Set SSH Service not to start on boot ..."
Set-Service -Name sshd -StartupType 'Manual'

Write-Host "Running Sysprep ..."
Start-Process -Wait "$ENV:SystemRoot\System32\Sysprep\Sysprep.exe" `
  -ArgumentList "/generalize /oobe /shutdown /unattend:`"C:\image\UnattendUniversal.xml`""

Write-Host "Finished Sysprep."
