@echo off
cd ..\.

mkdir ..\..\LGE-Drivers-Release
del ..\..\LGE-Drivers-Release\alpha-Drivers-Desktop.7z

echo @echo off > ..\OnlineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OnlineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OnlineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\alpha.xml >> ..\OnlineUpdater.cmd
echo pause >> ..\OnlineUpdater.cmd

echo @echo off > ..\OfflineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OfflineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OfflineUpdater.cmd
echo for /f %%%%a in ('wmic logicaldisk where "VolumeName='WINALPHA'" get deviceid^^^|find ":"')do set "DrivePath=%%%%a" >> ..\OfflineUpdater.cmd
echo if not [%%DrivePath%%]==[] goto start >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] echo Automatic WINALPHA detection failed! Enter Drive Letter manually. >> ..\OfflineUpdater.cmd
echo :sdisk >> ..\OfflineUpdater.cmd
echo set /P DrivePath=Enter Drive letter of WINALPHA ^^^(should be X:^^^): >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] goto sdisk >> ..\OfflineUpdater.cmd
echo if not "%%DrivePath:~1,1%%"==":" set DrivePath=%%DrivePath%%:>> ..\OfflineUpdater.cmd
echo :start >> ..\OfflineUpdater.cmd
echo if not exist "%%DrivePath%%\Windows\" echo Error! Selected Disk "%%DrivePath%%" doesn't have any Windows installation. ^& pause ^& exit >> ..\OfflineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\alpha.xml -p %%DrivePath%% >> ..\OfflineUpdater.cmd
echo pause >> ..\OfflineUpdater.cmd

echo apps\IPA > filelist_alpha.txt
echo CODE_OF_CONDUCT.md >> filelist_alpha.txt
echo components\ANYSOC\Changelog >> filelist_alpha.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.BASE >> filelist_alpha.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_BRIDGE >> filelist_alpha.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_COMPONENTS >> filelist_alpha.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL >> filelist_alpha.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL_EXTRAS >> filelist_alpha.txt
echo components\QC8150\Device\DEVICE.SOC_QC8150.ALPHA >> filelist_alpha.txt
echo components\QC8150\Device\DEVICE.SOC_QC8150.ALPHA_MINIMAL >> filelist_alpha.txt
echo components\QC8150\Graphics\GRAPHICS.SOC_QC8150.ALPHA_DESKTOP >> filelist_alpha.txt
echo components\QC8150\OEM\OEM.SOC_QC8150.LG >> filelist_alpha.txt
echo components\QC8150\Platform\PLATFORM.SOC_QC8150.BASE >> filelist_alpha.txt
echo components\QC8150\Platform\PLATFORM.SOC_QC8150.BASE_MINIMAL >> filelist_alpha.txt
echo definitions\Desktop\ARM64\Internal\alpha.xml >> filelist_alpha.txt
echo tools\DriverUpdater >> filelist_alpha.txt
echo LICENSE.md >> filelist_alpha.txt
echo OfflineUpdater.cmd >> filelist_alpha.txt
echo OnlineUpdater.cmd >> filelist_alpha.txt
echo README.md >> filelist_alpha.txt

cd ..
"%ProgramFiles%\7-Zip\7z.exe" a -t7z ..\LGE-Drivers-Release\alpha-Drivers-Desktop.7z @tools\filelist_alpha.txt -scsWIN
cd tools

del ..\OfflineUpdater.cmd
del ..\OnlineUpdater.cmd
del filelist_alpha.txt
