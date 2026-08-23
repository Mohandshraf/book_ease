# BookEase Engineering & Architecture Guidelines

This document outlines the architectural patterns, coding standards, and best practices for the **BookEase** Flutter application.

---

## 🏛️ 1. Architecture: Feature-First Clean Architecture

The project follows a **Feature-First Clean Architecture** with distinct layer separation:

```
lib/
├── core/                       # Shared code across features
│   ├── di/                     # Service Locator / Dependency Injection (GetIt)
│   ├── errors/                 # Exceptions and Failure mappings
│   ├── routes/                 # Named routes & onGenerateRoute navigation
│   ├── services/               # Global services (Auth, Firestore, etc.)
│   ├── theme/                  # AppColors, AppTheme, and typography
│   ├── utils/                  # Validators, formatters, and helpers
│   └── widgets/                # Reusable cross-feature UI widgets
└── features/                   # Encapsulated feature modules (lowercase snake_case)
    ├── admin/
    ├── auth/
    ├── booking/
    ├── discover/
    ├── home/
    ├── login/
    ├── messages/
    ├── on_boarding/
    ├── profile/
    ├── register/
    ├── role_selection/
    ├── root/
    ├── service_details/
    └── settings/
```

### Feature Module Structure
Each feature must follow this subfolder structure:
* `data/`
  * `models/` - Data Transfer Objects (DTOs) with `fromJson` and `toJson`.
  * `repo/` - Repository contracts (`*_repo.dart`) and implementations (`*_repo_impl.dart`).
  * `services/` - Feature-specific API or remote datasource callers.
  * `cubit/` (or `bloc/`) - Business logic, state classes, and reactive events.
* `presentation/`
  * `views/` - Top-level screen widgets (e.g., `booking_view.dart`).
  * `views/widgets/` - Sub-components, cards, and specialized UI sections.

---

## ⚙️ 2. Dependency Injection (`GetIt`)
* All singleton services, repositories, and factory cubits are registered in [`lib/core/di/service_locator.dart`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/di/service_locator.dart).
* Never instantiate repositories directly inside UI widgets or `MultiBlocProvider`. Always resolve them via `sl<Type>()`.

---

## 🧭 3. Navigation & Routing
* Use centralized named routing in [`lib/core/routes/app_routes.dart`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/routes/app_routes.dart).
* Navigate using `Navigator.pushNamed(context, AppRoutes.yourRoute, arguments: ...)` instead of inline `MaterialPageRoute`.

---

## 🎨 4. Theme & Design System
* Always use colors from [`AppColors`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/theme/app_colors.dart) rather than hardcoded hex integers.
* Global styling (buttons, text fields, cards, app bar) is configured in [`AppTheme`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/theme/app_theme.dart).

---

## 🧪 5. Testing Conventions
* Automated unit tests reside under the `test/` directory matching the feature hierarchy:
  * `test/core/utils/` - Utility & validator tests
  * `test/features/<feature_name>/cubit/` - Cubit state transition tests using `bloc_test` and `mocktail`.
* Run tests with:
  ```bash
  flutter test
  ```
* Ensure `flutter analyze` always reports **0 issues**.
