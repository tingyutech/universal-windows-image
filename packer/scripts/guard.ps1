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
  $result = $?
  if (Test-Path variable:LASTEXITCODE) {
    if ($LASTEXITCODE -ne 0) {
      throw "Exec: $cmd exited with code $LASTEXITCODE"
    } else {
      Write-Host "Exec: successfully executed command: $cmd"
    }
  } else {
    if ($result -ne $true) {
      throw "Exec: $cmd failed"
    }
  }
}

function Exec-CommandRetry {
  [CmdletBinding()]
  Param(
    [Parameter(Position=0, Mandatory=$true)]
    [scriptblock]$ScriptBlock,

    [Parameter(Position=1, Mandatory=$false)]
    [int]$Maximum = 5,

    [Parameter(Position=2, Mandatory=$false)]
    [int]$Delay = 1000
  )

  Begin {
    $cnt = 0
  }

  Process {
    do {
      $cnt++
      try {
        Exec $ScriptBlock
        return
      } catch {
        Write-Error $_ -ErrorAction Continue
        if ($cnt -lt $Maximum + 1) {
          Write-Host "Waiting $Delay ms..."
          Start-Sleep -Milliseconds $Delay
          Write-Host "Retry $cnt / $Maximum"
        }
      }
    } while ($cnt -lt $Maximum + 1)

    # Throw an error after $Maximum unsuccessful invocations. Doesn't need
    # a condition, since the function returns upon successful invocation.
    throw 'Execution failed.'
  }
}
