---
name: Routing
description: How navigation works — named routes, AppRouter, argument passing
type: project
---

## Route constants

All route strings are `static const` fields on `AppRoutes` (`core/utils/route/app_routes.dart`):

```dart
AppRoutes.authRoute        // '/auth'
AppRoutes.homeRoute        // '/home'  → CustomBottmNavbar (tab shell)
AppRoutes.profileRoute     // '/profile'
AppRoutes.postRoute        // '/post'  → CreatePostPage
AppRoutes.editProfileRoute // '/edit-profile'
AppRoutes.settingsRoute    // '/settings'
```

Add new route strings here before wiring them in `AppRouter`.

## AppRouter

`AppRouter.generateRoute` (`core/utils/route/app_router.dart`) is the single switch-case dispatcher for `onGenerateRoute`. All routes use `CupertinoPageRoute` for iOS-style transitions.

## Passing arguments

Arguments are passed as **typed objects** via `RouteSettings.arguments` and cast inside `AppRouter`:

| Route | Argument type |
|-------|--------------|
| `editProfileRoute` | `EditProfilePageArgs` |
| `postRoute` | `HomeCubit` (existing instance, passed via `BlocProvider.value`) |

Always create a dedicated `*PageArgs` model when a route needs multiple parameters. Never pass raw maps or positional values.

## Initial route

`main.dart` sets `initialRoute` based on `AuthCubit` state:
- `AuthSuccess` → `AppRoutes.homeRoute`
- Anything else → `AppRoutes.authRoute`

## Unknown routes

`AppRouter` falls through to `NotFoundPage` (`core/views/pages/not_found_page.dart`) for unrecognised route names.
