## Build dev

To build ios use command:
```bash
flutter build ios -t lib/main.dart --flavor dev --bundle-sksl-path flutter_ios.sksl.json
```

To build android bundle (for Google Play) use command:
```bash
flutter build appbundle -t lib/main.dart --flavor dev --bundle-sksl-path flutter_android.sksl.json
```

To build android apk (for install direct on phone) use command:
```bash
flutter build apk -t lib/main.dart --flavor dev --bundle-sksl-path flutter_android.sksl.json
```

## Build stage

To build ios use command:
```bash
flutter build ios -t lib/main.stage.dart --flavor stage --bundle-sksl-path flutter_ios.sksl.json
```

To build android bundle (for Google Play) use command:
```bash
flutter build appbundle -t lib/main.stage.dart --flavor stage --bundle-sksl-path flutter_android.sksl.json
```

To build android apk (for install direct on phone) use command:
```bash
flutter build apk -t lib/main.stage.dart --flavor stage --bundle-sksl-path flutter_android.sksl.json
```

## Environment settings for development

add 'environment/.env' file:
```text
NETWORK_LOGS=true
LOCAL_HOST=localhost:3000
```

## Run application

Dev:
```bash
flutter run -t lib/main.dart --flavor dev
flutter run -t lib/main.dart --profile --flavor dev
flutter run -t lib/main.dart --release --flavor dev
```

Stage:
```bash
flutter run -t lib/main.stage.dart --flavor stage
flutter run -t lib/main.stage.dart --profile --flavor stage
flutter run -t lib/main.stage.dart --release --flavor stage
```

Local:
```bash
flutter run -t lib/main.local.dart --flavor dev
flutter run -t lib/main.local.dart --profile --flavor dev
flutter run -t lib/main.local.dart --release --flavor dev
```

## Version of flutter

Last work version is 3.3.0

### [Back](../README.md)
