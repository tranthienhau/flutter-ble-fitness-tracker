# Screenshot & demo regeneration

How the committed screenshots and demo GIF are produced from the running app.

## Prerequisites

- Xcode iOS Simulator with an "iPhone 17 Pro" device.
- Flutter 3.41+.

## Boot the simulator

```bash
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator
```

## Capture screenshots (integration_test + flutter drive)

```bash
cd poc_next/flutter-ble-fitness-tracker
flutter pub get
flutter drive \
  --driver test_driver/integration_test.dart \
  --target integration_test/screenshot_test.dart \
  -d "iPhone 17 Pro"
```

This drives the real app through Connect -> Scan -> Connect sensor -> Live session -> Finish -> Summary -> History, writing PNGs to `screenshots/NN-name.png`.

### How it works

- `test_driver/integration_test.dart` uses `integrationDriver(onScreenshot:)` to write the captured bytes to `screenshots/`.
- `integration_test/screenshot_test.dart` navigates the screens and calls `binding.convertFlutterSurfaceToImage()` then `binding.takeScreenshot('NN-name')`.
- The connect screen has an always-on pulse animation, so the test uses fixed `pump(Duration)` calls rather than `pumpAndSettle` (which would never settle).

## Record the demo GIF

```bash
xcrun simctl io booted recordVideo --codec=h264 demo.mov &
# interact with the app (scan, connect, start session, finish, history)
# stop recording: kill %1
ffmpeg -i demo.mov -vf "fps=12,scale=320:-1:flags=lanczos" -loop 0 screenshots/demo.gif
```
