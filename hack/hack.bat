cd /d %~dp0

@echo off
set /p frpath= Please enter the install path of your FineReport?
set _trimmed=%frpath%
:loop
 if not "%_trimmed:~-1%"==" " goto next
 set _trimmed=%_trimmed:~0,-1%
 goto loop
:next
set frpath=%_trimmed%\WebReport
@echo install path is %frpath%

if exist %frpath%  goto hack
@echo No such folder %frpath%
goto fail


:hack
set resourcepath=%frpath%\WEB-INF\resources
if exist %resourcepath%  goto copyresource
@echo No such folder %resourcepath%
goto fail

:copyresource
@echo Copying FineReport.lic to %resourcepath%

cp FineReport.lic %resourcepath%
rem dir %resourcepath%
@echo Success to copy FineReport.lic to %resourcepath%

set libpath=%frpath%\WEB-INF\lib
rem dir %libpath%

if exist %libpath%  goto hackjar
@echo No such folder %libpath%
goto fail

:hackjar
@echo Hacking FineReport

jar uf %libpath%\fr-core-8.0.jar com\fr\data\VersionInfoTableData.class || (@echo File %libpath%\fr-core-8.0.jar in used, please exit finereport and try again & goto fail)
jar uf %libpath%\fr-core-8.0.jar com\fr\stable\LicUtils.class || (File %libpath%\fr-core-8.0.jar in used, please exit finereport and try again & goto fail)

jar uf %frpath%\fr-applet-8.0.jar com\fr\data\VersionInfoTableData.class || (@echo File %frpath%\fr-applet-8.0.jar in used, please exit finereport and try again & goto fail)
jar uf %frpath%\fr-applet-8.0.jar com\fr\stable\LicUtils.class || (@echo File %frpath%\fr-applet-8.0.jar in used, please exit finereport and try again & goto fail)


@echo Cong! you have successfully hacked FineReport!
@echo Please restart the server!
pause > nul
exit

:fail
@echo Fail to hack FineReport
pause > nul
exit