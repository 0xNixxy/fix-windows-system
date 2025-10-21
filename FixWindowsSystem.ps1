# Repo: https://github.com/0xNixxy/fix-windows-system-powershell

# ==============================================================================
# MIT License
#
# Copyright (c) 2023-2025 Nicholas Ho
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

# This script needs PowerShell(Admin) to execute.
# Check for Admin rights and quit script otherwise.
$currID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$currPrincipal = new-object System.Security.Principal.WindowsPrincipal(${currID})
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if($currPrincipal.IsInRole(${adminRole}))
{
    # Show version number
    Write-Output -InputObject "Fix Windows System by 0xNixxy v1.0.1"
    Write-Output -InputObject ""

    # ===========================================
    # DETECT AND REPAIR ERRORS IN COMPONENT STORE
    # ===========================================
    # This cmdlet is equivalent to "DISM /Online /Cleanup-Image /CheckHealth",
    # "DISM /Online /Cleanup-Image /ScanHealth" and
    # "DISM /Online /Cleanup-Image /RestoreHealth".

    # Check for errors, and perform repairs if errors detected
    Write-Output -InputObject "🔍 Checking Windows Component Store..."
    Repair-WindowsImage -Online -CheckHealth

    if ((Repair-WindowsImage -Online -ScanHealth).ImageHealthState -ne "Healthy")
    {
        Write-Warning -Message "⚠️ Errors found in Windows Component Store."
        Write-Output -InputObject "🔧 Repairing Windows Component Store..."
        Repair-WindowsImage -Online -RestoreHealth
        Write-Output -InputObject  "✅ Windows Component Store health restored."
    }
    else
    {
        Write-Output -InputObject "✅ No issues found. Windows Component Store is healthy."
    }


    # ================================================
    # DETECT AND REPAIR ERRORS IN WINDOWS SYSTEM FILES
    # ================================================
    # Run "sfc" to fix and repair issues in Windows system files.
    # Usually running sfc twice is sufficient to resolve all issues.
    Write-Output -InputObject "`n🔄 Run 1 of 2: Checking Windows system files..."
    sfc.exe /scannow
    Write-Output -InputObject "`n🔄 Run 2 of 2: Checking Windows system files..."
    sfc.exe /scannow


    # =======================================
    # DETECT AND REPAIR ERRORS IN DISK VOLUME
    # =======================================
    # This cmdlet is equivalent to "chkdsk" in Command Prompt.

    # Check for errors, and invoke offline repairs if errors detected,
    # otherwise proceed to defrag/trim disk drive.
    Write-Output -InputObject "`n🔍 Checking disk volume..."
    if ((Repair-Volume -DriveLetter C -Scan).value__ -eq 0)
    {
        Write-Output -InputObject "✅ No issues found. Disk volume is healthy."

        # =============================
        # OPTIMIZE DISK I/O PERFORMANCE
        # =============================
        # Improve disk I/O performance of specified volume by performing either
        # defragmentation on HDD or TRIM on SSD. Optimize-Volume automatically
        # detects disk type and applies appropriate optimisation technique.
        # This cmdlet is equivalent to "defrag" in Command Prompt.
        Write-Output -InputObject   "🧹 Optimising disk volume to improve performance and storage efficiency..."
        Optimize-Volume -DriveLetter C -Verbose
        Write-Output -InputObject "✅ Disk volume optimisation complete."
    }
    else
    {
        Write-Warning -Message "⚠️ Errors found in disk volume."
        Write-Output -InputObject "🔧 Taking disk volume offline for repairs..."
        Repair-Volume -DriveLetter C -OfflineScanAndFix
    }
}
else
{
    Write-Warning -Message  "🔐 This script requires administrative privileges. Please run PowerShell Terminal as Administrator."
}