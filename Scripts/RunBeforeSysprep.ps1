
Write-Host "Update Cloudbase Init Unattend xml ..."
$cloudbaseInitInstallDir = Join-Path $ENV:ProgramFiles "Cloudbase Solutions\Cloudbase-Init"
$unattendedXmlPath = "${cloudbaseInitInstallDir}\conf\Unattend.xml"
Copy-Item -Force C:\UnattendResources\CustomResources\UnattendUniversal.xml $unattendedXmlPath
