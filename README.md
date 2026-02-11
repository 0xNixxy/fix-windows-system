# fix-windows-system

<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD042 -->

<div align = "center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

![Made with Batch Scripting](https://img.shields.io/badge/Batch%20Scripting-CMD%2010.0.26200-0079d5.svg?style=for-the-badge&logo=windows-terminal&logoColor=white)
![Made with PowerShell 5.1](https://img.shields.io/badge/PowerShell-5.1-5391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![Tested on Windows 11 25H2](https://img.shields.io/badge/Windows%2011-25H2-0079d5.svg?style=for-the-badge&logo=Windows%2011&logoColor=white)

</div>

<!-- markdownlint-enable MD042 -->
<!-- markdownlint-enable MD033 -->

## Overview

This repo contains standalone scripts to automatically detect and repair
corruption(s) found in the system components and filesystem of a Windows 11
operating system (OS). The scripts uses only tools that come pre-packaged with
the Windows 11 Home OS and does not require installation of any third-party
software.

For Command Prompt users, use `FixWindowsSystem.bat`.

For PowerShell users, use `FixWindowsSystem.ps1`. As PowerShell 5.1 is packaged
together with Windows 11, this PowerShell script has been written to use only
[PowerShell 5.1 commands](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/?view=powershell-5.1).

## Windows system repair workflow

The script repairs Windows in the following steps:

1. Remove unused driver packages in Windows using

   ```bat
   rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN
   ```

1. Detect and repair errors found in Windows component store (WinSxS) using the
   [Repair-WindowsImage](https://learn.microsoft.com/en-us/powershell/module/dism/repair-windowsimage)
   cmdlet or [Dism.exe](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/what-is-dism?view=windows-11)
   tool.

1. Detect and repair errors found in Windows system files using the
   [sfc.exe](https://learn.microsoft.com/en-us/troubleshoot/windows-server/deployment/system-file-checker)
   tool. There seems to be no PowerShell equivalent for this tool.

1. Detect and repair corruption in Windows file system using
   [Repair-Volume](https://learn.microsoft.com/en-us/powershell/module/storage/repair-volume)
   cmdlet or [chkdsk](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk)
   tool.

1. Remove superseded versions of updated components in Windows component store
   using the `Repair-Volume` cmdlet or `Dism.exe` tool.

1. Detect and repair errors found in disk volume using
   [Optimize-Volume](https://learn.microsoft.com/en-us/powershell/module/storage/optimize-volume)
   cmdlet or [defrag](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/defrag)
   tool.

   **Note**: If no errors are found in disk volume, the script will perform
   disk optimisation by executing defrag for HDD and retrim for SSD accordingly.

## Usage guide for Command Prompt users

To use the script on your Windows 11 system

1. Download `FixWindowsSystem.bat` to computer.

1. Open Command Prompt with Administrator privileges.

1. (Optional) If your active Windows account is a standard user account
   (i.e., non-admin account), you can copy the script to your admin account's
   folder for convenience.

   ```bat
   copy ..\user\Downloads\FixWindowsSystem.bat .
   ```

1. Execute the script and wait for the repairs to finish.

   ```bath
   FixWindowsSystem.bat
   ```

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

1. Execute the script and wait for the repairs to finish.

   ```PowerShell
   .\FixWindowsSystem.ps1
   ```
