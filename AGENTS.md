# BookEase Engineering & Architecture Guidelines

This document outlines the architectural patterns, coding standards, and best practices for the **BookEase** Flutter application.

---

## 🏛️ 1. Architecture: Feature-First Clean Architecture

The project follows a **Feature-First Clean Architecture** with strict layer separation:

```
lib/
├── core/                               # Shared code across features
│   ├── di/                             # Service Locator / Dependency Injection (GetIt)
│   ├── errors/                         # Exceptions and Failure mappings
│   ├── routes/                         # Named routes & onGenerateRoute navigation
│   ├── services/                       # Global services (Auth, Firestore, etc.)
│   ├── theme/                          # AppColors, AppTheme, and typography
│   ├── utils/                          # Validators, formatters, and helpers
│   └── widgets/                        # Reusable cross-feature UI widgets
└── features/                           # Encapsulated feature modules (lowercase snake_case)
    ├── admin/                          # System overview & platform administration
    ├── auth/                           # Authentication logic (AuthCubit, UserCubit, AuthRepo)
    ├── booking/                        # Client booking state, history & creation
    ├── discover/                       # Service search, category filters & provider discovery
    ├── home/                           # Client home dashboard & recommended services
    ├── login/                          # Sign-in UI & flow
    ├── messages/                       # Real-time chat & conversation threads
    ├── notifications/                  # In-app notifications & push alerts
    ├── on_boarding/                    # Intro walkthrough & splash flow
    ├── profile/                        # Client profile, settings & role switching
    ├── provider_availability/          # Working hours & schedule management
    ├── provider_bookings/              # Provider appointment management & status updates
    ├── provider_dashboard/             # Provider analytics, metrics & upcoming schedule
    ├── provider_profile/               # Provider public profile, bio & clinic info
    ├── provider_services/              # Service catalog management (CRUD services)
    ├── register/                       # Sign-up & new user onboarding
    ├── role_selection/                 # Role picker (Client vs. Provider)
    ├── root/                           # Root shell & role-based bottom navigation
    ├── service_details/                # Service view, slot picking & booking summary
    ├── settings/                       # Global app settings (dark mode, notifications)
    └── splash/                         # Initial launch & auth check
```

### Feature Module Structure
Each feature must follow this subfolder structure:
* `data/`
  * `models/` - Data Transfer Objects (DTOs) with `fromJson` and `toJson`.
  * `repo/` - Repository contracts (`*_repo.dart`) and implementations (`*_repo_impl.dart`).
  * `services/` - Feature-specific API or remote datasource callers.
  * `cubit/` (or `bloc/`) - Business logic, state classes, and reactive events.
* `presentation/`
  * `views/` - Top-level screen widgets (e.g., `booking_view.dart`, `chat_view.dart`).
  * `views/widgets/` - Sub-components, cards, and specialized UI sections.

---

## 👥 2. Multi-Role System Architecture

BookEase supports three distinct user roles:

1. **Customer / Client (`CustomerRootView` / `RootView`)**:
   - Bottom Navigation: **Home**, **Discover**, **Bookings**, **Messages**, **Profile**.
   - Capabilities: Browse services, book appointments, make payments, chat with providers, manage booking history.

2. **Service Provider (`ProviderRootView`)**:
   - Bottom Navigation: **Dashboard**, **Bookings**, **Services**, **Availability**, **Profile**.
   - Capabilities: View revenue & appointment metrics, accept/reject bookings, manage service offerings & pricing, configure weekly availability slots.

3. **Administrator (`AdminView`)**:
   - Capabilities: Platform-wide analytics, user moderation, system metrics.

---

## ⚙️ 3. Dependency Injection (`GetIt`)
* All singleton services, repositories, and factory cubits are registered in [`lib/core/di/service_locator.dart`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/di/service_locator.dart).
* Never instantiate repositories directly inside UI widgets or `MultiBlocProvider`. Always resolve them via `sl<Type>()`.
* Use `registerFactory` for Cubits to ensure proper lifecycle management per widget subtree.

---

## 🧭 4. Navigation & Routing
* Use centralized named routing in [`lib/core/routes/app_routes.dart`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/routes/app_routes.dart).
* Navigate using `Navigator.pushNamed(context, AppRoutes.yourRoute, arguments: ...)` instead of inline `MaterialPageRoute`.

---

## 🎨 5. Theme & Design System
* Always use colors from [`AppColors`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/theme/app_colors.dart) rather than hardcoded hex integers.
* Global styling (buttons, text fields, cards, app bar) is configured in [`AppTheme`](file:///C:/Users/Abo%20ALkhair/Desktop/BookEase/book_ease/lib/core/theme/app_theme.dart).

---

## 🧪 6. Testing Conventions
* Automated unit tests reside under the `test/` directory matching the feature hierarchy:
  * `test/core/utils/` - Utility & validator tests
  * `test/features/<feature_name>/cubit/` - Cubit state transition tests using `bloc_test` and `mocktail`.
* Run tests with:
  ```bash
  flutter test
  ```
* Ensure `flutter analyze` always reports **0 issues**.
