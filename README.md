This is a reproducer repo for what I believe is a bridge invalidation bug in react native 0.73 when using brownfield apps.

When an app invalidates a bridge, create a new one, and manually post a `RCTUserInterfaceStyleDidChangeNotification` notification, the app crashes with an error stating that `"AccessibilityManager is nil"`` due to the module registry being nil inside RCTDeviceInfo.

Seems that this commit [eb3d5a4b838ca7f632f02022e9be48402ca9d71f](https://github.com/facebook/react-native/commit/eb3d5a4b838ca7f632f02022e9be48402ca9d71f) tried adding additional logging inside RCTDeviceInfo but that does not fix the issue.

## Steps to reproduce

1. Clone this repo
2. Install the app with new arch enabled
3. Run the app and select "Send UserInterfaceStyle event after invalidating"
4. Press the "Invalidate and create new instance" button

https://github.com/gabrieldonadel/rn073BridgeInvalidation/assets/11707729/75974536-da85-491c-967d-fc2b271a2808

