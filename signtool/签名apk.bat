@echo off
title apk 签名

set /p INPUT=待签apk，app_unsigned.apk: 
set /p OUTPUT=输出apk，app_signed.apk: 
set /p KEYSTORE=密钥，keystore: 
set /p ALIAS=别名，alias: 

jarsigner -verbose -keystore %KEYSTORE% -signedjar %OUTPUT% %INPUT% %ALIAS%

pause
