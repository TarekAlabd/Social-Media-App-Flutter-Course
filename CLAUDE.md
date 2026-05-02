# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run                              # Run the app
flutter test                             # Run all tests
flutter test test/widget_test.dart       # Run a single test file
flutter analyze                          # Lint / static analysis
flutter pub get                          # Install dependencies
flutter build apk --release              # Android release build
flutter build ios --release              # iOS release build
flutter pub run flutter_launcher_icons   # Regenerate launcher icons
```

## Specialized rules

Detailed rules live in `.claude/rules/`. Read the relevant file before working in that area:

| File | Covers |
|------|--------|
| [architecture.md](.claude/rules/architecture.md) | Directory layout, feature layer order, bottom nav |
| [state-management.md](.claude/rules/state-management.md) | Cubit scope, state naming, `BlocBuilder` / `BlocListener` usage |
| [routing.md](.claude/rules/routing.md) | `AppRoutes` constants, `AppRouter`, typed argument passing |
| [data-layer.md](.claude/rules/data-layer.md) | `SupabaseDatabaseServices`, table names, storage URLs, enrichment pattern, model conventions |
| [theming.md](.claude/rules/theming.md) | `AppColors` tokens, `AppTheme`, styling conventions |

## Agents

Specialized sub-agents live in `.claude/agents/`. Use them proactively:

| Agent | When to invoke |
|-------|---------------|
| [flutter-feature-builder](.claude/agents/flutter-feature-builder.md) | Creating a new feature or page (full 4-layer scaffold) |
| [flutter-reviewer](.claude/agents/flutter-reviewer.md) | After writing or modifying any Dart/Flutter code |
| [flutter-build-fixer](.claude/agents/flutter-build-fixer.md) | When `flutter analyze` or `flutter build` fails |
| [supabase-reviewer](.claude/agents/supabase-reviewer.md) | After modifying services, models, or any Supabase interaction |

## Skills

Reference skills live in `.claude/skills/`. Load when relevant:

| Skill | When to use |
|-------|-------------|
| [new-feature-scaffold](.claude/skills/new-feature-scaffold/SKILL.md) | Step-by-step checklist + templates for any new feature |
| [cubit-patterns](.claude/skills/cubit-patterns/SKILL.md) | BLoC/Cubit patterns, state naming, enrichment, common pitfalls |
