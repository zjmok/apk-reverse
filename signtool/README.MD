# 脚本简介

- `签名apk.bat`

```
jarsigner -verbose -keystore <签名文件> -signedjar <输出apk> <待签apk> <签名的别名>
```

- `查看apk签名.bat`

```
keytool -printcert -jarfile <apk文件>
```
