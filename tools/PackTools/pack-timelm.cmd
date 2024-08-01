@echo off
cd ..\.

mkdir ..\..\LGE-Drivers-Release
del ..\..\LGE-Drivers-Release\timelm-Drivers-Desktop.7z

echo @echo off > ..\OnlineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OnlineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OnlineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\timelm.xml >> ..\OnlineUpdater.cmd
echo pause >> ..\OnlineUpdater.cmd

echo @echo off > ..\OfflineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OfflineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OfflineUpdater.cmd
echo for /f %%%%a in ('wmic logicaldisk where "VolumeName='WINTIMELM'" get deviceid^^^|find ":"')do set "DrivePath=%%%%a" >> ..\OfflineUpdater.cmd
echo if not [%%DrivePath%%]==[] goto start >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] echo Automatic WINTIMELM detection failed! Enter Drive Letter manually. >> ..\OfflineUpdater.cmd
echo :sdisk >> ..\OfflineUpdater.cmd
echo set /P DrivePath=Enter Drive letter of WINTIMELM ^^^(should be X:^^^): >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] goto sdisk >> ..\OfflineUpdater.cmd
echo if not "%%DrivePath:~1,1%%"==":" set DrivePath=%%DrivePath%%:>> ..\OfflineUpdater.cmd
echo :start >> ..\OfflineUpdater.cmd
echo if not exist "%%DrivePath%%\Windows\" echo Error! Selected Disk "%%DrivePath%%" doesn't have any Windows installation. ^& pause ^& exit >> ..\OfflineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\timelm.xml -p %%DrivePath%% >> ..\OfflineUpdater.cmd
echo pause >> ..\OfflineUpdater.cmd

echo apps\IPA > filelist_timelm.txt
echo CODE_OF_CONDUCT.md >> filelist_timelm.txt
echo components\ANYSOC\Changelog >> filelist_timelm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.BASE >> filelist_timelm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_BRIDGE >> filelist_timelm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_COMPONENTS >> filelist_timelm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL >> filelist_timelm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL_EXTRAS >> filelist_timelm.txt
echo components\QC8250\Device\DEVICE.SOC_QC8250.TIMELM >> filelist_timelm.txt
echo components\QC8250\Device\DEVICE.SOC_QC8250.TIMELM_MINIMAL >> filelist_timelm.txt
echo components\QC8250\Graphics\GRAPHICS.SOC_QC8250.TIMELM_DESKTOP >> filelist_timelm.txt
echo components\QC8250\OEM\OEM.SOC_QC8250.LG >> filelist_timelm.txt
echo components\QC8250\Platform\PLATFORM.SOC_QC8250.BASE >> filelist_timelm.txt
echo components\QC8250\Platform\PLATFORM.SOC_QC8250.BASE_MINIMAL >> filelist_timelm.txt
echo definitions\Desktop\ARM64\Internal\timelm.xml >> filelist_timelm.txt
echo tools\DriverUpdater >> filelist_timelm.txt
echo LICENSE.md >> filelist_timelm.txt
echo OfflineUpdater.cmd >> filelist_timelm.txt
echo OnlineUpdater.cmd >> filelist_timelm.txt
echo README.md >> filelist_timelm.txt

cd ..
"%ProgramFiles%\7-Zip\7z.exe" a -t7z ..\LGE-Drivers-Release\timelm-Drivers-Desktop.7z @tools\filelist_timelm.txt -scsWIN
cd tools

del ..\OfflineUpdater.cmd
del ..\OnlineUpdater.cmd
del filelist_timelm.txt
