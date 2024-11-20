# Android APK 反编译

## 步骤 and 工具

<p align="right">last update time 20241121</p>

### 一、反编译

利用 [apktool](/apktool) 反编译apk得到可以修改的 `smali` 源码

```
apktool d target.apk -o target
```

若遇到 `DexBackedDexFile$NotADexFile` 错误，使用 `apktool d --only-main-classe target.apk -o target`，正常则跳过

`aapt` 是资源编译和打包工具，apktool 2.0+ 二进制文件中内嵌aapt工具

### 二、查看源码

用 [dex2jar](/dex-tools) 将 apk 转换成 jar

```
d2j-dex2jar -f target.apk
```

用 [jd-gui](/jd-gui) 或者用 [Android Studio](https://developer.android.google.cn/studio) 阅读源码

### 三、修改反编译出来的`smali`代码

通过 步骤二 查看源码 进行对比，修改 步骤一 反编译出来的源码

若对 `smali` 语法不熟悉，可以自己找资料学习一下。这里推荐一些个人认为比较好的文章

- [Smali语法入门教程](https://www.anquanke.com/post/id/85035)

- [Smali基本语法](https://www.cnblogs.com/lee0oo0/p/3728271.html)

IDEA 系的一个可将 java/kotlin 编译成 smali 的插件 [java2smali](https://plugins.jetbrains.com/plugin/7385-java2smali/versions), 目前只能手动安装，具体安装方法网上一大堆

### 四、回编译及签名

#### 1、清除 apk 原签名

删除 apk 包里面的 `META-INF` 文件夹里除 `MANIFEST.MF` 的所有内容，此文件夹包含原签名信息。

#### 2、回编译

用 [apktool](/apktool) 回编译

```
apktool b target -o target_new.apk
```

#### 3、重新签名

用 [jdk](https://www.oracle.com/java/technologies/javase-jdk8-downloads.html) 的 `jarsigner` 重新签名

```
jarsigner -verbose -keystore %KEYSTORE% -signedjar %OUTPUT% %INPUT% %ALIAS%
```

注意点

> 网上教程的 `signapk.jar` 是 Android 源码包中的一个签名工具，`testkey.pk8` 和 `testkey.x509.pem` 也是源码提供的签名文件。我们使用自己的签名文件签名就可以了

> 安装不同签名的 apk 需要卸载重装
