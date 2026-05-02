---
name: new-feature-scaffold
description: Step-by-step checklist and templates for adding a new feature to this Flutter social media app — directory structure, model, service, cubit, view, and routing wiring.
version: 1.0.0
source: project-conventions
---

# New Feature Scaffold — Social Media App

Complete guide to add a new feature end-to-end, following the project's strict 4-layer architecture.

## When to Use

- Building a new screen or feature (notifications, DMs, explore, etc.)
- Adding a new entity to the data model
- Extending an existing feature with a new sub-page

## Step 0: Locate Reference Feature

Before writing anything, read an existing, complete feature:

```bash
# Profile is a good reference — has model, service, cubit, views, and routing
find lib/features/profile -type f -name "*.dart" | sort
```

Read each file to anchor your implementation to project conventions.

---

## Step 1: Create Directory Structure

```bash
mkdir -p lib/features/{name}/models
mkdir -p lib/features/{name}/services
mkdir -p lib/features/{name}/cubit
mkdir -p lib/features/{name}/views/pages
mkdir -p lib/features/{name}/views/widgets
```

---

## Step 2: Models

### Read Model (`{name}_model.dart`)

```dart
class {Name}Model {
  final String id;
  final String authorId;
  // add fields...

  // Optional enrichment fields (null until populated by cubit)
  final String? authorName;
  final String? authorImageUrl;

  const {Name}Model({
    required this.id,
    required this.authorId,
    this.authorName,
    this.authorImageUrl,
  });

  factory {Name}Model.fromMap(Map<String, dynamic> map) {
    return {Name}Model(
      id: map['id'] as String? ?? '',
      authorId: map['author_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': authorId,
    };
  }

  {Name}Model copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorImageUrl,
  }) {
    return {Name}Model(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
    );
  }

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      {Name}Model.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
```

### Write Model (`{name}_request_body.dart`)

```dart
class {Name}RequestBody {
  final String authorId;
  final String content;

  const {Name}RequestBody({
    required this.authorId,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'author_id': authorId,
      'content': content,
    };
  }
}
```

---

## Step 3: Service (`{name}_services.dart`)

```dart
import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/core/utils/app_tables_names.dart';
import '../models/{name}_model.dart';
import '../models/{name}_request_body.dart';

class {Name}Services {
  final _db = SupabaseDatabaseServices();

  Future<List<{Name}Model>> fetch{Name}s() async {
    return await _db.fetchRows<{Name}Model>(
      tableName: AppTablesNames.{name}s,
      fromMap: {Name}Model.fromMap,
    );
  }

  Future<void> create{Name}({Name}RequestBody body) async {
    await _db.insertRow(
      tableName: AppTablesNames.{name}s,
      data: body.toMap(),
    );
  }

  Future<void> delete{Name}(String id) async {
    await _db.deleteRow(
      tableName: AppTablesNames.{name}s,
      column: 'id',
      value: id,
    );
  }
}
```

> Add the table constant to `AppTablesNames` if it doesn't exist yet.

---

## Step 4: Cubit

### `{name}_state.dart`

```dart
part of '{name}_cubit.dart';

abstract class {Name}State {}

class {Name}Initial extends {Name}State {}

class {Name}Loading extends {Name}State {}

class {Name}Loaded extends {Name}State {
  final List<{Name}Model> items;
  {Name}Loaded({required this.items});
}

class {Name}Success extends {Name}State {}

class {Name}Error extends {Name}State {
  final String message;
  {Name}Error({required this.message});
}
```

### `{name}_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/core_auth_services.dart';
import '../models/{name}_model.dart';
import '../models/{name}_request_body.dart';
import '../services/{name}_services.dart';

part '{name}_state.dart';

class {Name}Cubit extends Cubit<{Name}State> {
  {Name}Cubit() : super({Name}Initial());

  final _{Name}Services _services = {Name}Services();
  final _coreAuthServices = CoreAuthServices();

  Future<void> fetch{Name}s() async {
    emit({Name}Loading());
    try {
      final raw = await _services.fetch{Name}s();
      final enriched = <{Name}Model>[];

      for (var item in raw) {
        final userData = await _coreAuthServices.getUserData(item.authorId);
        if (userData != null) {
          item = item.copyWith(
            authorName: userData.name,
            authorImageUrl: userData.imageUrl,
          );
        }
        enriched.add(item);
      }

      emit({Name}Loaded(items: enriched));
    } catch (e) {
      emit({Name}Error(message: e.toString()));
    }
  }

  Future<void> create{Name}({Name}RequestBody body) async {
    try {
      await _services.create{Name}(body);
      emit({Name}Success());
      await fetch{Name}s();
    } catch (e) {
      emit({Name}Error(message: e.toString()));
    }
  }
}
```

---

## Step 5: Page (`{name}_page.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/theme/app_colors.dart';
import '../cubit/{name}_cubit.dart';

class {Name}Page extends StatelessWidget {
  const {Name}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => {Name}Cubit()..fetch{Name}s(),
      child: const _{Name}View(),
    );
  }
}

class _{Name}View extends StatelessWidget {
  const _{Name}View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('{Name}')),
      body: BlocBuilder<{Name}Cubit, {Name}State>(
        builder: (context, state) {
          if (state is {Name}Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is {Name}Loaded) {
            return _{Name}ListView(items: state.items);
          }
          if (state is {Name}Error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## Step 6: Wire Routing

### `app_routes.dart` — add the constant

```dart
static const String {name}Route = '/{name}';
```

### `app_router.dart` — add the case

```dart
case AppRoutes.{name}Route:
  return CupertinoPageRoute(
    builder: (_) => const {Name}Page(),
    settings: settings,
  );
```

If the route needs arguments:
1. Create `{Name}PageArgs` in `features/{name}/models/`
2. Cast in `app_router.dart`: `final args = settings.arguments as {Name}PageArgs;`
3. Pass to page constructor

---

## Step 7: Cubit Scope Decision

| Scenario | Action |
|----------|--------|
| Feature cubit only needed on one page | Provide inside the page (Step 5 pattern) |
| Cubit must survive tab switches | Provide in `main.dart` at app root |
| Cubit is an existing instance from another route | Use `BlocProvider.value` in `app_router.dart` |

---

## Step 8: Final Checklist

- [ ] `{Name}Model`: `fromMap`, `toMap`, `copyWith`, `fromJson`, `toJson`
- [ ] `{Name}RequestBody`: `toMap` only
- [ ] Service only uses `SupabaseDatabaseServices` and `AppTablesNames`
- [ ] State file is `part of` the cubit file
- [ ] All states handled in BlocBuilder (no fallthrough)
- [ ] Only `AppColors.*` used — no `Colors.*` or hex literals
- [ ] Route constant added to `AppRoutes`
- [ ] Case added to `AppRouter.generateRoute` using `CupertinoPageRoute`
- [ ] Typed `*PageArgs` model used if route takes multiple params
- [ ] Cubit provided at correct scope
- [ ] `flutter analyze` passes with no issues
