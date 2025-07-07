@echo off
color 0a

echo ==============================
echo =     Imperial-Services      =
echo ==============================

echo.

:: Check if running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as admin..
    pause
    exit /b
)

:: Automatically detect motherboard type
echo Detecting motherboard...
set isAsus=No
set isLocked=No

:: Use WMIC to fetch motherboard manufacturer
for /f "tokens=2 delims==" %%i in ('wmic baseboard get manufacturer /value') do set manufacturer=%%i

if /i "%manufacturer%"=="ASUS" (
    set isAsus=Yes
    echo Asus motherboard detected.
) else if /i "%manufacturer%"=="HP" (
    set isLocked=Yes
    echo HP motherboard detected.
) else if /i "%manufacturer%"=="Dell" (
    set isLocked=Yes
    echo Dell motherboard detected.
) else (
    echo Unknown motherboard detected.
    :: Proceed with normal spoofing if motherboard is unknown
    set isLocked=No
)

echo.
echo Proceeding with spoofing process...
timeout /t 5 >nul

:: Generate random strings
for /f "delims=" %%i in ('call "%~dp0randstr.bat" 10') do set "output9=%%i"
for /f "delims=" %%i in ('call "%~dp0randstr.bat" 14') do set "output91=%%i"
for /f "delims=" %%i in ('call "%~dp0randstr.bat" 10') do set "output92=%%i"

:: Navigate to the AMI directory
cd "%~dp0AMI"

:: Spoof motherboard if not locked
if /i "%isLocked%" == "No" (
    echo [32mSpoofing Motherboard...[0m
    timeout /t 10 >nul

    :: Run AMIDEWINx64 commands
    "%~dp0AMI\AMIDEWINx64.EXE" /IVN "AMI" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SM "System manufacturer" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SP "System product name" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SV "System version" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SS %output9% >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SU AUTO >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SK "IEKSY5ET4ETY" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /SF "To Be Filled By O.E.M" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /BM "ASRock" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /BP "B560M-C" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /BV "RGREERGE" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /BS %output91% >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /BT "RDGDRGEDGE" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /BLC "GYJTYJRRTH" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /CM "RTHRTYR" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /CV "TRYRTYU6IE" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /CS %output92% >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /CA "TDFHTJEEH" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /CSK "SKU" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /PSN "To Be Filled By O.E.M" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /PAT "To Be Filled By O.E.M" >nul
    "%~dp0AMI\AMIDEWINx64.EXE" /PPN "To Be Filled By O.E.M" >nul

    echo [32mMotherboard Spoofed![0m
)

:: Spoof BIOS if Asus motherboard
if /i "%isAsus%" == "Yes" (
    echo [32mSpoofing BIOS...[0m
    timeout /t 10 >nul

    :: Run AFUWINx64 commands
    "%~dp0AMI\AFUWINx64.exe" BIOS.rom /o >nul
    "%~dp0AMI\AFUWINx64.exe" BIOS.rom /p >nul

    echo [32mBIOS Spoofed![0m
)

:: Spoof Chassis if locked motherboard
if /i "%isLocked%" == "Yes" (
    echo [32mSpoofing CHASSIS...[0m
    timeout /t 5 >nul

    :: Navigate to the USB\efi\boot directory
    cd "%~dp0AMI\USB\efi\boot"

    :: Create the startup.nsh file
    (
        echo echo -off
        echo AMIDEEFIx64.efi /IVN "AMI"
        echo AMIDEEFIx64.efi /SM "System manufacturer"
        echo AMIDEEFIx64.efi /SP "System product name"
        echo AMIDEEFIx64.efi /SV "System version"
        echo AMIDEEFIx64.efi /SS "%output9%"
        echo AMIDEEFIx64.efi /SU AUTO
        echo AMIDEEFIx64.efi /SK "To Be Filled By O.E.M"
        echo AMIDEEFIx64.efi /SF "To Be Filled By O.E.M."
        echo AMIDEEFIx64.efi /BM "ASRock"
        echo AMIDEEFIx64.efi /BP "B560M-C"
        echo AMIDEEFIx64.efi /BV " "
        echo AMIDEEFIx64.efi /BS "%output91%"
        echo AMIDEEFIx64.efi /BT "Default string"
        echo AMIDEEFIx64.efi /BLC "Default string"
        echo AMIDEEFIx64.efi /CM "Default string"
        echo AMIDEEFIx64.efi /CV "Default string"
        echo AMIDEEFIx64.efi /CS "%output92%"
        echo AMIDEEFIx64.efi /CA "Default string"
        echo AMIDEEFIx64.efi /CSK "SKU"
        echo AMIDEEFIx64.efi /PSN "To Be Filled By O.E.M."
        echo AMIDEEFIx64.efi /PAT "To Be Filled By O.E.M."
        echo AMIDEEFIx64.efi /PPN "To Be Filled By O.E.M."
        echo exit
    ) > "startup.nsh"

    :: Navigate back to the script's root directory
    cd "%~dp0"
 
    echo [32mCHASSIS Spoofed![0m

echo [32mSpoofing CPU..[0m
    timeout /t 5 >nul
echo [32mCPU Spoofed![0m
)

echo [32mSpoofing SMBIOS...[0m
timeout /t 7 >nul

:: Generate random strings for Volumeid
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output3=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output31=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output32=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output33=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output34=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output35=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output36=%%i"
@for /f "delims=" %%i in ('call "%~dp0randstr.bat" 4 /v') do @set "output37=%%i"

:: Navigate to the VOLUME directory
@cd "%~dp0VOLUME" >nul

:: Run Volumeid64 commands
@"%~dp0VOLUME\Volumeid64.exe" C: %output3%-%output31% /accepteula >nul
@"%~dp0VOLUME\Volumeid64.exe" D: %output32%-%output33% /accepteula >nul
@"%~dp0VOLUME\Volumeid64.exe" E: %output34%-%output35% /accepteula >nul
@"%~dp0VOLUME\Volumeid64.exe" F: %output36%-%output37% /accepteula >nul

echo [32mSMBIOS Spoofed![0m

    :: Navigate to the SID directory
    cd "%~dp0SID"

    :: Run SIDCHG64 command
    "%~dp0SID\SIDCHG64.exe" /KEY="7rq1f-#R!ZE-g#f4O-tZ" /F /R /OD /RESETALLAPPS >nul


    echo
    echo [32mEverything Spoofed![0m 
    echo [32mWe are from 64rd, not from 63rd![0m
    timeout /t 5 >nul
    pause
) else (

    echo [32mSucsessfully Spoofed![0m 
    echo [32mjoin the discord for support![0m
    timeout /t 5 >nul
    pause
)
