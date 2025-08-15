
仓库的工具是二进制文件，历史提交包含工具版本更新，建议使用浅克隆或直接 [Download ZIP](https://github.com/zjmok/apk-reverse/archive/refs/heads/master.zip)

浅克隆

```
git clone https://github.com/zjmok/apk-reverse.git --depth=1
```

# Android APK 反编译

## 步骤 and 工具

<p align="right">last update time 20250815</p>

工具			| 作用				| 地址
---			| ---				| ---
dex2jar		| 将 apk 转换成 jar	| <https://github.com/pxb1988/dex2jar>
jd-gui		| 查看 jar 源码		| <https://github.com/java-decompiler/jd-gui>
apktool		| apk 反编译、回编译	| <https://github.com/iBotPeaches/Apktool>
signtool	| 签名脚本			| 

### 一、反编译，[apktool](/apktool)

使用 apktool 反编译 apk 得到可以修改的 `smali` 源码

进入 `/apktool` 目录

> MacOS Linux 系统的需要将 `script` 里对应系统的脚本放到 `apktool.jar` 同级目录，Windows 已处理

```
apktool d <apk文件> -o app_workspace
```

若遇到 `DexBackedDexFile$NotADexFile` 错误，使用 `apktool d --only-main-classe target.apk -o target`，正常则跳过

`aapt` 是资源编译和打包工具，apktool 2.0+ 二进制文件中内嵌aapt工具

### 二、查看源码，[dex2jar](/dex-tools)、[jd-gui](/jd-gui)

使用 dex2jar 将 apk 转换成 jar

进入 `/dex-tools/dex-tools-版本` 目录

```
d2j-dex2jar -f <apk文件>
```

会在当前目录生成对应的 `.jar` 文件，后面会用到

---

用 jd-gui 阅读源码

进入 `/jd-gui` 目录

```
java -jar jd-gui-版本.jar
```

把前面得到的 `.jar` 文件拖进来，就可以查看的源码了

### 三、修改反编译出来的 `smali` 代码、资源文件

#### 修改 `smali` 源码

通过查看 步骤二 的源码确定需要修改的地方，把 步骤一 反编译出来的 `smali` 目录对应的 smali 文件拖进 Android Studio 进行修改（或者使用其它编辑器直接修改）

若对 `smali` 语法不熟悉，可以自己找资料简单学习一下。

Android Studio 的 java2smali 插件 可将 java/kotlin 编译成 smali，可以对修改起到一定作用

---

#### 修改资源文件

编辑或替换即可

### 四、回编译及签名

#### 1、回编译

用 apktool 回编译，生成未签名的 apk

进入 `/apktool` 目录

```
apktool b app_workspace -o app_unsigned.apk
```

#### 2、重新签名

你需要准备一个自己的签名，可以用 Android Studio 图形界面生成，或用 keytool 命令生成  
也可以直接使用 Android SDK 自动生成的 debug.keystore（默认位置 `~/.android/debug.keystore`，别名 `androiddebugkey` 密码 `android`）

使用 jdk  的 `keytool` 生成签名，有签名或使用 debug.keystore 可跳过

```
# 签名路径名称、别名、密码 可修改为你自己的
keytool -genkey -v \
  -keystore ~/.android/debug.keystore \
  -storepass android -alias androiddebugkey -keypass android \
  -storetype PKCS12 \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -dname "CN=Android Debug,O=Android,C=US"
```

用 jdk 的 `jarsigner` 对 apk 重新签名

```
# 使用 debug.keystore 签名
jarsigner -verbose -keystore ~/.android/debug.keystore -signedjar app_signed.apk app_unsigned.apk androiddebugkey
```

`app_signed.apk` 就是修改后最终的安装包

---

下载

[open-jdk](https://jdk.java.net/)

[Android Studio](https://developer.android.google.cn/studio)

[java2smali](https://plugins.jetbrains.com/plugin/7385-java2smali/versions)

---

> 网上教程的 `signapk.jar` 是 Android 源码包中的一个签名工具，`testkey.pk8` 和 `testkey.x509.pem` 也是源码提供的签名文件。我们使用自己的签名文件签名就可以了

> 安装不同签名的 apk 需要卸载重装
