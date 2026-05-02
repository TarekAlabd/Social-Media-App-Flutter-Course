---
name: State Management (BLoC / Cubit)
description: Rules for writing cubits, states, and consuming them in the UI
type: project
---

## Cubit scope

| Cubit | Location | Provided at |
|-------|----------|-------------|
| `AuthCubit` | `features/auth/cubit/` | App root in `main.dart` |
| `PostsCubit` | `core/cubit/posts_cubit/` | App root in `main.dart` — handles likes & comments globally |
| `HomeCubit` | `features/home/cubit/` | Injected at `AppRoutes.postRoute` via `BlocProvider.value` |
| `ProfileCubit` | `features/profile/cubit/profile_cubit/` | Scoped to profile feature |
| `EditProfileCubit` | `features/profile/cubit/edit_profile/` | Scoped to edit profile page |
| `DiscoverCubit` | `features/discover/cubit/` | Scoped to discover feature |
| `SettingsCubit` | `features/settings/cubit/` | Scoped to settings feature |

Do not provide a feature cubit at the app root unless it needs to survive tab switches.

## State file convention

States always live in a `part` file named `*_state.dart` next to the cubit:

```dart
// home_cubit.dart
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> { ... }
```

## State naming pattern

```
<Domain>Initial
<Domain>Loading
<Domain>Loaded / <Domain>Success
<Domain>Error
```

Use descriptive prefixes for sub-states (e.g., `StoriesLoading`, `PostsLoading`, `FetchingUserData`, `ImagePicking`, `FilePicking`).

## UI consumption rules

- `BlocBuilder` — rebuild the widget tree on state change.
- `BlocListener` — side effects only (navigation, snackbars, dialogs).
- `BlocConsumer` — when both are needed in the same widget.
- Handle **every emitted state** explicitly. No silent fallthrough.
