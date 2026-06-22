<#
.SYNOPSIS
    Audit all members of privileged AD groups.
    Exports a report for security review.

.EXAMPLE
    .\Get-PrivilegedAccounts.ps1
#>

param(
    [string[]]$Groups = @("Domain Admins", "Schema Admins", "Enterprise Admins", "Administrators", "Group Policy Creator Owners")
)

Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "── Privileged Account Audit ─────────────────────────────" -ForegroundColor Cyan
Write-Host "  Run by : $env:USERNAME on $env:COMPUTERNAME"
Write-Host "  Date   : $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
Write-Host ""

$Report = @()

foreach ($GroupName in $Groups) {
    try {
        $Members = Get-ADGroupMember -Identity $GroupName -Recursive -ErrorAction Stop |
            Where-Object { $_.objectClass -eq 'user' } |
            ForEach-Object {
                Get-ADUser $_.SamAccountName -Properties LastLogonDate, Enabled, PasswordLastSet
            }

        Write-Host "  $GroupName ($($Members.Count) members)" -ForegroundColor Yellow

        foreach ($Member in $Members) {
            $flag = if (-not $Member.Enabled) { " [DISABLED]" } else { "" }
            Write-Host "    $($Member.SamAccountName)$flag — Last login: $($Member.LastLogonDate)" -ForegroundColor Gray

            $Report += [PSCustomObject]@{
                Group           = $GroupName
                Username        = $Member.SamAccountName
                DisplayName     = $Member.DisplayName
                Enabled         = $Member.Enabled
                LastLogon       = $Member.LastLogonDate
                PasswordLastSet = $Member.PasswordLastSet
            }
        }
        Write-Host ""

    } catch {
        Write-Host "  Could not query group '$GroupName': $_" -ForegroundColor Red
    }
}

$ExportPath = ".\logs\privileged-audit-$(Get-Date -Format 'yyyy-MM-dd').csv"
New-Item -ItemType Directory -Path ".\logs" -Force | Out-Null
$Report | Export-Csv -Path $ExportPath -NoTypeInformation
Write-Host "Report exported to: $ExportPath" -ForegroundColor Green
