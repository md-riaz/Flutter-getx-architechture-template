# Mobile Store — Flutter (Web + Mobile) Specification v1.0

## WIRE+FRAME Product Specification

### W — Who & What

**Roles:** Admin, Manager, Salesperson

**What:** Master data (brands, models, vendors, customers), purchases (IMEI), stock, sales+invoice (GST), reports & export, users & settings.

### I — Input Context

Baseline flows proven in screenshots; this spec upgrades UX, code structure, and responsiveness.

Local JSON as API (reads/writes in app documents directory, seeded from assets) with simulated latency & errors for realism.

### R — Rules / Constraints

- **Feature-scoped GetX**: each module holds views/, controllers/, repositories/, services/, widgets/, bindings/, routes/
- **Thin UI → Fat repo/service**
- **Immutable UI states** (Idle/Loading/Ready/Empty/Error)
- **IMEI is the atomic unit of inventory**
- **A11y & Responsive** across mobile & web (keyboard-first on web)

### E — Expected Output (deliverables)

1. Full folder structure & conventions
2. Route map + bindings
3. Data models & JSON shapes
4. Workflows for Purchase, Sale, Stock, Reports, Exports
5. Theming + tokens + responsive primitives
6. Testing plan & sample code

### F — Flow of Tasks

1. Project scaffold & tokens
2. Core services (JSON DB, numbering, tax)
3. Masters
4. Purchases
5. Stock
6. Sales & Invoice
7. Reports/Exports
8. Users/Settings
9. QA & packaging

### R — Reference Voice/Style

Material 3, restrained red accent (#B00020), rounded 16, clear typography, empty-state help, micro-animations (200ms).

### A — Inputs Needed Later

Store profile (logo, GSTIN), invoice terms, default tax rates, numbering rule.

### M — Memory

This specification is maintained in `/docs/spec_v1.md` and iterated per release.

### E — Evaluate & Iterate

- Create invoice in ≤3 clicks
- Search ≤150ms on device
- Web keyboard coverage
- IMEI traceability 100%
- Exports accurate to ±0.01

---

## 1) Tech Stack

| Layer | Choice |
|-------|--------|
| UI | Flutter 3.x (Material 3), GetX (navigation, DI, state) |
| Local "API" | JSON files in application documents directory (seeded from assets/db_seed) |
| Packages | get, path_provider, uuid, intl, pdf, printing, excel |
| Testing | flutter_test, mocktail |
| Web renderer | CanvasKit |

---

## 2) Folder Structure (Feature-Scoped + Shared)

```
lib/
└─ app/
   ├─ core/                         # cross-cutting concerns
   │  ├─ config/                    # env, build flags
   │  ├─ theme/                     # tokens, ThemeData, extensions
   │  ├─ routing/                   # global route registry
   │  ├─ state/                     # UiState<T>, Paged<T>
   │  ├─ utils/                     # formatters, validators, guards
   │  ├─ widgets/                   # shared reusable widgets (non-feature)
   │  └─ services/                  # app-wide GetxServices
   │     ├─ json_db_service.dart    # local JSON read/write with latency
   │     ├─ number_series_service.dart
   │     ├─ tax_service.dart
   │     └─ auth_service.dart       # roles, session (mock for local)
   ├─ data/
   │  └─ models/                    # pure data models + (de)serializers
   └─ modules/
      ├─ dashboard/
      │  ├─ bindings/
      │  ├─ controllers/
      │  ├─ repositories/
      │  ├─ services/               # feature-only helpers (optional)
      │  ├─ views/                  # screens & subviews
      │  ├─ widgets/                # feature-specific widgets
      │  └─ routes.dart
      ├─ stock/
      ├─ sales/
      ├─ purchases/
      ├─ reports/
      ├─ masters/
      │   ├─ brands/
      │   ├─ models/
      │   ├─ vendors/
      │   └─ customers/
      ├─ users_roles/
      └─ settings/
```

---

## 3) Core Data Models

### Brand
```json
{
  "id": "brand_1",
  "name": "Apple"
}
```

### Model
```json
{
  "id": "model_1",
  "brandId": "brand_1",
  "name": "iPhone 15 Pro"
}
```

### Vendor
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

### Customer
```json
{
  "id": "cust_1",
  "name": "John Doe",
  "phone": "9876543210",
  "email": "john@example.com",
  "address": "123 Main St",
  "gst": null
}
```

### ProductUnit (IMEI-based inventory)
```json
{
  "id": "unit_1",
  "brandId": "brand_1",
  "modelId": "model_1",
  "imei": "123456789012345",
  "color": "Space Gray",
  "ram": "8GB",
  "rom": "256GB",
  "hsn": "85171290",
  "purchasePrice": 95000,
  "sellPrice": 110000,
  "status": "in_stock",
  "purchaseId": "pur_1",
  "saleId": null
}
```

### Purchase
```json
{
  "id": "pur_1",
  "vendorId": "ven_1",
  "vendorInvoiceNo": "VI-2025-001",
  "date": "2025-11-01T10:00:00Z",
  "total": 285000,
  "notes": "Bulk order"
}
```

### Sale
```json
{
  "id": "sale_1",
  "customerId": "cust_1",
  "invoiceNo": "INV-20251101-001",
  "date": "2025-11-01T15:30:00Z",
  "taxable": 110000,
  "cgst": 9900,
  "sgst": 9900,
  "igst": 0,
  "total": 129800,
  "payMode": "cash",
  "emi": null,
  "terms": "No returns after 7 days"
}
```

---

## 4) State Management Pattern

```dart
sealed class UiState<T> { const UiState(); }
class Idle<T>    extends UiState<T> { const Idle(); }
class Loading<T> extends UiState<T> { const Loading(); }
class Ready<T>   extends UiState<T> { final T data; const Ready(this.data); }
class Empty<T>   extends UiState<T> { const Empty(); }
class ErrorState<T> extends UiState<T> { final String message; const ErrorState(this.message); }
```

Controllers expose `Rx<UiState<…>>` instead of multiple booleans.

---

## 5) Key Workflows

### Purchase Flow
1. Select vendor (with inline add option)
2. Enter vendor invoice number and date
3. Bulk IMEI paste/scan
4. Auto-fill model/brand from IMEI database
5. Set purchase price and target sell price per unit
6. Live summary (count, total)
7. Save as draft or submit
8. Writes to: purchases.json, product_units.json (status: in_stock)

### Sales & Invoice Flow
1. Select customer (with inline add option)
2. Enter/scan IMEI (validates availability)
3. Optional price override
4. Select payment mode (cash/card/UPI/EMI)
5. EMI details if applicable
6. Tax calculation (CGST/SGST or IGST based on state)
7. Preview invoice
8. Confirm (reserves invoice number)
9. Generate PDF/Print/Share
10. Writes to: sales.json, updates product_units.json (status: sold)

### Stock Management
1. Search by IMEI, brand, model
2. Filter by status (in_stock, sold, returned)
3. Filter by date range
4. Multi-select for bulk operations
5. Export to Excel
6. Mark as returned (reverses sale link)

### Reports & Exports
- **Buy Report**: Purchase history with vendor details
- **Sell Report**: Sales history with customer details
- **Stock Report**: Current inventory status
- **GST Report**: Tax calculations for filing
- Export formats: Excel (.xlsx), PDF
- File naming: `GST_2025-11-01_to_2025-11-05.xlsx`

---

## 6) Testing Strategy

### Unit Tests
- TaxService: GST calculations (CGST/SGST vs IGST)
- NumberSeriesService: Invoice numbering sequence
- ImeiValidator: Format validation
- Repositories: CRUD operations with temp JSON files

### Widget Tests
- Vendor list → add → delete flow
- Purchase bulk IMEI form
- Sales invoice preview

### Integration Tests
- Complete purchase flow
- Complete sales flow
- Report generation

---

## 7) Theme & Design Tokens

```dart
// Spacing: 8-point grid
const spacing4 = 4.0;
const spacing8 = 8.0;
const spacing16 = 16.0;
const spacing24 = 24.0;
const spacing32 = 32.0;

// Border Radius
const radius8 = 8.0;
const radius16 = 16.0;
const radius24 = 24.0;

// Animation Durations
const duration120ms = Duration(milliseconds: 120);
const duration200ms = Duration(milliseconds: 200);
const duration300ms = Duration(milliseconds: 300);

// Colors
const seedColor = Color(0xFFB00020); // Red accent
```

**Material 3** with restrained red accent, rounded corners (16), clear typography, empty-state help, micro-animations (200ms).

---

## 8) Responsiveness

### Breakpoints
- Mobile: ≤600dp (bottom FAB, modal drawer)
- Tablet: 600-1024dp (two-column content)
- Desktop: ≥1024dp (persistent sidebar, data tables)

### Web Enhancements
- Keyboard shortcuts (Ctrl/Cmd+K for command palette)
- Tab navigation with focus rings
- Enter to submit forms
- Arrow keys for list navigation

---

## 9) Release Checklist

- [ ] All core services implemented
- [ ] All master data modules complete (Brands, Models, Vendors, Customers)
- [ ] Purchase flow end-to-end tested
- [ ] Sales & invoice generation working
- [ ] Stock management functional
- [ ] Reports with Excel/PDF export
- [ ] Users & roles module
- [ ] Settings module
- [ ] Responsive on mobile and web
- [ ] Unit tests passing
- [ ] Widget tests passing
- [ ] Documentation updated
- [ ] Seed data populated

---

## Version History

- **v1.0** (2025-11-07): Initial specification
