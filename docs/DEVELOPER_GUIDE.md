# Mobile Store - Developer Quick Reference

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run specific test
flutter test test/core/services/tax_service_test.dart
```

## Project Architecture

### Folder Structure Pattern

```
lib/app/modules/{feature}/
├── bindings/          # Dependency injection
├── controllers/       # State management
├── repositories/      # Data access layer
├── services/          # Business logic (optional)
├── views/            # Screens/pages
└── widgets/          # Reusable components
```

## Common Patterns

### 1. Creating a New Module

```dart
// 1. Create folders
mkdir -p lib/app/modules/myfeature/{bindings,controllers,repositories,views,widgets}

// 2. Create Repository
class MyFeatureRepo {
  final JsonDbService _db;
  static const String _fileName = 'myfeature';
  
  MyFeatureRepo(this._db);
  
  Future<List<MyModel>> list({String? query}) async {
    final raw = await _db.readList(_fileName);
    var items = raw.map((e) => MyModel.fromJson(e)).toList();
    // Apply filters, sorting
    return items;
  }
  
  Future<void> upsert(MyModel item) async {
    final rows = await _db.readList(_fileName);
    final idx = rows.indexWhere((e) => e['id'] == item.id);
    if (idx == -1) {
      rows.add(item.toJson());
    } else {
      rows[idx] = item.toJson();
    }
    await _db.writeList(_fileName, rows);
  }
  
  Future<void> remove(String id) async {
    final rows = await _db.readList(_fileName);
    rows.removeWhere((e) => e['id'] == id);
    await _db.writeList(_fileName, rows);
  }
}

// 3. Create Controller
class MyFeatureController extends GetxController {
  final MyFeatureRepo _repo;
  MyFeatureController(this._repo);
  
  final state = const Idle<List<MyModel>>().obs;
  final query = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    debounce(query, (_) => fetch(), time: const Duration(milliseconds: 250));
    fetch();
  }
  
  Future<void> fetch() async {
    state.value = const Loading();
    try {
      final data = await _repo.list(query: query.value);
      state.value = data.isEmpty ? const Empty() : Ready(data);
    } catch (e) {
      state.value = ErrorState(e.toString());
    }
  }
  
  Future<void> save(MyModel item) async {
    await _repo.upsert(item);
    await fetch();
    Get.snackbar('Success', 'Saved successfully');
  }
  
  Future<void> delete(String id) async {
    await _repo.remove(id);
    await fetch();
    Get.snackbar('Success', 'Deleted successfully');
  }
}

// 4. Create Binding
class MyFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyFeatureRepo(Get.find<JsonDbService>()));
    Get.put(MyFeatureController(Get.find()));
  }
}

// 5. Create View
class MyFeatureListView extends GetView<MyFeatureController> {
  const MyFeatureListView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: Obx(() {
        final state = controller.state.value;
        return switch (state) {
          Idle() => const Center(child: Text('Ready')),
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => const EmptyStateWidget(),
          Ready(data: final items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ItemCard(item: items[index]),
            ),
          ErrorState(message: final msg) => ErrorStateWidget(message: msg),
        };
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const MyFeatureFormView()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### 2. Creating a Data Model

```dart
class MyModel {
  final String id;
  final String name;
  
  const MyModel({
    required this.id,
    required this.name,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
  
  factory MyModel.fromJson(Map<String, dynamic> json) => MyModel(
    id: json['id'] as String,
    name: json['name'] as String,
  );
  
  @override
  String toString() => 'MyModel(id: $id, name: $name)';
}
```

### 3. Using UiState Pattern

```dart
// In Controller
final state = const Idle<List<Item>>().obs;

// Set loading
state.value = const Loading();

// Set success with data
state.value = Ready(items);

// Set empty
state.value = const Empty();

// Set error
state.value = ErrorState('Error message');

// In View
Obx(() {
  final state = controller.state.value;
  return switch (state) {
    Idle() => const IdleWidget(),
    Loading() => const LoadingWidget(),
    Ready(data: final data) => DataWidget(data: data),
    Empty() => const EmptyWidget(),
    ErrorState(message: final msg) => ErrorWidget(msg),
  };
})
```

### 4. Search with Debouncing

```dart
// In Controller
final query = ''.obs;

@override
void onInit() {
  super.onInit();
  debounce(
    query,
    (_) => fetch(),
    time: const Duration(milliseconds: 250),
  );
}

void search(String value) {
  query.value = value;
}

// In View
TextField(
  onChanged: controller.search,
  decoration: const InputDecoration(
    hintText: 'Search...',
    prefixIcon: Icon(Icons.search),
  ),
)
```

### 5. Form Validation

```dart
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();

// In build
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Name is required';
          }
          return null;
        },
      ),
      ElevatedButton(
        onPressed: _submit,
        child: const Text('Submit'),
      ),
    ],
  ),
)

void _submit() {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  // Process form
}
```

### 6. GST Calculation

```dart
final taxService = Get.find<TaxService>();

// Intra-state (CGST + SGST)
final result = taxService.calculate(
  taxable: 100000,
  taxRate: 18,
  intraState: true,
);
// result.cgst = 9000
// result.sgst = 9000
// result.total = 118000

// Inter-state (IGST)
final result = taxService.calculate(
  taxable: 100000,
  taxRate: 18,
  intraState: false,
);
// result.igst = 18000
// result.total = 118000
```

### 7. Invoice Numbering

```dart
final numberService = Get.find<NumberSeriesService>();

// Generate invoice number
final invoiceNo = await numberService.next('invoice');
// Returns: INV-20251107-001

// Custom prefix
final purchaseNo = await numberService.next('purchase', prefix: 'PUR');
// Returns: PUR-20251107-001
```

### 8. Empty State Widget

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.inbox_outlined,
        size: 96,
        color: Theme.of(context).colorScheme.secondary,
      ),
      const SizedBox(height: 16),
      Text(
        'No items found',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      Text(
        'Add your first item to get started',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: () => _showAddForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    ],
  ),
)
```

## Design Tokens Reference

```dart
// Spacing
AppTokens.spacing4    // 4.0
AppTokens.spacing8    // 8.0
AppTokens.spacing16   // 16.0
AppTokens.spacing24   // 24.0
AppTokens.spacing32   // 32.0

// Border Radius
AppTokens.radius8     // 8.0
AppTokens.radius16    // 16.0
AppTokens.radius24    // 24.0

// Durations
AppTokens.duration120ms
AppTokens.duration200ms
AppTokens.duration300ms

// Icons
AppTokens.iconSizeSmall   // 16.0
AppTokens.iconSizeMedium  // 24.0
AppTokens.iconSizeLarge   // 32.0
AppTokens.iconSizeXLarge  // 48.0

// Colors
AppTokens.seedColor       // #B00020
```

## Testing Patterns

### Unit Test with Mock

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockJsonDbService extends Mock implements JsonDbService {}

void main() {
  late MyService service;
  late MockJsonDbService mockDb;
  
  setUp(() {
    mockDb = MockJsonDbService();
    Get.put<JsonDbService>(mockDb);
    service = MyService();
  });
  
  tearDown(() {
    Get.reset();
  });
  
  test('should return data', () async {
    when(() => mockDb.readList('file')).thenAnswer(
      (_) async => [{'id': '1', 'name': 'Test'}],
    );
    
    final result = await service.getData();
    
    expect(result, isNotEmpty);
    verify(() => mockDb.readList('file')).called(1);
  });
}
```

## Common Gotchas

1. **Don't forget to dispose controllers**
   ```dart
   @override
   void dispose() {
     _textController.dispose();
     super.dispose();
   }
   ```

2. **Always use const for widgets when possible**
   ```dart
   const Text('Hello')  // Good
   Text('Hello')        // Less efficient
   ```

3. **Use GetView for better type safety**
   ```dart
   class MyView extends GetView<MyController> {
     // controller is automatically available
   }
   ```

4. **Debounce expensive operations**
   ```dart
   debounce(query, (_) => search(), time: Duration(milliseconds: 250));
   ```

5. **Handle null safety properly**
   ```dart
   customer.phone ?? 'No phone'  // Null coalescing
   customer.email?.toLowerCase()  // Null-aware access
   ```

## Useful Commands

```bash
# Clean build
flutter clean && flutter pub get

# Run with specific device
flutter run -d chrome
flutter run -d android
flutter run -d ios

# Generate coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## File Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables: `camelCase`
- Constants: `camelCase` or `SCREAMING_SNAKE_CASE`

## Git Commit Messages

```
Add feature X
Update component Y
Fix bug in Z
Refactor service A
Test module B
Document feature C
```

## Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Material 3 Guidelines](https://m3.material.io/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)

---

**Last Updated**: November 7, 2025
