Active Directory Home Lab
A documented home lab simulating a small enterprise Active Directory environment built on Windows Server 2022 running in VirtualBox. This project demonstrates the core skills required for IT help desk, junior sysadmin, and network administrator roles — standing up a domain controller, organizing users and computers into Organizational Units, managing security groups, and performing day-to-day account administration tasks.
---
Lab Environment
Component	Details
Hypervisor	Oracle VirtualBox 7.2
Domain Controller	Windows Server 2022 Datacenter Evaluation
VM Name	`DC01`
Domain	`corp.local`
NetBIOS Name	`CORP`
Roles Installed	AD DS, DNS Server, Group Policy Management
Host OS	Windows 11
---
What This Project Demonstrates
Provisioning a Windows Server VM in VirtualBox
Installing Active Directory Domain Services, DNS, and Group Policy Management
Promoting a server to a domain controller and creating a new forest
Designing an OU structure mirroring a real organization (IT, HR, Finance, Sales)
Creating and managing user accounts across multiple OUs
Creating department-based security groups and managing group membership
Performing common help desk tasks: password resets, account lockouts, enable/disable
---
Build Walkthrough
1. Creating the Virtual Machine
Configured a new VM named `DC01` in VirtualBox with Windows Server 2022 Datacenter Evaluation ISO, 2 vCPUs, 2GB RAM, and a 50GB virtual disk.
![VirtualBox VM setup](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20221951.png)
2. Windows Server Setup — Language Selection
Booted the VM from the ISO and selected English (United States) for language, time/currency, and keyboard layout.
![Windows setup language screen](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20222825.png)
3. Selecting the OS Edition
Selected Windows Server 2022 Datacenter Evaluation (Desktop Experience) to get the full GUI.
![OS edition selection](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20222854.png)
4. Disk Partitioning
Selected the 50GB unallocated virtual disk for OS installation.
![Disk selection](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20223003.png)
5. Administrator Password Setup
After installation completed, set the built-in Administrator password used for initial domain configuration.
![Administrator password setup](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20223603.png)
6. Installing AD DS — Server Selection
Opened Add Roles and Features Wizard and confirmed the destination server running Windows Server 2022 Datacenter Evaluation.
![Server selection](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20224013.png)
7. Confirming AD DS Installation
Reviewed the installation summary — Active Directory Domain Services, Group Policy Management, DNS Server, and all required management tools selected.
![AD DS confirmation](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20224117.png)
8. Installation Succeeded
AD DS installed successfully. The prompt to promote this server to a domain controller is now available.
![Installation succeeded](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20225343.png)
9. Promoting to Domain Controller — New Forest
Launched the AD DS Configuration Wizard. Selected Add a new forest and set the root domain name to `corp.local`.
![Deployment configuration](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20225517.png)
10. Additional Options — NetBIOS Name
Verified the NetBIOS domain name is set to `CORP`.
![Additional options](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20225843.png)
11. Prerequisites Check Passed
All prerequisite checks passed successfully. Ready to install.
![Prerequisites check](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20225905.png)
12. First Login as CORP\Administrator
After the server rebooted following domain controller promotion, the login screen now shows `CORP\Administrator` — confirming the domain is active.
![CORP Administrator login](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20230702.png)
13. Server Manager — Roles Confirmed
Server Manager dashboard now shows AD DS and DNS as active roles — the domain controller is fully operational.
![Server Manager with AD DS and DNS](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20230803.png)
14. Active Directory Users and Computers
Opened ADUC via Server Manager → Tools. The `Corp.local` domain is visible in the left pane.
![ADUC open](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20230835.png)
15. Building the OU Structure
Created four Organizational Units under `corp.local`: IT, HR, Finance, and Sales.
![OU structure created](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20230955.png)
16. Creating Users — IT Department
Created John Smith (`jsmith@Corp.local`) in the IT OU with "User must change password at next logon" enforced.
![John Smith in IT OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20231225.png)
17. Creating Users — HR Department
Created Sarah Johnson (`sjohnson@Corp.local`) in the HR OU.
![Sarah Johnson in HR OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20231336.png)
18. Creating Users — Finance Department
Created Mike Davis (`mdavis@Corp.local`) in the Finance OU.
![Mike Davis in Finance OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233137.png)
19. Creating Users — Sales Department
Created Emily Chen (`echen@Corp.local`) in the Sales OU.
![Emily Chen in Sales OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233235.png)
20. Security Groups — IT OU
Created `IT_Admins` security group in the IT OU alongside John Smith.
![IT OU with IT_Admins group](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233045.png)
21. Security Groups — Finance OU
Created `Finance_Users` security group in the Finance OU alongside Mike Davis.
![Finance OU with Finance_Users group](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233318.png)
22. Password Reset — Sarah Johnson
Performed a password reset for Sarah Johnson in the HR OU, simulating a help desk ticket.
![Password reset confirmation](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233854.png)
23. Disabling a User Account — Mike Davis
Disabled Mike Davis's account, simulating employee offboarding or temporary access suspension.
![Mike Davis disabled](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233922.png)
24. Re-enabling a User Account — Mike Davis
Re-enabled Mike Davis's account — simulating a return from leave or reversed offboarding.
![Mike Davis re-enabled](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/Screenshot%202026-06-21%20233947.png)
---
PowerShell Automation Scripts
Script	Purpose
`scripts/user-management/New-BulkUsers.ps1`	Bulk create users from CSV with OU routing and logging
`scripts/user-management/Reset-UserPassword.ps1`	Password reset with full audit trail
`scripts/security/Find-StaleAccounts.ps1`	Detect and optionally disable inactive accounts
`scripts/security/Get-PrivilegedAccounts.ps1`	Audit all members of privileged groups
`scripts/monitoring/Get-FailedLogins.ps1`	Detect brute force via Event ID 4625 parsing
---
Help Desk Runbook
User Can't Log In
```powershell
Get-ADUser -Identity username -Properties Enabled, LockedOut, PasswordExpired
Unlock-ADAccount -Identity username
Set-ADAccountPassword -Identity username -Reset -NewPassword (ConvertTo-SecureString "Temp@2024!" -AsPlainText -Force)
Set-ADUser -Identity username -ChangePasswordAtLogon $true
```
New User Onboarding Checklist
```
□ Create AD account in correct OU
□ Add to department security group
□ Set force-change-at-login
□ Deliver credentials verbally — never via email
□ Confirm first login successful
□ Log completion in ticketing system
```
Password Reset Process (Help Desk)
```
1. Verify caller identity (employee ID + manager name)
2. Reset: .\Reset-UserPassword.ps1 -Username "jsmith" -Reason "Ticket #1234"
3. Provide temp password verbally
4. Confirm force-change-at-login is set
5. Follow up in 30 min to confirm resolved
```
---
Skills Demonstrated
`Active Directory DS` `Organizational Units` `Security Groups` `Group Policy Management` `DNS` `PowerShell` `User Lifecycle Management` `Account Auditing` `Help Desk Workflows` `Windows Server 2022` `VirtualBox`
