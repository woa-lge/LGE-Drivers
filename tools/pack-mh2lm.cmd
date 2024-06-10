@echo off
rmdir /Q /S ..\..\LGE-Drivers-Release
mkdir ..\..\LGE-Drivers-Release

echo @echo off > ..\OnlineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OnlineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OnlineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\mh2lm.xml >> ..\OnlineUpdater.cmd
echo pause >> ..\OnlineUpdater.cmd

echo @echo off > ..\OfflineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OfflineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OfflineUpdater.cmd
echo for /f %%%%a in ('wmic logicaldisk where "VolumeName='WINMH2LM'" get deviceid^^^|find ":"')do set "DrivePath=%%%%a" >> ..\OfflineUpdater.cmd
echo if not [%%DrivePath%%]==[] goto start >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] echo Automatic WINMH2LM detection failed! Enter Drive Letter manually. >> ..\OfflineUpdater.cmd
echo :sdisk >> ..\OfflineUpdater.cmd
echo set /P DrivePath=Enter Drive letter of WINMH2LM ^^^(should be X:^^^): >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] goto sdisk >> ..\OfflineUpdater.cmd
echo if not "%%DrivePath:~1,1%%"==":" set DrivePath=%%DrivePath%%:>> ..\OfflineUpdater.cmd
echo :start >> ..\OfflineUpdater.cmd
echo if not exist "%%DrivePath%%\Windows\" echo Error! Selected Disk "%%DrivePath%%" doesn't have any Windows installation. ^& pause ^& exit >> ..\OfflineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\mh2lm.xml -p %%DrivePath%% >> ..\OfflineUpdater.cmd

echo apps\IPA > filelist_mh2lm.txt
echo CODE_OF_CONDUCT.md >> filelist_mh2lm.txt
echo components\ANYSOC\Changelog >> filelist_mh2lm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.BASE >> filelist_mh2lm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_COMPONENTS >> filelist_mh2lm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL >> filelist_mh2lm.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL_EXTRAS >> filelist_mh2lm.txt
echo components\QC8150\Device\DEVICE.SOC_QC8150.MH2LM >> filelist_mh2lm.txt
echo components\QC8150\Device\DEVICE.SOC_QC8150.MH2LM_MINIMAL >> filelist_mh2lm.txt
echo components\QC8150\Graphics\GRAPHICS.SOC_QC8150.MH2LM_DESKTOP >> filelist_mh2lm.txt
echo components\QC8150\OEM\OEM.SOC_QC8150.MH2LM >> filelist_mh2lm.txt
echo components\QC8150\Platform\PLATFORM.SOC_QC8150.BASE >> filelist_mh2lm.txt
echo components\QC8150\Platform\PLATFORM.SOC_QC8150.BASE_MINIMAL >> filelist_mh2lm.txt
echo definitions\Desktop\ARM64\Internal\mh2lm.xml >> filelist_mh2lm.txt
echo tools\DriverUpdater >> filelist_mh2lm.txt
echo LICENSE.md >> filelist_mh2lm.txt
echo OfflineUpdater.cmd >> filelist_mh2lm.txt
echo OnlineUpdater.cmd >> filelist_mh2lm.txt
echo README.md >> filelist_mh2lm.txt

cd ..
"%ProgramFiles%\7-Zip\7z.exe" a -t7z ..\LGE-Drivers-Release\mh2lm-Drivers-Desktop.7z @tools\filelist_mh2lm.txt -scsWIN
cd tools

del ..\OfflineUpdater.cmd
del ..\OnlineUpdater.cmd
del filelist_mh2lm.txt
