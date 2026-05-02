---
name: Theming & Styling
description: Color palette, theme setup, and styling conventions
type: project
---

## Colors

All colors are `static const` fields on `AppColors` (`core/utils/theme/app_colors.dart`). Never hardcode hex values or use `Colors.*` directly in widgets.

| Token | Value | Use |
|-------|-------|-----|
| `AppColors.primary` | `#007AFF` | Primary actions, links |
| `AppColors.babyBlue` | `#0779B8` | Secondary accent |
| `AppColors.babyBlue10` | babyBlue at 5% opacity | Subtle backgrounds |
| `AppColors.background` | `#FFFFFF` | Scaffold background |
| `AppColors.greyBorder` | `Colors.grey[200]` | Input and card borders |
| `AppColors.grey` | `Colors.grey` | Secondary text, icons |
| `AppColors.black` / `AppColors.white` | — | Text and surfaces |
| `AppColors.mainIndicator` | `#C4C4C4` | Page indicators |
| `AppColors.transparent` | — | Transparent layers |

## Theme

`AppTheme.lightTheme` (`core/utils/theme/app_theme.dart`) defines the app-wide `ThemeData`. It sets:
- `colorScheme` seeded from `AppColors.primary`
- `scaffoldBackgroundColor` = `AppColors.background`
- `appBarTheme` — white background, black foreground, no elevation
- `inputDecorationTheme` — rounded 8px borders using `AppColors.greyBorder`

Extend `AppTheme` for new theme properties. Do not define inline `ThemeData` in widgets.
