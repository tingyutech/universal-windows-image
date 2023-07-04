Add-Type -AssemblyName System.Web
$Password = [System.Web.Security.Membership]::GeneratePassword(64, 8)
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
Get-LocalUser -Name "Administrator" | Set-LocalUser -Password $SecurePassword
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Type String -Value "Administrator"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Type String -Value $Password
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Type String -Value "1"
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonCount" -Force -Verbose -ErrorAction SilentlyContinue
