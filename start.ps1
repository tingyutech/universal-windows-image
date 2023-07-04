$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

Import-Module .\windows-imaging-tools\WinImageBuilder.psm1 -Force
Import-Module .\windows-imaging-tools\Config.psm1 -Force
Import-Module .\windows-imaging-tools\UnattendResources\ini.psm1 -Force

$ConfigFilePath = $env:TEMP + "\config." + [System.IO.Path]::GetRandomFileName() + ".ini"
Copy-Item .\config.offline.ini $ConfigFilePath

$wimFilePath = if ($env:WIM_FILE_PATH) { $env:WIM_FILE_PATH } else { ".\wim\install.wim" };
$virtioFileName = if ($env:VIRTIO_ISO) { $env:VIRTIO_ISO } else { ".\3rdparty\virtio-win-0.1.229.iso" };
$externalSwitch = if ($env:EXTERNAL_SWITCH) { $env:EXTERNAL_SWITCH } else { "Bridge" };
$defaultImageName = "windows";

$wim = Get-WimFileImagesInfo -WimFilePath $wimFilePath
$image = $wim[0]
$flags = @("Enterprise", "ServerDataCenter", "ProfessionalWorkstation", "ServerStandard", "Professional", "ProfessionalEducation", "Education")

:flagLoop foreach ($flag in $flags) {
    foreach ($w in $wim) {
        if ($w.ImageFlags -eq $flag) {
            $image = $w
            $defaultImageName = "windows_" + $w.ImageEditionId + "_" + ($w.ImageVersion -replace '\.', '-') + "_" + $w.ImageDefaultLanguage
            break flagLoop
        }
    }
}

$imageOutputPath = if ($env:DISK_OUT_PATH) { $env:DISK_OUT_PATH } else { ".\images\" + $defaultImageName + "_" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".qcow2" };

Write-Host "Install Image: " $image.ImageName
Write-Host "Image Version: " $image.ImageVersion
Write-Host "Config File  : " $ConfigFilePath
Write-Host "Output File  : " $imageOutputPath

Set-IniFileValue -Path $configFilePath -Section "updates" -Key "install_updates" -Value "True"

Set-IniFileValue -Path $configFilePath -Section "Default" -Key "product_key" -Value "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"
Set-IniFileValue -Path $configFilePath -Section "Default" -Key "wim_file_path" -Value $wimFilePath
Set-IniFileValue -Path $configFilePath -Section "Default" -Key "image_name" -Value $image.ImageName
Set-IniFileValue -Path $configFilePath -Section "Default" -Key "image_path" -Value (Join-Path $PWD $imageOutputPath)
Set-IniFileValue -Path $configFilePath -Section "Default" -Key "custom_resources_path" -Value (Join-Path $PWD "CustomResources")
Set-IniFileValue -Path $configFilePath -Section "Default" -Key "custom_scripts_path" -Value (Join-Path $PWD "Scripts")
Set-IniFileValue -Path $configFilePath -Section "drivers" -Key "virtio_iso_path" -Value (Join-Path $PWD $virtioFileName)
Set-IniFileValue -Path $configFilePath -Section "cloudbase_init" -Key "msi_path" -Value (Join-Path $PWD "3rdparty\CloudbaseInitSetup_x64.msi")
Set-IniFileValue -Path $configFilePath -Section "cloudbase_init" -Key "cloudbase_init_config_path" -Value (Join-Path $PWD "cloudbase-init\cloudbase-init.conf")
Set-IniFileValue -Path $configFilePath -Section "cloudbase_init" -Key "cloudbase_init_unattended_config_path" -Value (Join-Path $PWD "cloudbase-init\cloudbase-init-unattend.conf")
Set-IniFileValue -Path $configFilePath -Section "vm" -Key "external_switch" -Value $externalSwitch

if ($env:BUILD_GOLD_IMAGE -eq "yes") {
    Set-IniFileValue -Path $configFilePath -Section "Default" -Key "gold_image" -Value "True"
    Set-IniFileValue -Path $configFilePath -Section "Default" -Key "image_type" -Value "Hyper-V"
}
if ($env:GOLD_IMAGE_PATH) {
    $RealGoldImagePath = $env:TEMP + "\gold_image_" + ([System.IO.Path]::GetRandomFileName() -replace '\.', '') + ".vhdx"
    Copy-Item $env:GOLD_IMAGE_PATH $RealGoldImagePath
    Set-IniFileValue -Path $configFilePath -Section "Default" -Key "gold_image_path" -Value $RealGoldImagePath

    New-WindowsFromGoldenImage -ConfigFilePath $ConfigFilePath
} elseif ($env:BUILD_ONLINE_IMAGE -eq "yes") {
    New-WindowsOnlineImage -ConfigFilePath $ConfigFilePath
} else {
    New-WindowsCloudImage -ConfigFilePath $ConfigFilePath
}

Remove-Item $ConfigFilePath

