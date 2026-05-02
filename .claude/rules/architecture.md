---
name: Project Architecture
description: High-level structure — feature layout, layer order, and shared core
type: project
---

Flutter social media app. State management: **BLoC (Cubit)**. Backend: **Supabase**.

## Directory layout

```text
lib/
├── core/                         # Shared across all features
│   ├── cubit/posts_cubit/        # Global cubit: likes & comments
│   ├── models/                   # CommentModel, CommentRequestBody
│   ├── services/                 # Shared services (see data-layer.md)
│   ├── utils/
│   │   ├── app_constants.dart    # Supabase URL, anon key, baseMediaUrl
│   │   ├── app_tables_names.dart # DB table name constants
│   │   ├── route/                # AppRouter + AppRoutes
│   │   └── theme/                # AppTheme + AppColors
│   └── views/                    # Shared widgets: PostItemWidget, MainButton
│
└── features/
    ├── auth/       # Login, register, password reset
    ├── home/       # Feed, stories, create post
    ├── discover/   # Find people to follow
    ├── profile/    # View/edit own profile
    └── settings/   # App settings, logout
```

## Feature layer order

Every feature uses this strict 4-layer structure. Dependencies flow inward only:

```
views/  →  cubit/  →  services/  →  models/
```

Views depend on cubits, cubits depend on services and models, services depend on models. Never skip a layer or import across features directly.

## Bottom navigation

`CustomBottmNavbar` (note the typo — keep it consistent) uses `persistent_bottom_nav_bar_v2` with `Style5BottomNavBar`. Tabs in order: Home, Discover, Profile, Settings.
