<#
.SYNOPSIS
    Bulk create Active Directory users from a CSV file.

.DESCRIPTION
    Reads a CSV of users, creates AD accounts in the appropriate OU,
    sets department, title, manager, and forces password change at first login.
    Logs all actions to a timestamped log file.

.PARAMETER CsvPath
    Path to the CSV file containing user data.

.PARAMETER DefaultPassword
    Temporary password assigned to all new accounts.

.PARAMETER ForcePasswordChange
    If true, user must change password at next login.

.EXAMPLE
    .\New-BulkUsers.ps1 -CsvPath ".\users.csv" -DefaultPassword "Welcome@2024!" -ForcePasswordChange $true
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$CsvPath,

    [Parameter(Mandatory=$true)]
    [string]$DefaultPassword,

    [bool]$ForcePasswordChange = $true
)

# ── Config ────────────────────────────────────────────────────────────────────
$Domain     = "corp.local"
$BaseOU     = "OU=Users,DC=corp,DC=local"
$LogFile    = ".\logs\bulk-user-creation-$(Get-Date -Format 'yyyy-MM-dd-HHmm').log"
$ErrorCount = 0
$SuccessCount = 0

# ── Setup ─────────────────────────────────────────────────────────────────────
Import-Module ActiveDirectory -ErrorAction Stop
New-Item -ItemType Directory -Path ".\logs" -Force | Out-Null

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

Write-Log "Starting bulk user creation from: $CsvPath"

# ── Validate CSV ──────────────────────────────────────────────────────────────
if (-not (Test-Path $CsvPath)) {
    Write-Log "CSV file not found: $CsvPath" -Level "ERROR"
    exit 1
}

$Users = Import-Csv $CsvPath
Write-Log "Loaded $($Users.Count) users from CSV"

# ── Process each user ─────────────────────────────────────────────────────────
foreach ($User in $Users) {
    try {
        $FirstName  = $User.FirstName.Trim()
        $LastName   = $User.LastName.Trim()
        $Department = $User.Department.Trim()
        $Title      = $User.Title.Trim()
        $Username   = ($FirstName[0] + $LastName).ToLower() -replace '\s', ''
        $UPN        = "$Username@$Domain"
        $DisplayName = "$FirstName $LastName"

        # Check if user already exists
        if (Get-ADUser -Filter {SamAccountName -eq $Username} -ErrorAction SilentlyContinue) {
            Write-Log "User already exists, skipping: $Username" -Level "WARN"
            continue
        }

        # Determine OU based on department
        $OU = "OU=$Department,$BaseOU"
        if (-not ([ADSI]::Exists("LDAP://$OU"))) {
            Write-Log "OU not found for department '$Department', using base OU" -Level "WARN"
            $OU = $BaseOU
        }

        # Create the user
        $SecurePassword = ConvertTo-SecureString $DefaultPassword -AsPlainText -Force

        New-ADUser `
            -SamAccountName      $Username `
            -UserPrincipalName   $UPN `
            -Name                $DisplayName `
            -GivenName           $FirstName `
            -Surname             $LastName `
            -DisplayName         $DisplayName `
            -Department          $Department `
            -Title               $Title `
            -AccountPassword     $SecurePassword `
            -ChangePasswordAtLogon $ForcePasswordChange `
            -Enabled             $true `
            -Path                $OU `
            -ErrorAction Stop

        Write-Log "Created user: $Username ($DisplayName) in OU: $OU"
        $SuccessCount++

    } catch {
        Write-Log "Failed to create user $($User.FirstName) $($User.LastName): $_" -Level "ERROR"
        $ErrorCount++
    }
}

# ── Summary ───────────────────────────────────────────────────────────────────
Write-Log "──────────────────────────────────"
Write-Log "Bulk creation complete"
Write-Log "  Success : $SuccessCount"
Write-Log "  Errors  : $ErrorCount"
Write-Log "  Log     : $LogFile"
