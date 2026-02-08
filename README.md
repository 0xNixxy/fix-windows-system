# fix-windows-system

<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD042 -->

<div align = "center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

![Made with PowerShell 5.1](https://img.shields.io/badge/PowerShell-5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Tested on Windows 11 25H2](https://img.shields.io/badge/Windows%2011-25H2-0079d5?style=for-the-badge&logo=Windows%2011&logoColor=white)

</div>

<!-- markdownlint-enable MD042 -->
<!-- markdownlint-enable MD033 -->

## Overview

This repo contains standalone scripts to automatically detect and repair
corruption(s) found in the system components and filesystem of a Windows 11
operating system (OS). The scripts uses only tools that come pre-packaged with
the Windows 11 Home OS and does not require installation of any third-party
software.

For PowerShell users, use `FixWindowsSystem.ps1`. As PowerShell 5.1 is packaged
together with Windows 11, this PowerShell script has been written to use only
[PowerShell 5.1 commands](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/?view=powershell-5.1).

## Windows system repair workflow

The script repairs Windows in the following steps:

1. Detect and repair corruption in the current Windows operating system image
   using the
   [Repair-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/repair-windowsimage)
   cmdlet or [DISM](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/what-is-dism?view=windows-11)
   tool. `Repair-WindowsImage` is a PowerShell equivalent to `DISM` tool.

1. Detect and repair corruption in Windows system files using the
   [sfc](https://learn.microsoft.com/en-us/troubleshoot/windows-server/deployment/system-file-checker)
   tool. There seems to be no PowerShell equivalent for this tool.

1. Detect and repair corruption in Windows file system using
   [Repair-Volume](https://learn.microsoft.com/en-us/powershell/module/storage/repair-volume)
   cmdlet or [chkdsk](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk)
   tool. `Repair-Volume` is a PowerShell equivalent to `chkdsk` tool.

1. Optimise file system (i.e. defrag HDD or retrim SSD) of current volume using
   [Optimize-Volume](https://learn.microsoft.com/en-us/powershell/module/storage/optimize-volume)
   cmdlet or [defrag](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/defrag)
   tool. `Optimize-Volume` is a PowerShell equivalent to `defrag` tool.

## Usage guide for PowerShell users

To use the script on your Windows 11 system

1. Download `FixWindowsSystem.ps1` to computer.

1. Open PowerShell Terminal with Administrator privileges.

1. (Optional pre-requisite) If you have problems executing PowerShell scripts on
   your local machine, you may need to first perform a one-time relaxing of
   PowerShell Execution Policy in PowerShell Terminal with Administrator
   privileges.

   ```PowerShell
   Set-ExecutionPolicy -ExecutionPolicy Bypass
   ```

   You can check your current policy with the command below.

   ```PowerShell
   Get-ExecutionPolicy -List
   ```

1. (Optional) If your active Windows account is a standard user account
   (i.e., non-admin account), you can copy the script to your admin account's
   folder for convenience.

   ```PowerShell
   copy ..\user\Downloads\FixWindowsSystem.ps1 .
   ```

1. (Optional pre-requisite) Your Windows system may highlight a security warning
   about running scripts downloaded from the internet and display the message
   below.

   ```Text
   Security warning
   Run only scripst that you trust. While scripts from the internet can be
   useful, this script can potentially harm your computer. If you trust this
   script, use the Unblock-File cmdlet to allow the script to run without this
   warning message. Do you want to run C:\...\FixWindowsSystem.ps1?
   ```

   You can mark the script as "safe to run" with the command below.

   ```PowerShell
   Unblock-File .\FixWindowsSystem.ps1
   ```

1. Execute the script in `Terminal (Admin)`  and wait for the repairs to finish.

   ```PowerShell
   .\FixWindowsSystem.ps1
   ```

   A successful run will produce an output similar as follows

   ```console
   PS C:\Users\user\Downloads> .\FixWindowsSystem.ps1
   Fix Windows System by 0xNixxy v1.0.1

   🔍 Checking Windows Component Store...

   Path             :
   Online           : True
   ImageHealthState : Healthy
   RestartNeeded    : False

   ✅ No issues found. Windows Component Store is healthy.

   🔄 Run 1 of 2: Checking Windows system files...

   Beginning system scan.  This process will take some time.

   Beginning verification phase of system scan.
   Verification 100% complete.

   Windows Resource Protection did not find any integrity violations.

   🔄 Run 2 of 2: Checking Windows system files...

   Beginning system scan.  This process will take some time.

   Beginning verification phase of system scan.
   Verification 100% complete.

   Windows Resource Protection did not find any integrity violations.

   🔍 Checking disk volume...
   ✅ No issues found. Disk volume is healthy.
   🧹 Optimising disk volume to improve performance and storage efficiency...
   VERBOSE: Invoking retrim on (C:)...
   VERBOSE: Retrim:  0% complete...
   VERBOSE: Retrim:  100% complete.
   VERBOSE: Performing pass 1:
   VERBOSE: Retrim:  87% complete...
   VERBOSE: Retrim:  88% complete...
   VERBOSE: Retrim:  92% complete...
   VERBOSE: Retrim:  96% complete...
   VERBOSE: Retrim:  100% complete.
   VERBOSE:
   Post Defragmentation Report:
   VERBOSE:
   Volume Information:
   VERBOSE:   Volume size                 = 463.98 GB
   VERBOSE:   Cluster size                = 4 KB
   VERBOSE:   Used space                  = 380.66 GB
   VERBOSE:   Free space                  = 83.32 GB
   VERBOSE:
   Retrim:
   VERBOSE:   Backed allocations          = 464
   VERBOSE:   Allocations trimmed         = 5096
   VERBOSE:   Total space trimmed         = 85.17 GB
   ✅ Disk volume optimisation complete.
   ```
