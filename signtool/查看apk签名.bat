@echo off
title �鿴 apk ǩ����Ϣ
:start
@echo\
set /p APK=������apk·��:
if ""=="%APK%" goto end
keytool -printcert -jarfile %APK%
set APK=
goto start
:end
@echo\
pause
