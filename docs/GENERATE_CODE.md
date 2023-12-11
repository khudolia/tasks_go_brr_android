## Models

To generate json serialization from models use command:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Splash screen

To generate splash screen for ios and android use command:
```bash
flutter pub run flutter_native_splash:create flutter_native_splash.yaml
```

## Flutter Launcher Icons

To generate app icons for ios and android use command:
```bash
flutter pub run flutter_launcher_icons:main
```

## Reduce shader compilation jank on mobile

To generate Skia Shader Language (SkSL) file use command:
```bash
flutter run --profile -t lib/main.dart --flavor dev --cache-sksl --purge-persistent-cache
```

- Press M at the command line of flutter run to write the captured SkSL shaders into a file named something like
  flutter_01.sksl.json. For best results, capture SkSL shaders on actual Android and iOS devices separately.

## Localization

First of you need to global activate intl_generator, use
```bash
flutter pub global activate intl_generator
```

To generate arb files use command:
```bash
flutter pub global run intl_generator:extract_to_arb --output-dir=lib/l10n/generated_arb lib/localizations.dart
```

To generate dart files from arb use command:
```bash
flutter pub global run intl_generator:generate_from_arb lib/localizations.dart lib/l10n/generated_arb/*.arb --output-dir=lib/l10n/generated_from_arb
```

Video example of setting localization in your app:
https://www.youtube.com/watch?v=fIMwFcC9bsc

### [Back](../README.md)