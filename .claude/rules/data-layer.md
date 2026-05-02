---
name: Data Layer (Supabase)
description: How to read/write data — SupabaseDatabaseServices, storage, and the data enrichment pattern
type: project
---

## SupabaseDatabaseServices singleton

`core/services/supabase_database_services.dart` is the **only** place that calls Supabase DB APIs. Feature services must use it instead of accessing `Supabase.instance.client` directly for database operations (storage uploads are the exception — they use `Supabase.instance.client.storage` directly in the service layer).

Available methods:

| Method | Purpose |
|--------|---------|
| `insertRow` | Insert a single row |
| `updateRow` | Update rows matching a column=value filter |
| `upsertRow` | Insert or update with optional conflict resolution |
| `deleteRow` | Delete rows matching a column=value filter |
| `fetchRow<T>` | Fetch a single row by primary key |
| `fetchRows<T>` | Fetch multiple rows with optional filter + sort |
| `tableStream<T>` | Realtime stream of all rows in a table |
| `recordStream<T>` | Realtime stream of a single row by ID |

## Supabase tables

Constants in `AppTablesNames` (`core/utils/app_tables_names.dart`):

| Constant | Table |
|----------|-------|
| `AppTablesNames.users` | `users` |
| `AppTablesNames.stories` | `stories` |
| `AppTablesNames.posts` | `posts` |
| `AppTablesNames.comments` | `comments` |

Always use `AppTablesNames.*` — never hardcode table name strings (except `DiscoverServices`, which still uses a raw string and should be migrated).

## Storage URLs

Files are uploaded with a path like `private/<iso-timestamp>`. The public URL is:

```dart
'${AppConstants.baseMediaUrl}$storagePath'
// e.g. 'https://yhfqwsvajrrqtrcflwxz.supabase.co/storage/v1/object/public/posts/private/...'
```

Always prepend `AppConstants.baseMediaUrl` when storing the URL in the database.

## Data enrichment pattern

Raw DB rows for posts, stories, and comments do **not** contain denormalized author data. Cubits are responsible for enriching them after fetching:

```dart
for (var post in rawPosts) {
  final userData = await coreAuthServices.getUserData(post.authorId);
  if (userData != null) {
    post = post.copyWith(authorName: userData.name, authorImageUrl: userData.imageUrl);
  }
  posts.add(post);
}
```

This pattern is used in `HomeCubit.fetchPosts`, `ProfileCubit.fetchUserPosts`, `PostsCubit.fetchComments`, and `HomeCubit.fetchStories`. All models support `copyWith` for immutable updates.

## Models convention

Every model has:
- `fromMap(Map<String, dynamic>)` factory
- `toMap()` method (omits null fields)
- `copyWith(...)` for immutable updates
- `fromJson` / `toJson` helpers

**Request bodies** (`PostRequestBody`, `CommentRequestBody`) are separate from read models (`PostModel`, `CommentModel`) — use request bodies for writes, read models for display.
