import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/json_db_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/models/purchase.dart';
import '../../../data/models/product_unit.dart';
import '../../../data/models/vendor.dart';
import '../../../data/models/brand.dart';
import '../../../data/models/phone_model.dart';
import '../repositories/purchases_repo.dart';

/// Purchase creation view with bulk IMEI entry
class PurchaseCreateView extends StatefulWidget {
  const PurchaseCreateView({super.key});

  @override
  State<PurchaseCreateView> createState() => _PurchaseCreateViewState();
}

class _PurchaseCreateViewState extends State<PurchaseCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceController = TextEditingController();
  final _notesController = TextEditingController();
  final _imeiController = TextEditingController();

  Vendor? _selectedVendor;
  Brand? _selectedBrand;
  PhoneModel? _selectedModel;
  DateTime _selectedDate = DateTime.now();

  final List<_IMEIEntry> _imeiEntries = [];
  double _totalAmount = 0.0;

  List<Vendor> _vendors = [];
  List<Brand> _brands = [];
  List<PhoneModel> _models = [];
  List<PhoneModel> _filteredModels = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = Get.find<JsonDbService>();

    // Load vendors
    final vendorsRaw = await db.readList('vendors');
    _vendors = vendorsRaw
        .map((e) => Vendor.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Load brands
    final brandsRaw = await db.readList('brands');
    _brands = brandsRaw
        .map((e) => Brand.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Load models
    final modelsRaw = await db.readList('models');
    _models = modelsRaw
        .map((e) => PhoneModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    setState(() {});
  }

  void _updateFilteredModels() {
    if (_selectedBrand != null) {
      _filteredModels =
          _models.where((m) => m.brandId == _selectedBrand!.id).toList();
    } else {
      _filteredModels = [];
    }
    setState(() {});
  }

  void _addIMEI() {
    if (_imeiController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter IMEI number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (_selectedBrand == null || _selectedModel == null) {
      Get.snackbar('Error', 'Please select brand and model',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check for duplicate IMEI
    if (_imeiEntries.any((e) => e.imei == _imeiController.text)) {
      Get.snackbar('Error', 'IMEI already added',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _imeiEntries.add(_IMEIEntry(
        imei: _imeiController.text,
        brand: _selectedBrand!,
        model: _selectedModel!,
        purchasePrice: 0.0,
        sellPrice: 0.0,
        color: '',
      ));
      _imeiController.clear();
      _calculateTotal();
    });
  }

  void _removeIMEI(int index) {
    setState(() {
      _imeiEntries.removeAt(index);
      _calculateTotal();
    });
  }

  void _updateIMEIEntry(int index, {double? purchase, double? sell, String? color}) {
    setState(() {
      if (purchase != null) _imeiEntries[index].purchasePrice = purchase;
      if (sell != null) _imeiEntries[index].sellPrice = sell;
      if (color != null) _imeiEntries[index].color = color;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalAmount = _imeiEntries.fold(0.0, (sum, e) => sum + e.purchasePrice);
  }

  Future<void> _submitPurchase() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVendor == null) {
      Get.snackbar('Error', 'Please select a vendor',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (_imeiEntries.isEmpty) {
      Get.snackbar('Error', 'Please add at least one IMEI',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validate all entries have prices
    if (_imeiEntries.any((e) => e.purchasePrice <= 0)) {
      Get.snackbar('Error', 'All items must have purchase price',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uuid = const Uuid();
      final purchaseId = 'purch_${uuid.v4().substring(0, 8)}';

      // Create purchase
      final purchase = Purchase(
        id: purchaseId,
        vendorId: _selectedVendor!.id,
        vendorInvoiceNo: _invoiceController.text,
        date: _selectedDate,
        total: _totalAmount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      // Create product units
      final units = _imeiEntries.map((entry) {
        return ProductUnit(
          id: 'unit_${uuid.v4().substring(0, 8)}',
          brandId: entry.brand.id,
          modelId: entry.model.id,
          imei: entry.imei,
          color: entry.color.isEmpty ? null : entry.color,
          ram: null,
          rom: null,
          hsn: null,
          purchasePrice: entry.purchasePrice,
          sellPrice: entry.sellPrice,
          status: ProductStatus.in_stock,
          purchaseId: purchaseId,
          saleId: null,
        );
      }).toList();

      // Save
      final repo = Get.find<PurchasesRepo>();
      await repo.create(purchase, units);

      Get.back();
      Get.snackbar(
        'Success',
        'Purchase created with ${units.length} items',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create purchase: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Purchase'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spacing16),
          children: [
            // Vendor selection
            DropdownButtonFormField<Vendor>(
              value: _selectedVendor,
              decoration: const InputDecoration(
                labelText: 'Vendor *',
                prefixIcon: Icon(Icons.business),
              ),
              items: _vendors.map((vendor) {
                return DropdownMenuItem(
                  value: vendor,
                  child: Text(vendor.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedVendor = value),
              validator: (value) =>
                  value == null ? 'Please select a vendor' : null,
            ),
            const SizedBox(height: AppTokens.spacing16),

            // Invoice number
            TextFormField(
              controller: _invoiceController,
              decoration: const InputDecoration(
                labelText: 'Vendor Invoice Number *',
                prefixIcon: Icon(Icons.receipt),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTokens.spacing16),

            // Date picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}'),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            const SizedBox(height: AppTokens.spacing24),

            // IMEI Entry Section
            Text('Add Items',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppTokens.spacing16),

            // Brand selection
            DropdownButtonFormField<Brand>(
              value: _selectedBrand,
              decoration: const InputDecoration(
                labelText: 'Brand',
                prefixIcon: Icon(Icons.branding_watermark),
              ),
              items: _brands.map((brand) {
                return DropdownMenuItem(
                  value: brand,
                  child: Text(brand.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value;
                  _selectedModel = null;
                });
                _updateFilteredModels();
              },
            ),
            const SizedBox(height: AppTokens.spacing16),

            // Model selection
            DropdownButtonFormField<PhoneModel>(
              value: _selectedModel,
              decoration: const InputDecoration(
                labelText: 'Model',
                prefixIcon: Icon(Icons.phone_android),
              ),
              items: _filteredModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedModel = value),
            ),
            const SizedBox(height: AppTokens.spacing16),

            // IMEI input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imeiController,
                    decoration: const InputDecoration(
                      labelText: 'IMEI Number',
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                    maxLength: 15,
                  ),
                ),
                const SizedBox(width: AppTokens.spacing8),
                FilledButton.icon(
                  onPressed: _addIMEI,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.spacing24),

            // IMEI entries list
            if (_imeiEntries.isNotEmpty) ...[
              Text('Items (${_imeiEntries.length})',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppTokens.spacing8),
              ..._imeiEntries.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTokens.spacing8),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTokens.spacing12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.brand.name} ${item.model.name}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeIMEI(index),
                            ),
                          ],
                        ),
                        Text('IMEI: ${item.imei}'),
                        const SizedBox(height: AppTokens.spacing8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: item.color,
                                decoration: const InputDecoration(
                                  labelText: 'Color',
                                  isDense: true,
                                ),
                                onChanged: (value) =>
                                    _updateIMEIEntry(index, color: value),
                              ),
                            ),
                            const SizedBox(width: AppTokens.spacing8),
                            Expanded(
                              child: TextFormField(
                                initialValue: item.purchasePrice == 0
                                    ? ''
                                    : item.purchasePrice.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Purchase Price *',
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _updateIMEIEntry(index,
                                    purchase: double.tryParse(value) ?? 0),
                              ),
                            ),
                            const SizedBox(width: AppTokens.spacing8),
                            Expanded(
                              child: TextFormField(
                                initialValue: item.sellPrice == 0
                                    ? ''
                                    : item.sellPrice.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Sell Price',
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _updateIMEIEntry(index,
                                    sell: double.tryParse(value) ?? 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppTokens.spacing16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(AppTokens.spacing16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '₹${NumberFormat('#,##0.00').format(_totalAmount)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppTokens.spacing16),

            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTokens.spacing32),

            // Submit button
            FilledButton(
              onPressed: _isLoading ? null : _submitPurchase,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Purchase'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    _notesController.dispose();
    _imeiController.dispose();
    super.dispose();
  }
}

class _IMEIEntry {
  final String imei;
  final Brand brand;
  final PhoneModel model;
  double purchasePrice;
  double sellPrice;
  String color;

  _IMEIEntry({
    required this.imei,
    required this.brand,
    required this.model,
    required this.purchasePrice,
    required this.sellPrice,
    required this.color,
  });
}
