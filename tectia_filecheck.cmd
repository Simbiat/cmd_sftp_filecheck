@echo off
cls
rem *******************************
rem *      Settings: General      *
rem *******************************
	set SCRIPTNAME=SFTP Files Check
	set globalfuncpath=\\path\globalfunctions.cmd
	setlocal enabledelayedexpansion
	call %globalfuncpath% getdate
	SET yy=%yy:~2,2%
	call %globalfuncpath% datemath %yy% %mm% %dd% - 1
	set dt=%_yy_int%%_mm_str%%_dd_str%
rem *******************************
rem *  End of Settings: General   *
rem *******************************

rem **************************************************************************************************************
rem       Settings: Paths
rem **************************************************************************************************************
rem ***Apps***
	CALL %globalfuncpath% tectiacheck
	set logapp=\\path\Tee.vbs
	set sername=server_name
	set filelist=\\path\filelist.txt
rem ***Logs directory***
	set batchfile=\\path_logs\batch.txt
	set lsfile=\\path_logs\ls.txt
	SET LOGSDIR=\\path_logs\Logs
rem **************************************************************************************************************
rem       End of Settings: Paths
rem **************************************************************************************************************

Echo Script is starting with %dt% as previous business date. Is the date correct?
call %globalfuncpath% choice "Press 1 for Yes, 2 to change date and Q to Quit:" 1 2
if %chosen% equ 1 (
	GOTO mainscript
)
If %chosen% equ 2 (
	set /p dt=Please, enter correct date in YYYYMMDD format:
	goto mainscript
)

:mainscript
set /p usname="Input your ID:"
set /p pass="Input %usname%'s password:"
cls
If exist %batchfile% (
	del /Q /F %batchfile%
)
set /a bostefiles=0
Echo Started at %date% %time% >>%LOGSDIR%\%dt%.txt
CALL %globalfuncpath% makemisdir %LOGSDIR%
CALL %globalfuncpath% makemisdir %LOGSDIR%\TempTectia

Echo Writing ls batch file...
Echo cd /cbr/upload_data >%batchfile%
Echo ls -z %dt%*>>%batchfile%

If exist %batchfile% (
	sftpg3.exe -B %batchfile% --password=%pass% %usname%@%sername% > %lsfile%
	del /Q /F %batchfile%
)

Echo Checking files...
Echo.

FOR /F "tokens=1,2" %%A IN (%filelist%) DO (
	if "%%A" EQU "block" (
		echo.
		echo Checking files from %%B...
	) else (
		Call :filecheck %%A %%B
	)
)

del /Q /F %lsfile%
If exist %batchfile% (
	del /Q /F %batchfile%
)

Echo Checking completed. Press any key to exit...
pause > nul
exit


:filecheck
if "%1" EQU ".epd" (
	set filename=%1
) else (
	if "%1" EQU ".vip" (
		set filename=%1
	) else (
		set filename=%dt%%1
	)
)
FINDSTR /I /R %filename% %lsfile% > nul
If %errorlevel% neq 0 (
	color c0
	Echo %2 file %filename% is missing
)
exit /b
