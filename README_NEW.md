# Mobile Store - Flutter GetX Architecture

A complete Mobile Store management application built with Flutter and GetX, featuring inventory management with IMEI tracking, GST-compliant invoicing, and comprehensive reporting.

## 🏗️ Architecture

This application follows a **feature-scoped GetX architecture** where each module is self-contained with its own:
- Views (screens)
- Controllers (state management)
- Repositories (data access)
- Services (business logic)
- Widgets (reusable components)
- Bindings (dependency injection)

### Folder Structure

```
lib/app/
├── core/                          # Cross-cutting concerns
│   ├── config/                    # Environment configuration
│   ├── theme/                     # Design tokens & Material 3 theme
│   ├── state/                     # UiState pattern
│   ├── services/                  # App-wide services
│   │   ├── json_db_service.dart   # Local JSON database
│   │   ├── tax_service.dart       # GST calculations
│   │   ├── number_series_service.dart
│   │   └── auth_service.dart
│   └── utils/
├── data/
│   └── models/                    # Pure data models
└── modules/                       # Feature modules
    ├── dashboard/
    ├── masters/
    │   ├── vendors/
    │   ├── brands/
    │   ├── models/
    │   └── customers/
    ├── purchases/
    ├── stock/
    ├── sales/
    └── reports/
```

## 🚀 Features

### ✅ Implemented
- **Dashboard**: Quick access to all modules with visual cards
- **Vendors Management**: Full CRUD with search functionality
- **Brands Management**: Grid-based brand management
- **Local JSON Database**: Simulates backend with configurable latency
- **Material 3 UI**: Modern, responsive design with custom theme
- **GST Tax Service**: CGST/SGST (intra-state) and IGST (inter-state) calculations
- **Invoice Numbering**: Automatic sequential numbering (INV-yyyyMMdd-###)

### 🚧 Coming Soon
- Models Management
- Customers Management
- Purchase Orders (with bulk IMEI entry)
- Stock Management (IMEI tracking)
- Sales & Invoicing (PDF generation)
- Reports & Analytics (Excel/PDF exports)
- User Management & Roles
- Settings & Configuration

## 📱 Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | GetX |
| UI | Material 3 |
| Local Storage | JSON files (path_provider) |
| Routing | GetX Navigation |
| DI | GetX Dependency Injection |
| Testing | flutter_test, mocktail |

### Dependencies
```yaml
dependencies:
  get: ^4.6.5
  path_provider: ^2.1.1
  uuid: ^4.2.1
  intl: ^0.18.1
  pdf: ^3.10.7
  printing: ^5.11.1
  excel: ^4.0.1
```

## 🎨 Design System

### Theme
- **Seed Color**: `#B00020` (restrained red accent)
- **Design System**: Material 3
- **Border Radius**: 16dp default
- **Spacing**: 8-point grid system
- **Animation**: 200ms standard duration

### State Management Pattern
```dart
sealed class UiState<T> { const UiState(); }
class Idle<T> extends UiState<T> { }
class Loading<T> extends UiState<T> { }
class Ready<T> extends UiState<T> { final T data; }
class Empty<T> extends UiState<T> { }
class ErrorState<T> extends UiState<T> { final String message; }
```

Controllers expose `Rx<UiState<...>>` for reactive UI updates.

## 🔧 Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK (included with Flutter)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/md-riaz/Flutter-getx-architechture-test.git
cd Flutter-getx-architechture-test
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

Or run on specific platform:
```bash
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS (macOS only)
```

4. **Run tests**
```bash
flutter test
```

## 📊 Data Models

### Core Entities

**Brand**
```json
{
  "id": "brand_1",
  "name": "Apple"
}
```

**Vendor**
```json
{
  "id": "ven_1",
  "name": "ESOFTKING INFOTECH",
  "gst": "19CVNPM7263B2X9",
  "phone": "9002502002",
  "email": "esoft@gmail.com",
  "address": "Berhampore"
}
```

**Product Unit** (IMEI-based inventory)
```json
{
  "id": "unit_1",
  "brandId": "brand_1",
  "modelId": "model_1",
  "imei": "123456789012345",
  "color": "Space Gray",
  "ram": "8GB",
  "rom": "256GB",
  "purchasePrice": 95000,
  "sellPrice": 110000,
  "status": "in_stock"
}
```

## 🧪 Testing

### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/services/tax_service_test.dart

# Run with coverage
flutter test --coverage
```

### Test Coverage
- ✅ TaxService: GST calculations
- ✅ NumberSeriesService: Invoice numbering
- 🚧 Repository tests (coming soon)
- 🚧 Widget tests (coming soon)

## 📖 Documentation

- **Full Specification**: See [docs/spec_v1.md](docs/spec_v1.md) for complete requirements
- **Architecture Guide**: See [ARCHITECTURE.md](ARCHITECTURE.md) (if exists)
- **API Reference**: Generated from code comments

## 🎯 Key Principles

1. **Feature-Scoped Modules**: Each feature is self-contained
2. **Thin UI, Fat Logic**: Business logic lives in repositories and services
3. **Immutable State**: UiState pattern for predictable state management
4. **IMEI as Atomic Unit**: Inventory tracked at individual device level
5. **Local-First**: JSON database simulates backend, easy to swap later
6. **Testable**: Constructor-based dependency injection

## 🔐 Security & Privacy

- IMEI masking by default
- Role-based access control (Admin, Manager, Salesperson)
- GST number validation
- Audit logging (coming soon)

## 🌐 Responsive Design

- **Mobile** (≤600dp): Bottom FAB, modal drawer
- **Tablet** (600-1024dp): Two-column layout
- **Desktop** (≥1024dp): Persistent sidebar, data tables
- **Web**: Keyboard shortcuts, tab navigation

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please read the contributing guidelines first.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Contact

- **Author**: md-riaz
- **GitHub**: [@md-riaz](https://github.com/md-riaz)
- **Repository**: [Flutter-getx-architechture-test](https://github.com/md-riaz/Flutter-getx-architechture-test)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX community for state management patterns
- Material Design team for UI guidelines
