# Architecture Diagram

## Flutter GetX Architecture Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                          Application                             │
│                         (main.dart)                              │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐   │
│  │            InitialBindings (Permanent)                  │   │
│  │  ┌──────────────────────┐  ┌──────────────────────┐  │   │
│  │  │  AuthService         │  │ FeatureRegistryService│  │   │
│  │  │  (permanent: true)   │  │  (permanent: true)    │  │   │
│  │  └──────────────────────┘  └──────────────────────┘  │   │
│  └────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ├─────────────┬─────────────┐
                                │             │             │
                    ┌───────────▼──┐   ┌─────▼──────┐  ┌──▼──────┐
                    │  Login Route │   │ Home Route │  │ Others  │
                    │              │   │            │  │         │
                    └───────┬──────┘   └─────┬──────┘  └─────────┘
                            │                 │
                ┌───────────▼─────────┐       │
                │   AuthBinding       │       │
                │   (fenix: true)     │       │
                │                     │       │
                │  ┌───────────────┐ │       │
                │  │AuthController │ │       │
                │  │               │ │       │
                │  │ - onInit()    │ │       │
                │  │ - onReady()   │ │       │
                │  │ - onClose()   │ │       │
                │  │ - Timer       │ │       │
                │  │ - randomState │ │       │
                │  └───────────────┘ │       │
                └─────────────────────┘       │
                                              │
                                    ┌─────────▼─────────┐
                                    │   HomeBinding     │
                                    │   (fenix: true)   │
                                    │                   │
                                    │  ┌─────────────┐ │
                                    │  │HomeController│ │
                                    │  │              │ │
                                    │  │ - onInit()   │ │
                                    │  │ - onReady()  │ │
                                    │  │ - onClose()  │ │
                                    │  │ - Timer      │ │
                                    │  │ - randomState│ │
                                    │  └─────────────┘ │
                                    └───────────────────┘
```

## Service Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Service Layer                            │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              AuthService (Permanent)                  │  │
│  │                                                       │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │        AuthRepository (In-Memory)            │   │  │
│  │  │                                               │   │  │
│  │  │  • validate(email, password) => true         │   │  │
│  │  │  • login(email, password) => User            │   │  │
│  │  │  • logout() => void                          │   │  │
│  │  │  • getCurrentUser() => User?                 │   │  │
│  │  │  • isAuthenticated() => bool                 │   │  │
│  │  │                                               │   │  │
│  │  │  Storage: User? _currentUser (in-memory)     │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │      FeatureRegistryService (Permanent)              │  │
│  │                                                       │  │
│  │  • registerFeature(name, binding)                    │  │
│  │  • createFeatureBindings() [ON LOGIN]                │  │
│  │  • deleteFeatureBindings() [ON LOGOUT]               │  │
│  │  • clearFeatures()                                   │  │
│  │  • getRegisteredFeatures() => List<String>           │  │
│  │                                                       │  │
│  │  Storage: Map<String, Bindings> (in-memory)          │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## User Flow

```
┌─────────┐
│  START  │
└────┬────┘
     │
     ▼
┌─────────────────┐
│  Login Screen   │
│                 │
│ • Enter Email   │
│ • Enter Pass    │
│ • Random State  │◄─── Timer updates every 3s
│   (updates)     │
└────┬────────────┘
     │
     │ [Click Login]
     ▼
┌─────────────────────────┐
│  AuthService.login()    │
│                         │
│  1. validate()          │──► Always returns true
│  2. login()             │──► Creates User in memory
│  3. createFeatureBindings() │──► Initializes HomeBinding
└────┬────────────────────┘
     │
     │ [Success]
     ▼
┌─────────────────┐
│  Home Screen    │
│                 │
│ • User Email    │
│ • Counter       │
│ • Random State  │◄─── Timer updates every 2s
│   (updates)     │
└────┬────────────┘
     │
     │ [Click Logout]
     ▼
┌─────────────────────────┐
│  AuthService.logout()   │
│                         │
│  1. deleteFeatureBindings() │──► Removes HomeBinding
│  2. logout()            │──► Clears User from memory
└────┬────────────────────┘
     │
     │ [Complete]
     ▼
┌─────────────────┐
│  Login Screen   │
└─────────────────┘
```

## Controller Lifecycle with fenix:true

```
┌────────────────────────────────────────────────────────┐
│             Controller Lifecycle (fenix:true)          │
│                                                        │
│  Route Entered                                         │
│       │                                                │
│       ▼                                                │
│  ┌──────────┐                                         │
│  │ onCreate │  ──► New instance created                │
│  └────┬─────┘                                         │
│       │                                                │
│       ▼                                                │
│  ┌──────────┐                                         │
│  │ onInit() │  ──► Print debug message                 │
│  └────┬─────┘      Start Timer                        │
│       │                                                │
│       ▼                                                │
│  ┌──────────┐                                         │
│  │onReady() │  ──► Print debug message                 │
│  └────┬─────┘                                         │
│       │                                                │
│       ▼                                                │
│  ┌──────────┐                                         │
│  │ Running  │  ──► Timer updates randomState           │
│  └────┬─────┘                                         │
│       │                                                │
│       │ Route Exited                                   │
│       ▼                                                │
│  ┌──────────┐                                         │
│  │onClose() │  ──► Print debug message                 │
│  └────┬─────┘      Cancel Timer                       │
│       │                                                │
│       ▼                                                │
│  ┌──────────┐                                         │
│  │ Disposed │  ──► Instance kept in memory             │
│  └────┬─────┘      (fenix: true)                      │
│       │                                                │
│       │ Route Re-entered                               │
│       │                                                │
│       └──────────► Back to onCreate (Reuse or New)     │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## Feature Structure

```
features/
├── auth/
│   ├── controllers/
│   │   └── AuthController
│   │       • extends BaseController
│   │       • implements fenix: true
│   │       • Timer for random state (3s)
│   │       • login() method
│   │
│   ├── models/
│   │   └── User
│   │       • id: String
│   │       • name: String
│   │       • email: String
│   │
│   ├── repositories/
│   │   └── AuthRepository
│   │       • In-memory storage
│   │       • validate() => true
│   │       • login/logout methods
│   │
│   └── screens/
│       └── LoginScreen
│           • Email/Password inputs
│           • Login button
│           • Random state display
│
└── home/
    ├── controllers/
    │   └── HomeController
    │       • extends BaseController
    │       • implements fenix: true
    │       • Timer for random state (2s)
    │       • logout() method
    │       • incrementCounter() method
    │
    └── screens/
        └── HomeScreen
            • User email display
            • Counter display
            • Increment button
            • Logout button
            • Random state display
```

## Data Flow

```
User Action → Controller → Service → Repository → Memory
                ↓                                    ↑
            UI Update ←────────────────────────────┘
```

## Debug Output Flow

```
App Start
    ↓
[InitialBindings] Setting up permanent services
[FeatureRegistryService] Registering feature: home
[AppRoutes] Feature registry initialized
    ↓
Login Screen
    ↓
[AuthBinding] Setting up auth dependencies
[AuthController] onInit called
[AuthController] onReady called
[AuthController] Random state updated: XX
    ↓
User Logs In
    ↓
[AuthService] Attempting login for: user@example.com
[AuthRepository] Validating credentials for: user@example.com
[AuthRepository] Logging in user: user@example.com
[FeatureRegistryService] Creating feature bindings
[HomeBinding] Setting up home dependencies
[AuthService] Login successful for: user@example.com
    ↓
Home Screen
    ↓
[HomeController] onInit called
[HomeController] onReady called
[HomeController] Random state updated: XX
    ↓
User Logs Out
    ↓
[AuthService] Logging out
[FeatureRegistryService] Deleting feature bindings
[AuthRepository] Logging out user: user@example.com
[AuthService] Logout successful
[HomeController] onClose called
```
