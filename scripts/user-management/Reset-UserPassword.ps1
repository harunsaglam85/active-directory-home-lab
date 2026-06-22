<#
.SYNOPSIS
    Reset an AD user password with audit logging.

.EXAMPLE
    .\Reset-UserPassword.ps1 -Username "jsmith" -NewPassword "TempPass@2024!" -Reason "Ticket #4521"
#>

param(
    [Parameter(Mandatory=$true)][string]$Username,
    [Parameter(Mandatory=$true)][string]$NewPassword,
    [string]$Reason = "Help desk request",
    [bool]$ForceChange = $true
)

Import-Module ActiveDirectory -ErrorAction Stop

$LogFile = ".\logs\password-resets-$(Get-Date -Format 'yyyy-MM').log"
New-Item -ItemType Directory -Path ".\logs" -Force | Out-Null

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] [$env:USERNAME] $Message"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

try {
    $User = Get-ADUser -Identity $Username -Properties PasswordLastSet, LockedOut -ErrorAction Stop

    # Unlock if locked
    if ($User.LockedOut) {
        Unlock-ADAccount -Identity $Username
        Write-Log "Unlocked account: $Username"
    }

    # Reset password
    Set-ADAccountPassword -Identity $Username -Reset `
        -NewPassword (ConvertTo-SecureString $NewPassword -AsPlainText -Force) -ErrorAction Stop

    # Force change at login
    if ($ForceChange) {
        Set-ADUser -Identity $Username -ChangePasswordAtLogon $true
    }

    Set-ADUser -Identity $Username -Enabled $true

    Write-Log "Password reset successful — User: $Username | Reason: $Reason | ForceChange: $ForceChange"
    Write-Host "`nPassword reset complete for $($User.DisplayName)" -ForegroundColor Green

} catch {
    Write-Log "Password reset FAILED for $Username — $_" -Level "ERROR"
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
