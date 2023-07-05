
source "hyperv-iso" "vm" {
  iso_url = "file:./../images/2022-packer-base.vhdx"
  iso_checksum = "none"
  // differencing_disk = true
  memory = 8192
  cpus = 4
  mac_address = "0000DBFFCAFE"
  generation = 2

  // enable only if nested virtualization is avaliable
  // enable_virtualization_extensions = true
  // enable_mac_spoofing = true

  headless = true
  // communicator = "winrm"
  // winrm_username = "installer"
  // winrm_password = "Passw0rd_"
  // winrm_use_ssl = false
  // winrm_insecure = true
  // If one or more scripts require a reboot it is suggested to leave this blank (since reboots may fail)
  // and instead specify the final shutdown command in your last script.
  // @see https://developer.hashicorp.com/packer/plugins/builders/hyperv/iso#shutdown_command
  shutdown_command = ""

  communicator = "ssh"
  ssh_username = "installer"
  ssh_password = "Passw0rd_"

  first_boot_device = "SCSI:0:0"

  // for debug
  // skip_compaction = true
  // skip_export = true
}

build {
  sources = ["source.hyperv-iso.vm"]

  provisioner "powershell" {
    inline = [
      "reg add \"HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters\" /v DisabledComponents /t REG_DWORD /d 255 /f",
      "Disable-NetAdapterBinding -InterfaceAlias '*' -ComponentID ms_tcpip6"
    ]
  }

  provisioner "powershell" {
    inline = [
      "Set-WinSystemLocale -SystemLocale zh-CN",
      "New-Item -Path C:\\image -ItemType Directory -Force"
    ]
  }

  provisioner "file" {
    destination = "C:\\image\\guard.ps1"
    source = "./packer/scripts/guard.ps1"
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/choco.ps1"
    ]
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/vclibs.ps1",
      "./packer/scripts/winget.ps1"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  provisioner "powershell" {
    inline = [
      "reg add \"HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters\" /v DisabledComponents /t REG_DWORD /d 255 /f",
      "Disable-NetAdapterBinding -InterfaceAlias '*' -ComponentID ms_tcpip6"
    ]
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/utils.ps1"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  provisioner "powershell" {
    inline = [
      "reg add \"HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters\" /v DisabledComponents /t REG_DWORD /d 255 /f",
      "Disable-NetAdapterBinding -InterfaceAlias '*' -ComponentID ms_tcpip6"
    ]
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/rust.ps1",
      "./packer/scripts/python.ps1",
      "./packer/scripts/vcpkg.ps1",
    ]
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/vs2019.ps1"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  provisioner "powershell" {
    inline = [
      "reg add \"HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters\" /v DisabledComponents /t REG_DWORD /d 255 /f",
      "Disable-NetAdapterBinding -InterfaceAlias '*' -ComponentID ms_tcpip6"
    ]
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/vs2022.ps1"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  provisioner "file" {
    destination = "C:\\image\\UnattendUniversal.xml"
    source = "./CustomResources/UnattendUniversal.xml"
  }

  provisioner "file" {
    destination = "C:\\image\\zapfree.exe"
    source = "./3rdparty/zapfree.exe"
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    inline = [
      "& \"C:\\image\\zapfree.exe\" -z C:"
    ]
  }

  provisioner "powershell" {
    execution_policy = "unrestricted"
    scripts = [
      "./packer/scripts/finalize.ps1"
    ]
    valid_exit_codes = [0, 2300218] # 2300218 for unexpected closed, which means machine shutted down by sysprep.
  }

}