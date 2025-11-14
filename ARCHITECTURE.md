# Architecture Overview

This project follows a modular **data → domain → presentation** layout that keeps business
rules independent from Flutter widgets while still embracing GetX for dependency injection
and routing. The diagram below shows the high-level flow:

```
┌──────────────┐      ┌─────────────────────┐      ┌────────────────────┐
│   Data       │      │       Domain        │      │   Presentation     │
│ Layer        │      │ Layer (Pure Dart)   │      │ Layer (GetX)       │
│              │      │                     │      │                    │
│ • Remote DS  │ ───▶ │ • Repository Abstra │ ───▶ │ • Feature Bindings │
│ • Local DS   │      │ • Use Cases         │      │ • Controllers      │
│ • DTOs       │      │ • Entities          │      │ • Views            │
│ • Impl Repo  │ ◀─── │                     │ ◀─── │ • Theme Service    │
└──────────────┘      └─────────────────────┘      └────────────────────┘
```

*Every* dependency flows in one direction—presentation depends on domain abstractions,
while domain depends only on pure Dart models and interfaces. The data layer implements
those interfaces via mappers and data sources that can be swapped for real APIs later.

---

## Domain Layer

Located in `lib/domain`, the domain layer exposes the contracts that the rest of the app
relies on.

- **Entities** live in `domain/<feature>/entities` and are simple value objects. Example:
  - `User` and `Todo` represent immutable business state.
- **Repository interfaces** (`domain/<feature>/repositories`) describe the operations that
  the presentation layer can invoke without knowing how the data is fetched or stored.
- **Use cases** (`domain/<feature>/usecases`) are small classes with a single `call`
  method. Each use case coordinates one piece of business logic (e.g. `LoginUseCase`,
  `CreateTodoUseCase`). Controllers depend on use cases rather than repositories directly,
  keeping orchestration thin and testable.

Use cases are free of GetX and Flutter so they can be reused in isolates, background tasks,
or replaced entirely without touching UI code.

---

## Data Layer

Located in `lib/data`, this layer turns the repository contracts into concrete behavior.

- **Data sources** split responsibilities between remote (e.g. simulated HTTP calls) and
  local storage (in-memory caches). For example, `FakeAuthRemoteDataSource` and
  `InMemoryAuthLocalDataSource` back the authentication flow.
- **DTOs** translate raw map/json payloads into strongly typed entities and back again.
  They keep serialization concerns away from the domain models.
- **Repository implementations** orchestrate the data sources, catch low level errors, and
  rethrow them as `DataException` instances so the UI can present meaningful feedback.

Because data sources are registered through GetX bindings, swapping a fake remote data
source for a real API client requires only binding changes.

---

## Dependency Injection & Feature Ownership

Each feature owns its dependencies via a dedicated binding class placed next to the
feature code (`lib/features/<feature>/binding`). Bindings register abstractions using
`Get.lazyPut` with `fenix: true` so objects are recreated automatically after disposal.

- `AuthBinding` wires the auth data sources, repository implementation, use cases, the
  long-lived `AuthService`, and finally the `AuthController`.
- `HomeBinding` resolves the existing auth use cases and registers the `HomeController`
  without cross-importing UI concerns from other modules.
- `TodosBinding` mirrors the same pattern for todo data sources, repository, use cases,
  shared `TodosService`, and the `TodosController`.
- Cross-cutting concerns like the theme reside in `lib/theme/theme_binding.dart`, which
  registers `ThemeService` once at app start via `initialBinding` in `main.dart`.

There is no global feature registry. Each route in `AppRoutes` specifies its binding,
ensuring that navigation automatically brings the required dependencies online.

---

## Controller Responsibilities

Controllers now delegate all business logic to injected use cases:

- `AuthController` only tracks form state (`email`, `password`, `isLoading`, `errorMessage`)
  and calls `LoginUseCase` / `LogoutUseCase`. It updates `AuthService` with the latest
  authenticated user so other features (e.g. Home) can observe the session.
- `HomeController` reads the current user via `GetCurrentUserUseCase` and invokes
  `LogoutUseCase`. UI reactions like navigation and snackbars are triggered inside the
  view widgets.
- `TodosController` manages UI state (`title`, `description`, `errorMessage`) while the
  injected todo use cases perform CRUD operations. The shared `TodosService` exposes an
  `RxList<Todo>` so multiple widgets can react to changes without duplicating state.

Controllers avoid timers, random demo data, and direct GetX navigation calls. Widgets are
responsible for feedback (dialogs/snackbars) and route changes based on controller results.

---

## Adding a New Feature

1. **Domain**: Create entity classes, a repository interface, and use cases inside
   `lib/domain/<feature>/`. Keep them pure Dart.
2. **Data**: Implement the repository in `lib/data/<feature>/` using the necessary data
   sources and DTO mappers. Throw `DataException` when external operations fail.
3. **Bindings**: Add a new binding under `lib/features/<feature>/binding` that registers
   the data sources, repository implementation, and use cases with `Get.lazyPut` (use
   `fenix: true` when instances should be recreated after disposal).
4. **Service (optional)**: If the feature needs shared reactive state, create a GetX
   service that receives the use cases through constructor injection.
5. **Controller & Views**: Implement controllers that depend only on use cases (and
   optional services) and expose UI-ready observables. Views should handle navigation,
   snackbars, and dialogs based on controller results.
6. **Routing**: Register the new route in `AppRoutes` and provide the feature binding.

Following this recipe keeps each module self-contained, making it easy to evolve or replace
parts of the stack without touching unrelated code.
