---
name: cubit-patterns
description: All BLoC/Cubit patterns used in this social media app — state naming, part files, BlocBuilder vs BlocListener, cubit scope, data enrichment, and common pitfalls.
version: 1.0.0
source: project-conventions
---

# Cubit Patterns — Social Media App

Reference for BLoC (Cubit) patterns across this Flutter social media app. Every feature follows these patterns consistently.

## Cubit Inventory

| Cubit | Location | Scope | Responsibility |
|-------|----------|-------|----------------|
| `AuthCubit` | `features/auth/cubit/` | App root (`main.dart`) | User session, login/register/logout |
| `PostsCubit` | `core/cubit/posts_cubit/` | App root (`main.dart`) | Global likes & comments |
| `HomeCubit` | `features/home/cubit/` | Route-scoped (passed via `BlocProvider.value` at `postRoute`) | Feed, stories, create post |
| `ProfileCubit` | `features/profile/cubit/profile_cubit/` | Feature-scoped | View own profile, fetch user posts |
| `EditProfileCubit` | `features/profile/cubit/edit_profile/` | Page-scoped | Edit profile fields, upload image |
| `DiscoverCubit` | `features/discover/cubit/` | Feature-scoped | Search/discover users |
| `SettingsCubit` | `features/settings/cubit/` | Feature-scoped | App settings, logout |

**Rule**: Only provide a cubit at app root if it must survive tab switches. Everything else is feature/page-scoped.

---

## Part File Pattern

States always live in a separate `part` file alongside the cubit. Never define states in the same file as the cubit class.

```
features/{name}/cubit/
├── {name}_cubit.dart    ← contains the Cubit class + `part '{name}_state.dart';`
└── {name}_state.dart    ← contains state classes + `part of '{name}_cubit.dart';`
```

```dart
// home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
// ... other imports

part 'home_state.dart'; // ← declares the part

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  // ...
}
```

```dart
// home_state.dart
part of 'home_cubit.dart'; // ← links to the part

abstract class HomeState {}
class HomeInitial extends HomeState {}
// ...
```

---

## State Naming Convention

```
{Domain}Initial      — starting state before any action
{Domain}Loading      — async operation in progress
{Domain}Loaded       — data fetch succeeded (use when returning data)
{Domain}Success      — write/mutation succeeded (use when no data to return)
{Domain}Error        — operation failed
```

Sub-states use descriptive prefixes for distinct loading phases:

```dart
// From HomeCubit — multiple independent loading phases
class StoriesLoading extends HomeState {}
class PostsLoading extends HomeState {}
class FetchingUserData extends HomeState {}
class ImagePicking extends HomeState {}
class FilePicking extends HomeState {}
```

This allows the UI to show specific loading indicators per phase.

---

## Emitting States: Pattern

```dart
Future<void> fetchPosts() async {
  emit(PostsLoading()); // show loading indicator
  try {
    final posts = await _homeServices.fetchPosts();
    // enrich...
    emit(HomeLoaded(posts: enrichedPosts));
  } catch (e) {
    emit(HomeError(message: e.toString())); // never swallow errors silently
  }
}
```

**Always emit an error state in the catch block.** Never use `catch (e) {}` with an empty body.

---

## BlocBuilder vs BlocListener vs BlocConsumer

### BlocBuilder — UI rebuilds only

```dart
BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    if (state is PostsLoading) return const PostsShimmer();
    if (state is HomeLoaded) return PostsList(posts: state.posts);
    if (state is HomeError) return ErrorView(message: state.message);
    return const SizedBox.shrink(); // HomeInitial
  },
);
```

### BlocListener — side effects only (navigation, dialogs, snackbars)

```dart
BlocListener<EditProfileCubit, EditProfileState>(
  listener: (context, state) {
    if (state is EditProfileSuccess) {
      Navigator.of(context).pop();
    }
    if (state is EditProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: const EditProfileForm(),
);
```

### BlocConsumer — both UI and side effects

```dart
BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
    if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    if (state is ProfileLoading) return const ProfileShimmer();
    if (state is ProfileLoaded) return ProfileContent(user: state.user);
    return const SizedBox.shrink();
  },
);
```

**Rule**: Handle **every emitted state** in builder/listener. Never leave a state silently unhandled.

---

## Cubit Scope Patterns

### Pattern 1: Page-scoped (most common)

Create the cubit inside the page and trigger initial fetch:

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..fetchUserProfile(),
      child: const _ProfileView(),
    );
  }
}
```

### Pattern 2: App root (survive tab switches)

In `main.dart`:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthCubit()),
    BlocProvider(create: (_) => PostsCubit()),
  ],
  child: MaterialApp(...),
)
```

### Pattern 3: Existing instance via BlocProvider.value (pass across routes)

Used for `HomeCubit` at `postRoute` — the existing instance is passed so the post page shares the feed's cubit:

```dart
// In AppRouter.generateRoute
case AppRoutes.postRoute:
  final homeCubit = settings.arguments as HomeCubit;
  return CupertinoPageRoute(
    builder: (_) => BlocProvider.value(
      value: homeCubit,
      child: const CreatePostPage(),
    ),
    settings: settings,
  );
```

---

## Data Enrichment Pattern

Raw DB rows from Supabase don't include denormalized author data. Cubits are responsible for enriching after fetch.

```dart
Future<void> fetchPosts() async {
  emit(PostsLoading());
  try {
    final rawPosts = await _homeServices.fetchPosts();
    final enriched = <PostModel>[];

    for (var post in rawPosts) {
      final userData = await _coreAuthServices.getUserData(post.authorId);
      if (userData != null) {
        post = post.copyWith(  // immutable update via copyWith
          authorName: userData.name,
          authorImageUrl: userData.imageUrl,
        );
      }
      enriched.add(post);
    }

    emit(HomeLoaded(posts: enriched));
  } catch (e) {
    emit(HomeError(message: e.toString()));
  }
}
```

**This pattern is used in**: `HomeCubit.fetchPosts`, `HomeCubit.fetchStories`, `ProfileCubit.fetchUserPosts`, `PostsCubit.fetchComments`.

All models support `copyWith` for immutable updates — never mutate model fields directly.

---

## Accessing Cubit from a Widget

```dart
// Read without listening (trigger action, no rebuild)
context.read<HomeCubit>().fetchPosts();

// Watch (triggers rebuild on state change)
context.watch<HomeCubit>().state;

// Inside BlocBuilder/BlocConsumer (preferred)
BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) { ... },
);
```

---

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| State file not using `part of` | Add `part of '{name}_cubit.dart';` at top of state file |
| Feature cubit provided at app root | Move to page-scoped `BlocProvider` |
| Empty catch block | Always `emit({Name}Error(message: e.toString()))` |
| Missing state in BlocBuilder | Handle all states — add missing `if (state is X)` branch |
| Mutating model directly | Use `model = model.copyWith(field: newValue)` |
| Service enriching author data | Move enrichment to the cubit |
| Using `setState` inside a `BlocBuilder` widget | Convert widget to `StatefulWidget` and use cubit methods |
