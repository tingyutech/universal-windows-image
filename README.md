# Univeral Windows Image

## Download Files

* `wim\install.wim` from windows server 2022 iso X:\Sources\install.wim
* `CustomResources\SxS\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~~.cab` from windows server 2022 iso X:\Sources\SxS
* `CustomResources\OpenSSH-Win64-v9.2.2.0.msi` from [github](https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.2.2.0p1-Beta/OpenSSH-Win64-v9.2.2.0.msi)
* `3rdparty\CloudbaseInitSetup_x64.msi` from [cloudbase](https://www.cloudbase.it/downloads/CloudbaseInitSetup_x64.msi)
* `3rdparty\packer.exe` from [hashicorp](https://releases.hashicorp.com/packer/1.9.1/packer_1.9.1_windows_amd64.zip)
* `3rdparty\virtio-win-0.1.229.iso` from [fedora](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.229-1/virtio-win-0.1.229.iso)
* `3rdparty\zapfree.exe` from [github](https://github.com/felfert/ntfszapfree/releases/download/ntfszapfree-0.11/ntfszapfree.zip)

## Build

You have to run these scripts on a Windows machine which has Hyper-V enabled. Nested Virtualization is OK.

For the very first time before you can use packer:

```
.\3rdparty\packer.exe init .\config.pkr.hcl
```

For the every time when you have changed your wim:

```powershell
.\build-gold-image.bat
```

For the every time when you have changed custom resources:

```powershell
.\build-online-image.bat
.\covert-to-packer-base-vhdx.bat
```

And then for the every time when you have changed pakcer scripts:

```powershell
.\build-packer.bat
```

The built image will be located at `output-vm\Virtual Hard Disks\packer-vm.vhdx`.