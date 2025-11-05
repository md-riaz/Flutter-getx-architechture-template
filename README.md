# Flutter GetX Architecture Demo

A Flutter application demonstrating GetX architecture patterns with proper separation of concerns.

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
│   │   └── screens/
│   └── home/         # Home feature
│       ├── controllers/
│       ├── models/
│       ├── repositories/
│       └── screens/
├── helper/           # (Reserved for future use)
├── services/         # App-wide services
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

### Services
- **AuthService**: Manages authentication state (permanent)
- **FeatureRegistryService**: Manages feature bindings
  - Creates bindings on login
  - Deletes bindings on logout

### Features
- **Auth**: Login screen with email/password
- **Home**: Welcome screen with counter and user info

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

3. Run tests:
```bash
flutter test
```

## Usage

1. Open the app and navigate to the login screen
2. Enter any email and password (validation always succeeds)
3. Click "Login" to authenticate
4. View the home screen with user information
5. Click "Logout" to clear session and return to login

## Notes

- No external APIs - all data is local
- Services are permanent via bindings
- Feature bindings are dynamically created/deleted based on auth state