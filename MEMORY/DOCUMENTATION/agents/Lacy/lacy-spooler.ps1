#requires -Version 7.0
[CmdletBinding()]
param(
    [string]$RuntimeName = 'Lacy',
    [string]$RuntimeProcessHint = 'lacy-launcher.py',
    [string]$RuntimeLauncher = 'C:\Users\Lacy.DarkCluster_SVR\Lacy64\lacy-launcher.py',
    [string]$LogPath = (Join-Path $PSScriptRoot 'lacy-spooler.log'),
    [int]$HeartbeatSeconds = 30,
    [int]$RestartDelaySeconds = 15
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:Mutex = $null

function Write-SpoolerLog {
    param(
        [string]$Level,
        [string]$Message
    )

    $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
    $line = "[$stamp] [$Level] $Message"
    Write-Host $line

    $logDir = Split-Path -Parent $LogPath
    if (-not [string]::IsNullOrWhiteSpace($logDir)) {
        [System.IO.Directory]::CreateDirectory($logDir) | Out-Null
    }

    Add-Content -Path $LogPath -Value $line -Encoding UTF8
}

function Enter-SingleInstanceLock {
    $mutexName = "Global\${RuntimeName}Spooler"
    $created = $false
    $script:Mutex = [System.Threading.Mutex]::new($true, $mutexName, [ref]$created)

    if (-not $created) {
        throw "Another $RuntimeName spooler instance is already running."
    }
}

function Get-RuntimeProcess {
    $candidates = Get-CimInstance Win32_Process | Where-Object {
        $_.Name -match 'python|pwsh|powershell' -and (
            $_.CommandLine -match [regex]::Escape($RuntimeProcessHint) -or
            $_.CommandLine -match [regex]::Escape($RuntimeLauncher)
        )
    }

    return $candidates
}

function Test-RuntimeHealthy {
    $processes = Get-RuntimeProcess
    if (-not $processes) {
        return $false
    }

    return $true
}

function Start-Runtime {
    if (-not (Test-Path $RuntimeLauncher)) {
        throw "Runtime launcher not found: $RuntimeLauncher"
    }

    Write-SpoolerLog -Level 'INFO' -Message "Starting runtime from $RuntimeLauncher"
    Start-Process -FilePath 'pwsh.exe' -ArgumentList @('-File', $RuntimeLauncher) -WindowStyle Normal | Out-Null
}

function Invoke-WatchdogLoop {
    Write-SpoolerLog -Level 'INFO' -Message "Watchdog started for $RuntimeName"

    while ($true) {
        try {
            if (Test-RuntimeHealthy) {
                Write-SpoolerLog -Level 'INFO' -Message 'Runtime healthy; sleeping.'
            }
            else {
                Write-SpoolerLog -Level 'WARN' -Message 'Runtime missing or unhealthy; restarting after delay.'
                Start-Sleep -Seconds $RestartDelaySeconds
                Start-Runtime
            }
        }
        catch {
            Write-SpoolerLog -Level 'ERROR' -Message $_.Exception.Message
        }

        Start-Sleep -Seconds $HeartbeatSeconds
    }
}

try {
    Enter-SingleInstanceLock
    Write-SpoolerLog -Level 'INFO' -Message 'Single-instance lock acquired.'
    Invoke-WatchdogLoop
}
finally {
    if ($script:Mutex) {
        $script:Mutex.ReleaseMutex() | Out-Null
        $script:Mutex.Dispose()
    }
}
