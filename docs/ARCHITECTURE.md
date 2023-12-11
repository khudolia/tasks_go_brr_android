# Architecture

Common approach is `BLoC`.
Where `BLoC` is `page-oriented` or `component-oriented` unit.

## lib

For app-wide business logic must be used `services`.
Conectivity, error handling, etc. are treated as `services`.

For communication via `network` or fetching data from `local storage` must be used `repository` unit.

`Screens` must be feature-oriented, e.g. within `auth` lies `login` and `signup` pages.
`Common widgets` within `feature` must be **withing features' folder**
`BLoC` must be within `feature folder`.

For `app-wide widgets` there's `widget folder` in the root of `lib/ui folder`.

`Utils` are set of helpers that reduces boilerplate.
If `util` has `business logic` then it must be a `service` or a `BLoC`.

`Models` includes app-wide `View-Models`, such as `Location`, etc.

Folder `l10n` contains app localization.

## Nested navigator pop workaround

If in nested navigator physical back button should work - than its context should be added to BottomBarPageType.

### [Back](../README.md)
