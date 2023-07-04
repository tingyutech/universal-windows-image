cd %~dp0
.\windows-imaging-tools\bin\qemu-img.exe convert -f qcow2 -O vhdx -m 8 .\images\2022-online.qcow2 .\images\2022-packer-base.vhdx
powershell "Resize-VHD -Path .\images\2022-packer-base.vhdx -SizeBytes 200GB"
powershell "Set-VHD -Path .\images\2022-packer-base.vhdx -ResetDiskIdentifier -Force"