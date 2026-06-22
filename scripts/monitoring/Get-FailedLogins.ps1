<#
.SYNOPSIS
    Parse Security event log for failed logins (Event ID 4625).
    Flags accounts exceeding a threshold — potential brute force indicator.

.EXAMPLE
    .\Get-FailedLogins.ps1 -Hours 24 -Threshold 5
#>

param(
    [int]$Hours = 24,
    [int]$Threshold = 5,
    [string]$ComputerName = $env:COMPUTERNAME
)

Import-Module ActiveDirectory -ErrorAction Stop

$StartTime = (Get-Date).AddHours(-$Hours)

Write-Host "Scanning failed logins on $ComputerName since $($StartTime.ToString('yyyy-MM-dd HH:mm'))" -ForegroundColor Cyan

try {
    $Events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{
        LogName   = 'Security'
        Id        = 4625
        StartTime = $StartTime
    } -ErrorAction Stop
} catch {
    Write-Host "No failed login events found or access denied: $_" -ForegroundColor Yellow
    exit 0
}

# Group by username
$Summary = $Events | ForEach-Object {
    $xml = [xml]$_.ToXml()
    [PSCustomObject]@{
        Time        = $_.TimeCreated
        Username    = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'TargetUserName'} | Select-Object -ExpandProperty '#text'
        WorkStation = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'WorkstationName'} | Select-Object -ExpandProperty '#text'
        IP          = $xml.Event.EventData.Data | Where-Object {$_.Name -eq 'IpAddress'} | Select-Object -ExpandProperty '#text'
    }
} | Group-Object Username | Sort-Object Count -Descending

Write-Host "`n── Failed Login Summary ──────────────────────" -ForegroundColor White
foreach ($Entry in $Summary) {
    $flag = if ($Entry.Count -ge $Threshold) { " ⚠ THRESHOLD EXCEEDED" } else { "" }
    $color = if ($Entry.Count -ge $Threshold) { "Red" } else { "Gray" }
    Write-Host "  $($Entry.Count)x  $($Entry.Name)$flag" -ForegroundColor $color
}

$Flagged = $Summary | Where-Object { $_.Count -ge $Threshold }
if ($Flagged) {
    Write-Host "`n⚠  $($Flagged.Count) account(s) exceeded threshold of $Threshold failures" -ForegroundColor Red
    Write-Host "   Consider reviewing these accounts for lockout or brute force activity" -ForegroundColor Yellow
} else {
    Write-Host "`n✓ No accounts exceeded threshold" -ForegroundColor Green
}

Write-Host "`nTotal failed attempts in last ${Hours}h: $($Events.Count)" -ForegroundColor Cyan
