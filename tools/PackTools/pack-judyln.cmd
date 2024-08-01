@echo off
cd ..\.

mkdir ..\..\LGE-Drivers-Release
del ..\..\LGE-Drivers-Release\judyln-Drivers-Desktop.7z

echo @echo off > ..\OnlineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OnlineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OnlineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\judyln.xml >> ..\OnlineUpdater.cmd
echo pause >> ..\OnlineUpdater.cmd

echo @echo off > ..\OfflineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OfflineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OfflineUpdater.cmd
echo for /f %%%%a in ('wmic logicaldisk where "VolumeName='WINJUDYLN'" get deviceid^^^|find ":"')do set "DrivePath=%%%%a" >> ..\OfflineUpdater.cmd
echo if not [%%DrivePath%%]==[] goto start >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] echo Automatic WINJUDYLN detection failed! Enter Drive Letter manually. >> ..\OfflineUpdater.cmd
echo :sdisk >> ..\OfflineUpdater.cmd
echo set /P DrivePath=Enter Drive letter of WINJUDYLN ^^^(should be X:^^^): >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] goto sdisk >> ..\OfflineUpdater.cmd
echo if not "%%DrivePath:~1,1%%"==":" set DrivePath=%%DrivePath%%:>> ..\OfflineUpdater.cmd
echo :start >> ..\OfflineUpdater.cmd
echo if not exist "%%DrivePath%%\Windows\" echo Error! Selected Disk "%%DrivePath%%" doesn't have any Windows installation. ^& pause ^& exit >> ..\OfflineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\judyln.xml -p %%DrivePath%% >> ..\OfflineUpdater.cmd
echo pause >> ..\OfflineUpdater.cmd

echo apps\IPA > filelist_judyln.txt
echo CODE_OF_CONDUCT.md >> filelist_judyln.txt
echo components\ANYSOC\Changelog >> filelist_judyln.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.BASE >> filelist_judyln.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_BRIDGE >> filelist_judyln.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_COMPONENTS >> filelist_judyln.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL >> filelist_judyln.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL_EXTRAS >> filelist_judyln.txt
echo components\SDM845\Device\DEVICE.SOC_SDM845.JUDYLN >> filelist_judyln.txt
echo components\SDM845\Device\DEVICE.SOC_SDM845.JUDYLN_MINIMAL >> filelist_judyln.txt
echo components\SDM845\Graphics\GRAPHICS.SOC_SDM845.JUDYLN_DESKTOP >> filelist_judyln.txt
echo components\SDM845\OEM\OEM.SOC_SDM845.LG >> filelist_judyln.txt
echo components\SDM845\Platform\PLATFORM.SOC_SDM845.BASE >> filelist_judyln.txt
echo components\SDM845\Platform\PLATFORM.SOC_SDM845.BASE_MINIMAL >> filelist_judyln.txt
echo definitions\Desktop\ARM64\Internal\judyln.xml >> filelist_judyln.txt
echo tools\DriverUpdater >> filelist_judyln.txt
echo LICENSE.md >> filelist_judyln.txt
echo OfflineUpdater.cmd >> filelist_judyln.txt
echo OnlineUpdater.cmd >> filelist_judyln.txt
echo README.md >> filelist_judyln.txt

cd ..
"%ProgramFiles%\7-Zip\7z.exe" a -t7z ..\LGE-Drivers-Release\judyln-Drivers-Desktop.7z @tools\filelist_judyln.txt -scsWIN
cd tools

del ..\OfflineUpdater.cmd
del ..\OnlineUpdater.cmd
del filelist_judyln.txt
