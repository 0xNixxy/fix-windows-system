# Fix Windows System by 0xNixxy
# Repo: https://github.com/0xNixxy/fix-windows-system
# This script needs Windows PowerShell Administrator to execute.

# ==============================================================================
# MIT License
#
# Copyright (c) 2025-2026 Nicholas Ho
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ==============================================================================

# ==============================================================================
# TROUBLESHOOTING NOTE
# If you have problems executing PowerShell scripts on your local machine, you
# may need to first perform a one-time relaxing of PowerShell Execution Policy
# with "Set-ExecutionPolicy -ExecutionPolicy Bypass" in PowerShell(Admin).
# You can check your current policy with "Get-ExecutionPolicy -List"
# ==============================================================================



# Check for Admin rights and quit script otherwise

$currID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$currPrincipal = new-object System.Security.Principal.WindowsPrincipal(${currID})
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if(-not $currPrincipal.IsInRole(${adminRole}))
{
    Write-Warning -Message  "[INFO]    This script requires administrative privileges."
    Write-Warning -Message  "[INFO]    Please run `"Windows PowerShell`" as Administrator."
    return
}



# Show program name and version

Write-Output -InputObject ""
Write-Output -InputObject "------------------------------------"
Write-Output -InputObject "Fix Windows System v1.1.0 by 0xNixxy"
Write-Output -InputObject "------------------------------------"
Write-Output -InputObject ""



# Remove unused driver packages in Windows

Write-Output -InputObject "[INFO]     Clean up unused drivers in Windows system..."
& rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN
Write-Output -InputObject ""



# Detect and repair errors found in Windows component store (WinSxS)

Write-Output -InputObject "[INFO]     Quick status check on Windows component store health..."
Repair-WindowsImage -Online -CheckHealth
Write-Output -InputObject ""

Write-Output -InputObject "[INFO]     Scan Windows component store and automatically fix issues..."
Repair-WindowsImage -Online -RestoreHealth
Write-Output -InputObject ""



# Detect and repair errors found in Windows system files
# As SFC uses Windows image as a baseline to repair corrupted system files,
# run SFC only after DISM verified that Windows image is healthy. I found that
# adopting a trivial approach to run SFC twice per run seems sufficient to
# resolve all file system issues for virtually all users. In the rare scenario
# that two SFC runs is unable to fix all issues, the user just needs to
# execute "SFC /scannow" manually after the script has completed.

Write-Output -InputObject "[INFO]    Check Windows system files and automatically fix issues..."
Write-Output -InputObject "[INFO]    Run 1 of 2."
& sfc.exe /scannow
Write-Output -InputObject ""

Write-Output -InputObject "[INFO]    Run 2 of 2."
& sfc.exe /scannow
Write-Output -InputObject ""



# Remove superseded versions of updated components in Windows component store

Write-Output -InputObject "[INFO]     Clean up unused components in Windows component store..."
Repair-WindowsImage -Online -StartComponentCleanup
Write-Output -InputObject ""



# Detect and repair errors found in disk volume

# Check for errors, and invoke offline repairs if errors detected,
# otherwise proceed to defrag/trim disk drive.
Write-Output -InputObject "[INFO]     Checking disk volume..."

if ((Repair-Volume -DriveLetter C -Scan).value__ -eq 0)
{
    Write-Output -InputObject ""
    Write-Output -InputObject "[INFO]     No issues found. Disk volume is healthy."
    Write-Output -InputObject ""

    Write-Output -InputObject   "[INFO]     Optimise disk I/O performance and storage efficiency...."
    Optimize-Volume -DriveLetter C -Verbose
    Write-Output -InputObject "[INFO]     Disk volume optimisation complete."
    Read-Host "Press Enter to continue..."
}
else
{
    Write-Output -InputObject ""
    Write-Warning -Message "[WARNING]  !! Errors found in disk volume."
    Write-Output -InputObject "[INFO]     Taking disk volume offline for repairs..."
    Read-Host "Press Enter to continue..."
    Repair-Volume -DriveLetter C -OfflineScanAndFix
}
