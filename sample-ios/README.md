# DivKitPro sample for iOS

This sample project demonstrates how to install DivKitPro framework in your iOS project and use it.
The sample project contains a web page and an input field in which you can enter the desired url and open it. It also contains a settings page where you can specify the server URL, API key and request fresh data.

## Installing DivKitPro

For installing the framework to your project with <a href="https://www.swift.org/package-manager/">Swift Package Manager</a> use url:
```
https://github.com/divkit/divkitpro.git
```

Add `DivKitPro` pod into your application `Podfile` to install DivKitPro using CocoaPods:
```
source 'https://github.com/divkit/divkit-ios.git'
source 'https://github.com/divkit/divkitpro.git'

target 'MyApp' do
  use_frameworks!
  pod 'DivKitPro'
end
```

## Using DivKitPro

For initialization of the framework in your project create an object with parameters:
```
let params = DivProParams(
  appKey: "your API key",
  url: "server url"
)
let divPro = DivPro(params: params)
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
When an event occurs the framework checks cache for a suitable DivKit screen. Then it shows the screen on top of the other windows. You can change the way the screen is displayed by passing your implementation `ScreenPresenter` in `DivPro`.
There is an interval between showing DivKit screens at the start of the application. You can change this interval in <a href="https://divkit.pro/">Administrator console</a>.
Each DivKit screen is shown only once until the next server response. If the screen is missing in the next server response it means that it no longer needs to be shown.
