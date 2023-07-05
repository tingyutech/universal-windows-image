Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

function Start-ProcessCheck {
  [CmdletBinding()]
  param (
    [Parameter(Position=0, Mandatory=1)][string] $ProcessName,
    [Parameter()][string[]] $ArgumentList,
    [Parameter()][int[]] $AllowExitCodes
  )

  $process = Start-Process -Wait -PassThru $ProcessName -ArgumentList $ArgumentList
  $code = $process.ExitCode
  if ($null -eq $AllowExitCodes) {
    $AllowExitCodes = @(0)
  }

  if (-not $code -in $AllowExitCodes) {
    throw "$ProcessName exited with code $code"
  }
}

# Taken from psake https://github.com/psake/psake
<#
.SYNOPSIS
  This is a helper function that runs a scriptblock and checks the PS variable $lastexitcode
  to see if an error occcured. If an error is detected then an exception is thrown.
  This function allows you to run command-line programs without having to
  explicitly check the $lastexitcode variable.
.EXAMPLE
  exec { svn info $repository_trunk } "Error executing SVN. Please verify SVN command-line client is installed"
#>
function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ("Error executing command {0}" -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}
