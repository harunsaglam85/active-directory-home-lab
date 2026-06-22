<#
.SYNOPSIS
    Find and optionally disable AD accounts inactive for N days.

.EXAMPLE
    .\Find-StaleAccounts.ps1 -DaysInactive 90 -ExportCsv ".\stale_accounts.csv"
    .\Find-StaleAccounts.ps1 -DaysInactive 90 -DisableAccounts $true
#>

param(
    [int]$DaysInactive = 90,
    [string]$ExportCsv = "",
    [bool]$DisableAccounts = $false
)

Import-Module ActiveDirectory -ErrorAction Stop

$Cutoff = (Get-Date).AddDays(-$DaysInactive)

Write-Host "Searching for accounts inactive since: $($Cutoff.ToString('yyyy-MM-dd'))" -ForegroundColor Cyan

$StaleUsers = Get-ADUser -Filter {
    LastLogonDate -lt $Cutoff -and Enabled -eq $true
} -Properties LastLogonDate, Department, Title, Manager |
Select-Object SamAccountName, DisplayName, Department, Title, LastLogonDate, DistinguishedName

Write-Host "Found $($StaleUsers.Count) stale accounts" -ForegroundColor Yellow

foreach ($User in $StaleUsers) {
    Write-Host "  $($User.SamAccountName) — Last login: $($User.LastLogonDate)" -ForegroundColor Gray
}

if ($ExportCsv -ne "") {
    $StaleUsers | Export-Csv -Path $ExportCsv -NoTypeInformation
    Write-Host "`nExported to: $ExportCsv" -ForegroundColor Green
}

if ($DisableAccounts) {
    foreach ($User in $StaleUsers) {
        Disable-ADAccount -Identity $User.SamAccountName
        Write-Host "Disabled: $($User.SamAccountName)" -ForegroundColor Red
    }
    Write-Host "`nDisabled $($StaleUsers.Count) stale accounts" -ForegroundColor Red
}
