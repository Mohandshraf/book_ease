# BookEase Workspace Instructions

Refer to [AGENTS.md](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/AGENTS.md) for full architectural guidelines and conventions.

## Core Rules
1. **Architecture**: Feature-First Clean Architecture (`lib/features/<feature_name>/...` in snake_case).
2. **State Management**: Flutter Bloc / Cubit pattern.
3. **Dependency Injection**: Use `sl<T>()` from `lib/core/di/service_locator.dart`.
4. **Routing**: Centralized type-safe routes in `lib/core/routes/app_routes.dart`.
5. **Theme**: Use `AppColors` and `AppTheme` from `lib/core/theme/`.
6. **Code Quality**: Always ensure `flutter analyze` and `flutter test` pass with 0 errors.
