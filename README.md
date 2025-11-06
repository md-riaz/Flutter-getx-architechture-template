# Flutter GetX Architecture Demo

A Flutter application demonstrating GetX architecture patterns with proper separation of concerns, featuring theme management, authentication, and todo list functionality.

## Architecture

### Structure
```
lib/
├── base/              # Base classes (BaseController)
├── binding/           # Dependency injection bindings
├── controller/        # (Reserved for future use)
├── features/          # Feature modules
│   ├── auth/         # Authentication feature
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── screens/
│   │   └── services/     # Feature-level auth service
│   ├── home/         # Home feature
│   │   ├── controllers/
│   │   └── screens/
│   └── todos/        # Todos feature (NEW)
│       ├── controllers/
│       ├── models/
│       ├── repositories/
│       ├── screens/
│       └── services/     # Feature-level todos service
├── helper/           # (Reserved for future use)
├── services/         # App-wide services
│   ├── feature_registry_service.dart
│   └── theme_service.dart  # Theme management (NEW)
├── theme/            # Theme configuration
└── util/             # Utilities and routes
```

## Features

### Controllers
- All controllers extend `BaseController`
- Implement `fenix: true` for auto-recovery
- Include lifecycle debug prints (onInit, onReady, onClose)
- Random state updates via Timer

### Authentication
- Local validation (always returns true)
- User stored in memory
- AuthRepository handles user management
- AuthService organized as feature-level service

### Theme Management (NEW)
- **ThemeService**: Manages light/dark theme state
- Toggle theme from home screen
- Persistent theme service via bindings
- System theme detection on startup

### Services
- **AuthService**: Manages authentication state (feature-level)
- **TodosService**: Manages todos CRUD operations (feature-level)
- **ThemeService**: Manages theme state (app-wide)
- **FeatureRegistryService**: Manages feature bindings
  - Creates bindings on login
  - Deletes bindings on logout

### Features
- **Auth**: Login screen with email/password
- **Home**: Welcome screen with counter, user info, and theme toggle
- **Todos**: Full CRUD todo list with statistics (NEW)
  - Create, read, update, delete todos
  - Mark todos as complete/incomplete
  - View statistics (total, pending, completed)
  - In-memory storage
  - Material 3 UI with responsive design

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/md-riaz/Flutter-getx-architechture-test.git
cd Flutter-getx-architechture-test
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

Or run on specific platform:
```bash
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS (macOS only)
```

4. Run tests:
```bash
flutter test
```

## Deployment

### Web Deployment to GitHub Pages

This project includes a GitHub Actions workflow for deploying the web version to GitHub Pages.

#### Manual Deployment

1. Go to the repository's Actions tab on GitHub
2. Select "Deploy Flutter Web to GitHub Pages" workflow
3. Click "Run workflow" button
4. Select the branch you want to deploy
5. Click "Run workflow" to start the deployment

The workflow will:
- Build the Flutter web application with the correct base-href
- Configure GitHub Pages settings
- Deploy the built web app to GitHub Pages

Once deployed, the app will be available at: `https://<username>.github.io/Flutter-getx-architechture-test/`

#### Requirements

- GitHub Pages must be enabled for the repository
- The workflow requires write permissions for the repository (already configured in the workflow file)

## Usage

### Login Flow
1. Open the app and navigate to the login screen
2. Enter any email and password (validation always succeeds)
3. Click "Login" to authenticate
4. Feature bindings are created automatically

### Home Screen
1. View user information
2. Increment counter
3. Toggle theme (light/dark mode)
4. Navigate to Todos screen
5. Logout to clear session

### Todos Screen
1. Click + button to add new todo
2. Enter title and description
3. Check/uncheck to toggle completion
4. Delete individual todos
5. View real-time statistics
6. Clear all todos with confirmation

## Platform Support

This app supports:
- ✅ Android (API 21+)
- ✅ iOS (iOS 11+)
- ✅ Web (Chrome, Firefox, Safari, Edge)

## Architecture Patterns

### Dependency Injection
All services and controllers use constructor-based dependency injection:
- **AuthService**: Accepts `AuthRepository` via constructor
- **AuthController**: Accepts `AuthService` via constructor
- **HomeController**: Accepts `AuthService` via constructor
- **TodosService**: Accepts `TodoRepository` via constructor
- **TodosController**: Accepts `TodosService` via constructor

This approach:
- Makes code more testable by allowing mock dependencies
- Follows SOLID principles and dependency inversion
- Maintains backward compatibility with GetX bindings through optional parameters

### Feature-Based Services
Services are now organized per feature:
- `features/auth/services/auth_service.dart` - Authentication
- `features/todos/services/todos_service.dart` - Todo management

### Global Services
App-wide services remain in `lib/services/`:
- `feature_registry_service.dart` - Feature lifecycle
- `theme_service.dart` - Theme management

## Notes

- No external APIs - all data is local and in-memory
- Services are permanent via bindings
- Feature bindings are dynamically created/deleted based on auth state
- Theme state persists across navigation
- All controllers implement GetX lifecycle methods with debug logging