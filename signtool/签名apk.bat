@echo off
title apk ǩ��

set /p INPUT=��ǩapk��app_unsigned.apk: 
set /p OUTPUT=���apk��app_signed.apk: 
set /p KEYSTORE=��Կ��keystore: 
set /p ALIAS=������alias: 

jarsigner -verbose -keystore %KEYSTORE% -signedjar %OUTPUT% %INPUT% %ALIAS%

pause
