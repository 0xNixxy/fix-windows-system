@ECHO OFF

REM Fix Windows System by 0xNixxy
REM Repo: https://github.com/0xNixxy/fix-windows-system
REM This script needs Command Prompt Administrator to execute.

REM ============================================================================
REM MIT License
REM
REM Copyright (c) 2025-2026 Nicholas Ho
REM
REM Permission is hereby granted, free of charge, to any person obtaining a copy
REM of this software and associated documentation files (the "Software"), to
REM deal in the Software without restriction, including without limitation the
REM rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
REM sell copies of the Software, and to permit persons to whom the Software is
REM furnished to do so, subject to the following conditions:
REM
REM The above copyright notice and this permission notice shall be included in
REM all copies or substantial portions of the Software.
REM
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
REM FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
REM IN THE SOFTWARE.
REM ==============================================================================



REM Check for Admin rights and quit script otherwise

net.exe SESSION >NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    ECHO [INFO]    This script requires administrative privileges.
    ECHO [INFO]    Please run "Command Prompt" as Administrator.
    EXIT /B
)



REM Show program name and version

ECHO.
ECHO  ------------------------------------
ECHO  Fix Windows System v1.1.0 by 0xNixxy
ECHO  ------------------------------------
ECHO.



REM Remove unused driver packages in Windows

ECHO [INFO]     Clean up unused drivers in Windows system...
rundll32.exe pnpclean.dll,RunDLL_PnpClean /DRIVERS /MAXCLEAN
ECHO.



REM Detect and repair errors found in Windows component store (WinSxS)

ECHO [INFO]     Quick status check on Windows component store health...
Dism.exe /Online /Cleanup-Image /CheckHealth
ECHO.

ECHO [INFO]     Scan Windows component store and automatically fix issues...
Dism.exe /Online /Cleanup-Image /RestoreHealth
ECHO.



REM Detect and repair errors found in Windows system files
REM As SFC uses Windows image as a baseline to repair corrupted system files,
REM run SFC only after DISM verified that Windows image is healthy. I found that
REM adopting a trivial approach to run SFC twice per run seems sufficient to
REM resolve all file system issues for virtually all users. In the rare scenario
REM that two SFC runs is unable to fix all issues, the user just needs to
REM execute "SFC /scannow" manually after the script has completed.

ECHO [INFO]    Check Windows system files and automatically fix issues...
ECHO [INFO]    Run 1 of 2.
sfc.exe /scannow
ECHO.

ECHO [INFO]    Run 2 of 2.
sfc.exe /scannow
ECHO.



REM Remove superseded versions of updated components in Windows component store

ECHO [INFO]     Clean up unused components in Windows component store...
Dism.exe /Online /Cleanup-Image /StartComponentCleanup
ECHO.



REM Detect and repair errors found in disk volume

ECHO [INFO]     Checking disk volume...
chkdsk C: /scan
ECHO.

if %ERRORLEVEL% equ 0 (
    ECHO [INFO]     No issues found. Disk volume is healthy.
    ECHO.

    ECHO [INFO]     Optimise disk I/O performance and storage efficiency....
    defrag C: /O /V
    ECHO [INFO]     Disk volume optimisation complete.
    PAUSE
) else (
    ECHO [WARNING]  !! Errors found in disk volume.
    ECHO [INFO]     Taking disk volume offline for repairs...
    PAUSE
    chkdsk C: /F /R
)
