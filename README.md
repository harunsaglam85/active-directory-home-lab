Active Directory Home Lab

A documented home lab simulating a small enterprise Active Directory environment built on Windows Server 2022 running in VirtualBox. This project demonstrates the core skills required for IT help desk, junior sysadmin, and network administrator roles — standing up a domain controller, organizing users and computers into Organizational Units, managing security groups, and performing day-to-day account administration tasks.


Lab Environment

ComponentDetailsHypervisorOracle VirtualBox 7.2Domain ControllerWindows Server 2022 Datacenter EvaluationVM NameDC01Domaincorp.localNetBIOS NameCORPRoles InstalledAD DS, DNS Server, Group Policy ManagementHost OSWindows 11


What This Project Demonstrates


Provisioning a Windows Server VM in VirtualBox
Installing Active Directory Domain Services, DNS, and Group Policy Management
Promoting a server to a domain controller and creating a new forest
Designing an OU structure mirroring a real organization (IT, HR, Finance, Sales)
Creating and managing user accounts across multiple OUs
Creating department-based security groups and managing group membership
Performing common help desk tasks: password resets, account lockouts, enable/disable



Build Walkthrough

1. Creating the Virtual Machine

Configured a new VM named DC01 in VirtualBox with Windows Server 2022 Datacenter Evaluation ISO, 2 vCPUs, 2GB RAM, and a 50GB virtual disk.

Show Image

2. Windows Server Setup — Language Selection

Booted the VM from the ISO and selected English (United States) for language, time/currency, and keyboard layout.

Show Image

3. Selecting the OS Edition

Selected Windows Server 2022 Datacenter Evaluation (Desktop Experience) to get the full GUI.

Show Image

4. Disk Partitioning

Selected the 50GB unallocated virtual disk for OS installation.

Show Image

5. Administrator Password Setup

After installation completed, set the built-in Administrator password used for initial domain configuration.

Show Image

6. Installing AD DS — Server Selection

Opened Add Roles and Features Wizard and confirmed the destination server running Windows Server 2022 Datacenter Evaluation.

Show Image

7. Confirming AD DS Installation

Reviewed the installation summary — Active Directory Domain Services, Group Policy Management, DNS Server, and all required management tools selected.

Show Image

8. Installation Succeeded

AD DS installed successfully. The prompt to promote this server to a domain controller is now available.

Show Image

9. Promoting to Domain Controller — New Forest

Launched the AD DS Configuration Wizard. Selected Add a new forest and set the root domain name to corp.local.

Show Image

10. Additional Options — NetBIOS Name

Verified the NetBIOS domain name is set to CORP.

Show Image

11. Prerequisites Check Passed

All prerequisite checks passed successfully. Ready to install.

Show Image

12. First Login as CORP\Administrator

After the server rebooted following domain controller promotion, the login screen now shows CORP\Administrator — confirming the domain is active.

Show Image

13. Server Manager — Roles Confirmed

Server Manager dashboard now shows AD DS and DNS as active roles — the domain controller is fully operational.

Show Image

14. Active Directory Users and Computers

Opened ADUC via Server Manager → Tools. The Corp.local domain is visible in the left pane.

Show Image

15. Building the OU Structure

Created four Organizational Units under corp.local: IT, HR, Finance, and Sales. Each department's users and groups live in their own OU.

Show Image

16. Creating Users — IT Department

Created John Smith (jsmith@Corp.local) in the IT OU with "User must change password at next logon" enforced.

Show Image

17. Creating Users — HR Department

Created Sarah Johnson (sjohnson@Corp.local) in the HR OU.

Show Image

18. Creating Users — Finance Department

Created Mike Davis (mdavis@Corp.local) in the Finance OU.

Show Image

19. Creating Users — Sales Department

Created Emily Chen (echen@Corp.local) in the Sales OU.

Show Image

20. Security Groups — IT OU

Created IT_Admins security group in the IT OU alongside John Smith. Department-based security groups allow permissions to be managed at the group level rather than per-user.

Show Image

21. Security Groups — Finance OU

Created Finance_Users security group in the Finance OU alongside Mike Davis.

Show Image

22. Password Reset — Sarah Johnson

Performed a password reset for Sarah Johnson in the HR OU, simulating a help desk ticket. Confirmation dialog confirms the password was changed successfully.

Show Image

23. Disabling a User Account — Mike Davis

Disabled Mike Davis's account, simulating employee offboarding or temporary access suspension.

Show Image

24. Re-enabling a User Account — Mike Davis

Re-enabled Mike Davis's account — simulating a return from leave or reversed offboarding.

Show Image


PowerShell Automation Scripts

ScriptPurposescripts/user-management/New-BulkUsers.ps1Bulk create users from CSV with OU routing and loggingscripts/user-management/Reset-UserPassword.ps1Password reset with full audit trailscripts/security/Find-StaleAccounts.ps1Detect and optionally disable inactive accountsscripts/security/Get-PrivilegedAccounts.ps1Audit all members of privileged groupsscripts/monitoring/Get-FailedLogins.ps1Detect brute force via Event ID 4625 parsing


Help Desk Runbook

User Can't Log In

powershellGet-ADUser -Identity username -Properties Enabled, LockedOut, PasswordExpired
Unlock-ADAccount -Identity username
Set-ADAccountPassword -Identity username -Reset -NewPassword (ConvertTo-SecureString "Temp@2024!" -AsPlainText -Force)
Set-ADUser -Identity username -ChangePasswordAtLogon $true

New User Onboarding Checklist

□ Create AD account in correct OU
□ Add to department security group
□ Set force-change-at-login
□ Deliver credentials verbally — never via email
□ Confirm first login successful
□ Log completion in ticketing system

Password Reset Process (Help Desk)

1. Verify caller identity (employee ID + manager name)
2. Reset: .\Reset-UserPassword.ps1 -Username "jsmith" -Reason "Ticket #1234"
3. Provide temp password verbally
4. Confirm force-change-at-login is set
5. Follow up in 30 min to confirm resolved


Skills Demonstrated

Active Directory DS Organizational Units Security Groups Group Policy Management DNS PowerShell User Lifecycle Management Account Auditing Help Desk Workflows Windows Server 2022 VirtualBox
