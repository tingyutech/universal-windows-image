Write-Host "Restting installer password ..."
Add-Type -AssemblyName System.Web
$Password = [System.Web.Security.Membership]::GeneratePassword(64, 8)
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
Get-LocalUser -Name "installer" | Set-LocalUser -Password $SecurePassword

Write-Host "Setting Default SSH Shell to pwsh ..."
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell `
  -Value "C:\Program Files\Powershell\7\pwsh.exe" -PropertyType String -Force

Write-Host "Running Sysprep ..."
Start-Process -Wait "$ENV:SystemRoot\System32\Sysprep\Sysprep.exe" `
  -ArgumentList "/generalize /oobe /shutdown /unattend:`"C:\image\UnattendUniversal.xml`""

Write-Host "Finished Sysprep."
