@echo off
SETLOCAL EnableDelayedExpansion

set FailList=
Set OKList=
for  %%i in (%*) do  call  :loop %%i
echo.
echo.
if defined OKList (
echo successfully copied following files
echo ************************************
	for  %%i in (%OKList%) do (
	echo  %%~i
	)
echo ************************************
)

if defined FailList (
echo.
echo.
echo Failed to copy following files
echo ====================================
	for %%i in (%FailList%) do (
	echo   %%~i
	)
echo ====================================
)

timeout 4
goto :eof
endlocal

:loop
echo.
echo processing %~nx1
set srcfile=%~1
IF EXIST %srcfile%\NUL (
for /f "usebackq" %%i in (`dir/b %srcfile%`) do call :loop %%i
) else (

	pushd "C:\Program Files (x86)\MyApplication\"
	for /f "usebackq delims=;" %%i in (`dir/s /b %~nx1`) do (
		call :action "%srcfile%" "%%i"
	)
	popd
)

goto :eof

:action
set frmfile=%~1
set tofile=%~2
if NOT "%frmfile%"=="" (
	if NOT "%tofile%"=="" (
		copy /y "%frmfile%" "%tofile%"
		call :addToList "%tofile%"
		goto :eof
	)
	set FailList=%FailList% "%frmfile%"
) 
goto :eof

:addToList
set OKList=%OKList% %1
goto :eof