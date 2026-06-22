# Active Directory Home Lab

A documented home lab simulating a small enterprise Active Directory environment. Built to develop and demonstrate practical Windows Server administration, PowerShell automation, and IT support skills relevant to help desk and sysadmin roles.

---

## Lab Environment

| Component | Details |
|-----------|---------|
| Domain Controller | Windows Server 2022, domain: `corp.local` |
| Client Machine | Windows 10 Pro (domain-joined) |
| Hypervisor | VirtualBox 7.0 |
| Network | Host-only adapter, 192.168.56.0/24 |
| Domain Admin | `corp\Administrator` |

**Topology:**

```
┌─────────────────────────────────────────────┐
│              Host Machine (Windows 11)       │
│                                             │
│  ┌─────────────────┐   ┌─────────────────┐  │
│  │  DC01           │   │  CLIENT01       │  │
│  │  Windows Srv 22 │◄──│  Windows 10 Pro │  │
│  │  192.168.56.10  │   │  192.168.56.20  │  │
│  │  DNS / AD DS    │   │  Domain-joined  │  │
│  └─────────────────┘   └─────────────────┘  │
│                                             │
│         Host-Only Network: 192.168.56.0/24  │
└─────────────────────────────────────────────┘
```

---

## What's Covered

- [User Management](#user-management) — bulk provisioning, password resets, account lockouts
- [Group Policy](#group-policy) — password policy, desktop lockdown, drive mapping
- [Security](#security) — account auditing, lockout policy, privilege review
- [Monitoring](#monitoring) — event log parsing, failed login detection
- [Troubleshooting Runbook](#troubleshooting-runbook) — common help desk AD scenarios

---

## User Management

### Bulk User Creation from CSV

Creates users from a CSV file, sets department/OU, enforces password policy, and sends a summary report.

```powershell
# scripts/user-management/New-BulkUsers.ps1
.\New-BulkUsers.ps1 -CsvPath ".\users.csv" -DefaultPassword "Welcome@2024!" -ForcePasswordChange $true
```

**Sample CSV format:**
```csv
FirstName,LastName,Department,Title,Manager
John,Smith,IT,Help Desk Technician,jdoe
Sarah,Johnson,HR,HR Coordinator,mwilliams
Mike,Davis,Finance,Analyst,kbrown
```

### Password Reset

```powershell
# Reset with force-change at next login
.\Reset-UserPassword.ps1 -Username "jsmith" -NewPassword "TempPass@2024!" -ForceChange $true
```

### Account Unlock

```powershell
# Unlock a locked account and log the action
.\Unlock-UserAccount.ps1 -Username "jsmith" -Reason "User called help desk"
```

---

## Group Policy

### Policies Configured

| GPO Name | Scope | Purpose |
|----------|-------|---------|
| Corp-Password-Policy | Domain | Min 12 chars, complexity, 90-day expiry |
| Corp-Desktop-Lockdown | Domain Users OU | Disable control panel, enforce screensaver |
| Corp-Drive-Mapping | All Computers | Map H: to user home share, S: to shared drive |
| Corp-Software-Restriction | Domain Users OU | Block unauthorized executables |
| Corp-Windows-Update | All Computers | Force updates at 2 AM Sunday |

### Apply GPO Immediately

```powershell
# Force group policy refresh on remote machine
.\Invoke-GPUpdate.ps1 -ComputerName "CLIENT01" -Force $true
```

---

## Security

### Privilege Audit

```powershell
# List all members of Domain Admins and privileged groups
.\Get-PrivilegedAccounts.ps1 -Groups @("Domain Admins","Schema Admins","Enterprise Admins")
```

### Stale Account Detection

```powershell
# Find accounts inactive for 90+ days
.\Find-StaleAccounts.ps1 -DaysInactive 90 -ExportCsv ".\stale_accounts.csv"
```

### Lockout Policy Verification

```powershell
# Verify domain lockout policy matches security baseline
.\Test-LockoutPolicy.ps1 -RequiredThreshold 5 -RequiredDuration 30
```

---

## Monitoring

### Failed Login Detection

```powershell
# Parse Security event log for Event ID 4625 (failed logon)
.\Get-FailedLogins.ps1 -Hours 24 -Threshold 5 -AlertEmail "admin@corp.local"
```

### Event Log Summary

```powershell
# Pull critical events from the last 24 hours
.\Get-EventSummary.ps1 -ComputerName "DC01" -Hours 24 -EventTypes @("Error","Warning","Critical")
```

---

## Troubleshooting Runbook

Common help desk scenarios and resolution steps.

### User Can't Log In

```
1. Check account is enabled:
   Get-ADUser -Identity username -Properties Enabled, LockedOut, PasswordExpired

2. Check if locked out:
   Search-ADAccount -LockedOut | Where-Object {$_.SamAccountName -eq "username"}

3. Unlock if locked:
   Unlock-ADAccount -Identity username

4. Check password expiry:
   Get-ADUser -Identity username -Properties PasswordExpired, PasswordLastSet

5. Reset if expired:
   Set-ADAccountPassword -Identity username -Reset -NewPassword (ConvertTo-SecureString "TempPass@2024!" -AsPlainText -Force)
   Set-ADUser -Identity username -ChangePasswordAtLogon $true

6. Verify domain connectivity on client:
   nltest /sc_verify:corp.local
   Test-ComputerSecureChannel -Verbose
```

### Computer Not Applying Group Policy

```
1. Check GP is applying:
   gpresult /r (on client machine)

2. Check for errors:
   gpresult /h gpreport.html

3. Force refresh:
   Invoke-GPUpdate /force

4. Check time sync (Kerberos requires <5 min drift):
   w32tm /query /status
   w32tm /resync

5. Check DNS resolves DC:
   nslookup corp.local
   nslookup dc01.corp.local
```

### Password Reset Process (Help Desk)

```
1. Verify caller identity (employee ID + manager name)
2. Reset via script:
   .\Reset-UserPassword.ps1 -Username "jsmith" -Reason "Help desk ticket #12345"
3. Provide temp password verbally — never via email
4. Set force-change-at-login flag
5. Log ticket with timestamp and reason
6. Follow up in 30 min to confirm resolved
```

### New User Onboarding Checklist

```
□ Create AD account (.\New-BulkUsers.ps1 or manual)
□ Add to appropriate security groups
□ Create home folder (H: drive)
□ Assign email in Exchange/365
□ Add to distribution lists
□ Set up MFA
□ Deliver credentials securely (never via email)
□ Confirm first login successful
□ Log completion in ticketing system
```

---

## Key Concepts Demonstrated

- **Active Directory DS** — users, groups, OUs, domain structure
- **Group Policy** — GPO creation, linking, filtering, troubleshooting
- **PowerShell automation** — AD module, bulk operations, error handling, logging
- **Security baseline** — password policy, lockout policy, privilege of least access
- **Event log analysis** — parsing Windows Security logs for audit and incident detection
- **Help desk workflows** — structured troubleshooting, documentation, escalation paths

---

## Skills Developed

`Windows Server 2022` `Active Directory` `PowerShell` `Group Policy` `DNS` `DHCP` `Event Viewer` `Help Desk Workflows` `Security Auditing` `User Lifecycle Management`
