# Active Directory Home Lab — VirtualBox

A self-hosted Active Directory environment built on a Windows Server 2022 virtual machine running in VirtualBox. This project simulates the core responsibilities of an IT help desk or junior sysadmin role: standing up a domain controller, organizing users and computers into Organizational Units, managing security groups, and performing day-to-day account administration tasks like password resets and account enable/disable.

## Project Overview

- **Platform:** Oracle VirtualBox 7.2 (local)
- **VM:** `DC01` — Windows Server 2022 Datacenter Evaluation
- **Domain:** `corp.local`
- **NetBIOS name:** `CORP`
- **Roles installed:** Active Directory Domain Services (AD DS), DNS Server, Group Policy Management

## What This Project Demonstrates

- Deploying and configuring a Windows Server VM in VirtualBox
- Promoting a server to a domain controller and creating a new Active Directory forest
- Designing an OU structure that mirrors a real organization (IT, HR, Finance, Sales)
- Creating user accounts and assigning them to the correct OU
- Creating and managing security groups for department-based access control
- Performing common help desk tasks: password resets, account lockouts, enabling/disabling accounts
- PowerShell automation for bulk user provisioning, stale account detection, and security auditing

## Build Walkthrough

### 1. Creating the Virtual Machine

Configured a new VM named `DC01` in VirtualBox with Windows Server 2022 Datacenter Evaluation ISO, 2 vCPUs, 2GB RAM, and a 50GB virtual disk.

![VirtualBox VM setup](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20221951.png)

### 2. Windows Server Setup — Language Selection

Booted the VM from the ISO and selected English (United States) for language, time/currency, and keyboard layout.

![Windows setup language screen](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20222825.png)

### 3. Selecting the OS Edition

Selected **Windows Server 2022 Datacenter Evaluation (Desktop Experience)** to get the full GUI.

![OS edition selection](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20222854.png)

### 4. Disk Partitioning

Selected the 50GB unallocated virtual disk for OS installation.

![Disk selection](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20223003.png)

### 5. Administrator Password Setup

After installation completed, set the built-in Administrator password used for initial domain configuration.

![Administrator password setup](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20223603.png)

### 6. Installing AD DS — Server Selection

Opened **Add Roles and Features Wizard** and confirmed the destination server running Windows Server 2022 Datacenter Evaluation.

![Server selection](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20224013.png)

### 7. Confirming AD DS Installation

Reviewed the installation summary — Active Directory Domain Services, Group Policy Management, DNS Server, and all required management tools selected.

![AD DS confirmation](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20224117.png)

### 8. Installation Succeeded

AD DS installed successfully. The yellow banner prompts the next step: promoting this server to a domain controller.

![Installation succeeded](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20225343.png)

### 9. Promoting to Domain Controller — New Forest

Launched the AD DS Configuration Wizard. Selected **Add a new forest** and set the root domain name to `corp.local`.

![Deployment configuration](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20225517.png)

### 10. Additional Options — NetBIOS Name

Verified the NetBIOS domain name is set to `CORP`.

![Additional options](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20225843.png)

### 11. Prerequisites Check Passed

All prerequisite checks passed successfully. Ready to install.

![Prerequisites check](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20225905.png)

### 12. First Login as CORP\Administrator

After the server rebooted following domain controller promotion, the login screen now shows `CORP\Administrator` — confirming the domain is active.

![CORP Administrator login](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20230702.png)

### 13. Server Manager — Roles Confirmed

Server Manager dashboard now shows **AD DS** and **DNS** as active roles — the domain controller is fully operational.

![Server Manager with AD DS and DNS](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20230803.png)

### 14. Active Directory Users and Computers

Opened ADUC via Server Manager → Tools. The `Corp.local` domain is visible in the left pane.

![ADUC open](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20230835.png)

### 15. Building the OU Structure

Created four Organizational Units under `corp.local`: **IT**, **HR**, **Finance**, and **Sales**. Each department's users and groups live in their own OU, which makes applying Group Policy and delegating permissions much cleaner than dumping everyone into the default Users container.

![OU structure created](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20230955.png)

### 16. Creating Users — IT Department

Created **John Smith** (`jsmith@Corp.local`) in the IT OU with "User must change password at next logon" enforced — standard onboarding practice.

![John Smith in IT OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20231225.png)

### 17. Creating Users — HR Department

Created **Sarah Johnson** (`sjohnson@Corp.local`) in the HR OU.

![Sarah Johnson in HR OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20231336.png)

### 18. Creating Users — Finance Department

Created **Mike Davis** (`mdavis@Corp.local`) in the Finance OU.

![Mike Davis in Finance OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233137.png)

### 19. Creating Users — Sales Department

Created **Emily Chen** (`echen@Corp.local`) in the Sales OU.

![Emily Chen in Sales OU](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233235.png)

### 20. Security Groups — IT OU

Created `IT_Admins` security group in the IT OU alongside John Smith — demonstrating how users are assigned to groups for role-based access control.

![IT OU with IT_Admins group](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233045.png)

### 21. Security Groups — Finance OU

Created `Finance_Users` security group in the Finance OU alongside Mike Davis.

![Finance OU with Finance_Users group](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233318.png)

### 22. Password Reset — Sarah Johnson (HR)

Performed a password reset for Sarah Johnson in the HR OU, with "User must change password at next logon" enabled — standard practice for help desk password reset tickets.

![Password reset confirmation](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233854.png)

### 23. Disabling a User Account — Mike Davis

Disabled Mike Davis's account in the Finance OU — simulating an employee offboarding or a temporary access suspension.

![Mike Davis disabled](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233922.png)

### 24. Re-enabling a User Account — Mike Davis

Re-enabled Mike Davis's account — simulating a return from leave or a reversed offboarding action.

![Mike Davis re-enabled](https://raw.githubusercontent.com/harunsaglam85/active-directory-home-lab/main/screenshots/Screenshot%202026-06-21%20233947.png)

## Key Takeaways

This lab covers the foundational skills behind real-world IT support and sysadmin work: every "reset my password," "I can't log in," or "set up a new hire's account" ticket a help desk agent receives is rooted in the Active Directory concepts demonstrated here — OUs, security groups, and account lifecycle management. The PowerShell scripts go a step further, automating repetitive tasks that would otherwise eat up help desk time and introducing audit logging for accountability.

## Tools Used

- Oracle VirtualBox 7.2
- Windows Server 2022 Datacenter Evaluation
- Active Directory Domain Services (AD DS)
- Active Directory Users and Computers (ADUC)
- Group Policy Management Console
- PowerShell (AD Module)
- Windows Event Viewer
