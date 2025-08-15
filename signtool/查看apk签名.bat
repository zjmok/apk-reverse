@echo off
title 查看 apk 签名信息
:start
@echo\
set /p APK=请输入apk路径:
if ""=="%APK%" goto end
keytool -printcert -jarfile %APK%
set APK=
goto start
:end
@echo\
pause
