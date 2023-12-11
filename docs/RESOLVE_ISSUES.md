## To resolve problems with pods use:

1. Clean resources:
```bash
flutter clean && cd ios && rm -rf Pods && rm Podfile.lock && flutter pub get
```

2. Update pods: 
```bash
pod repo update && pod install && cd..
```
(OR Specified for m1 processor):
```bash
arch -x86_64 pod repo update && arch -x86_64 pod install && cd ..
```

Full command:
```bash
flutter clean && cd ios && rm -rf Pods && rm Podfile.lock && flutter pub get && arch -x86_64 pod repo update && arch -x86_64 pod install && cd ..
```

### [Back](../README.md)