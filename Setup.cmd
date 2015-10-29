@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
pushd %~dp0
if NOT exist c:\tools (
mkdir c:\tools
)
copy AcqUpdater.cmd c:\tools
copy "Modified files.search-ms" c:\tools
SET cSctVBS=CreateShortcut.vbs
SET LOG=".\%~N0_runtime.log"
	(
		(
			echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
			echo sLinkFile = oWS.SpecialFolders^("SendTo"^) ^& "\Update OpenLABAcquisition Install Folder.lnk"
			echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
			echo oLink.TargetPath = "c:\tools\AcqUpdater.cmd"
			echo oLink.Save
			
			echo sLinkFile = "%USERPROFILE%\links\Modified files.lnk"
			echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
			echo oLink.TargetPath = "c:\tools\Modified files.search-ms"
			echo oLink.Save		
		)1>!cSctVBS!
		wscript //nologo .\!cSctVBS!
		DEL !cSctVBS! /f /q
	)1>>!LOG! 2>>&1
	"%USERPROFILE%\links\Modified files.lnk"
DEL !LOG! /f /q
popd