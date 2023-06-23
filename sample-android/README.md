# DivKitPro sample for Android

This sample project demonstrates how to install DivKitPro framework in your android project and use it.
The sample project contains a WebView and an input field in which you can enter the desired url and open it. It also contains a settings page where you can specify the server URL, API key and other request options and request fresh data.

## Installing DivKitPro

Download artifact via Gradle:
```
implementation 'com.yandex.div:div-pro:1.0.0'
```
or Maven:
```
<dependency>
  <groupId>com.yandex.div</groupId>
  <artifactId>div-pro</artifactId>
  <version>1.0.0</version>
</dependency>
```

## Using DivKitPro

For initialization of the framework in your project create an object with parameters and initialize sdk in your `Activity#onCreate()`:
```
override fun onCreate(savedInstanceState: Bundle?) {
    val params = DivProParams(
        url = "server url",
        appKey = "your API key",
    )
    val divPro = DivPro(this, params)
}
```

API key you can watch in settings for your project in <a href="https://divkit.pro/settings/project/">Administrator console</a>.
Set server url as `https://api.divkit.pro/v1/publications/` or other value if you need.
Then tell the framework when a certain event has occurred:
```
divPro.onStart()
divPro.onUrl(url)
divPro.onEvent(eventId)
```
The corresponding DivKit screen will be displayed after it.

## How DivKitPro works

 The framework requests fresh data from the server after initialization. Then it prepares the images and saves DivKit screens in the cache. Requests are repeated every 5 minutes when the application is active. You can change this interval by sending `updateIntervalSec` in `DivProParams`.
When an event occurs the framework checks cache for a suitable DivKit screen. Then it shows the screen on top of the other windows.
There is an interval between showing DivKit screens at the start of the application. You can change this interval in <a href="https://divkit.pro/">Administrator console</a>.
Each DivKit screen is shown only once until the next server response. If the screen is missing in the next server response it means that it no longer needs to be shown.

## Notes

For better presentation your activity should support configuration changes. Screen will be shown in portrait orientation if `orientation`, `screenSize` and `screenLayout` are declared in attribute `android:configChanges` for the activity in your `AndroidManifest.xml` file.
