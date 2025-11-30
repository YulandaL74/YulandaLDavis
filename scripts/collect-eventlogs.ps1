# .SYNOPSIS
#   Collects recent Application and System event log entries and exports them to a timestamped file.

param(
    [string]$OutputDir = ".\reports",
    [int]$MaxEvents = 50,
    [string]$ComputerName = $env:COMPUTERNAME,
    [switch]$Compress
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Log {
    param([string]$Message)
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Write-Output "[$ts] $Message"
}

try {
    Write-Log "Starting event collection for computer: $ComputerName"
    if (-not (Test-Path -Path $OutputDir)) {
        Write-Log "Creating output directory: $OutputDir"
        New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
    }

    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $reportFile = Join-Path -Path $OutputDir -ChildPath "EventReport_$ComputerName`_$timestamp.txt"
    Write-Log "Report file: $reportFile"

    "Event Report for $ComputerName" | Out-File -FilePath $reportFile -Encoding UTF8
    "Generated: $(Get-Date -Format 'u')" | Out-File -FilePath $reportFile -Encoding UTF8 -Append
    "`n=== Application Log (most recent $MaxEvents entries) ===`n" | Out-File -FilePath $reportFile -Encoding UTF8 -Append

    try {
        $appEvents = Get-WinEvent -ComputerName $ComputerName -LogName Application -MaxEvents $MaxEvents -ErrorAction Stop
        foreach ($e in $appEvents) {
            $line = "{0} | Id:{1} | Level:{2} | Provider:{3} | Message:{4}" -f $e.TimeCreated, $e.Id, $e.LevelDisplayName, $e.ProviderName, ($e.Message -replace "`r`n", ' ')
            $line | Out-File -FilePath $reportFile -Encoding UTF8 -Append
        }
    }
    catch {
        "Failed to read Application log: $_" | Out-File -FilePath $reportFile -Encoding UTF8 -Append
    }

    "`n=== System Log (most recent $MaxEvents entries) ===`n" | Out-File -FilePath $reportFile -Encoding UTF8 -Append
    try {
        $sysEvents = Get-WinEvent -ComputerName $ComputerName -LogName System -MaxEvents $MaxEvents -ErrorAction Stop
        foreach ($e in $sysEvents) {
            $line = "{0} | Id:{1} | Level:{2} | Provider:{3} | Message:{4}" -f $e.TimeCreated, $e.Id, $e.LevelDisplayName, $e.ProviderName, ($e.Message -replace "`r`n", ' ')
            $line | Out-File -FilePath $reportFile -Encoding UTF8 -Append
        }
    }
    catch {
        "Failed to read System log: $_" | Out-File -FilePath $reportFile -Encoding UTF8 -Append
    }

    Write-Log "Finished writing report."

    if ($Compress) {
        $zipName = "$reportFile.zip"
        Write-Log "Compressing report to $zipName"
        Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
        [System.IO.Compression.ZipFile]::CreateFromDirectory((Split-Path -Path $reportFile -Parent), $zipName)
        Write-Log "Compression complete. Removing uncompressed file."
        Remove-Item -Path $reportFile -Force
        Write-Output $zipName
    }
    else {
        Write-Output $reportFile
    }
}
catch {
    Write-Log "ERROR: $_"
    exit 1
}