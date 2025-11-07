import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/json_db_service.dart';
import '../../../core/services/tax_service.dart';
import '../../../core/services/number_series_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../data/models/sale.dart';
import '../../../data/models/customer.dart';
import '../../../data/models/product_unit.dart';
import '../repositories/sales_repo.dart';

/// Sale creation view with IMEI selection
class SaleCreateView extends StatefulWidget {
  const SaleCreateView({super.key});

  @override
  State<SaleCreateView> createState() => _SaleCreateViewState();
}

class _SaleCreateViewState extends State<SaleCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _imeiController = TextEditingController();

  Customer? _selectedCustomer;
  DateTime _selectedDate = DateTime.now();
  String _paymentMode = 'cash';
  bool _intraState = true; // For GST calculation

  final List<ProductUnit> _selectedUnits = [];
  List<Customer> _customers = [];
  List<ProductUnit> _availableUnits = [];

  double _taxableAmount = 0.0;
  double _cgst = 0.0;
  double _sgst = 0.0;
  double _igst = 0.0;
  double _totalAmount = 0.0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = Get.find<JsonDbService>();

    // Load customers
    final customersRaw = await db.readList('customers');
    _customers = customersRaw
        .map((e) => Customer.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Load available product units (in_stock only)
    final unitsRaw = await db.readList('product_units');
    _availableUnits = unitsRaw
        .map((e) => ProductUnit.fromJson(Map<String, dynamic>.from(e)))
        .where((u) => u.status == ProductStatus.in_stock)
        .toList();

    setState(() {});
  }

  void _addIMEI() {
    final imei = _imeiController.text.trim();
    if (imei.isEmpty) {
      Get.snackbar('Error', 'Please enter IMEI number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Find unit by IMEI
    final unit = _availableUnits.firstWhereOrNull((u) => u.imei == imei);
    if (unit == null) {
      Get.snackbar('Error', 'IMEI not found or already sold',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check if already added
    if (_selectedUnits.any((u) => u.imei == imei)) {
      Get.snackbar('Error', 'IMEI already added to sale',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _selectedUnits.add(unit);
      _imeiController.clear();
      _calculateTotal();
    });
  }

  void _removeUnit(int index) {
    setState(() {
      _selectedUnits.removeAt(index);
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    // Calculate taxable amount
    _taxableAmount = _selectedUnits.fold(0.0, (sum, u) => sum + u.sellPrice);

    // Calculate GST (assuming 18% total)
    final taxService = Get.find<TaxService>();
    final taxRate = 0.18;

    if (_intraState) {
      // Intra-state: CGST + SGST
      final tax = taxService.calculateIntraStateTax(_taxableAmount, taxRate);
      _cgst = tax['cgst']!;
      _sgst = tax['sgst']!;
      _igst = 0.0;
    } else {
      // Inter-state: IGST
      _igst = taxService.calculateInterStateTax(_taxableAmount, taxRate);
      _cgst = 0.0;
      _sgst = 0.0;
    }

    _totalAmount = _taxableAmount + _cgst + _sgst + _igst;
  }

  Future<void> _submitSale() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomer == null) {
      Get.snackbar('Error', 'Please select a customer',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (_selectedUnits.isEmpty) {
      Get.snackbar('Error', 'Please add at least one item',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uuid = const Uuid();
      final saleId = 'sale_${uuid.v4().substring(0, 8)}';

      // Generate invoice number
      final numberService = Get.find<NumberSeriesService>();
      final invoiceNo = await numberService.next('invoice');

      // Create sale
      final sale = Sale(
        id: saleId,
        customerId: _selectedCustomer!.id,
        invoiceNo: invoiceNo,
        date: _selectedDate,
        taxable: _taxableAmount,
        cgst: _cgst,
        sgst: _sgst,
        igst: _igst,
        total: _totalAmount,
        payMode: _paymentMode,
      );

      // Get IMEIs
      final imeiList = _selectedUnits.map((u) => u.imei).toList();

      // Save with units update
      final repo = Get.find<SalesRepo>();
      await repo.createWithUnits(sale, imeiList);

      Get.back();
      Get.snackbar(
        'Success',
        'Sale created: $invoiceNo',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create sale: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTokens.spacing16),
          children: [
            // Customer selection
            DropdownButtonFormField<Customer>(
              value: _selectedCustomer,
              decoration: const InputDecoration(
                labelText: 'Customer *',
                prefixIcon: Icon(Icons.person),
              ),
              items: _customers.map((customer) {
                return DropdownMenuItem(
                  value: customer,
                  child: Text(customer.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCustomer = value),
              validator: (value) =>
                  value == null ? 'Please select a customer' : null,
            ),
            const SizedBox(height: AppTokens.spacing16),

            // Date picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}'),
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
            const SizedBox(height: AppTokens.spacing16),

            // Payment mode
            DropdownButtonFormField<String>(
              value: _paymentMode,
              decoration: const InputDecoration(
                labelText: 'Payment Mode',
                prefixIcon: Icon(Icons.payment),
              ),
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('Cash')),
                DropdownMenuItem(value: 'card', child: Text('Card')),
                DropdownMenuItem(value: 'upi', child: Text('UPI')),
                DropdownMenuItem(value: 'emi', child: Text('EMI')),
              ],
              onChanged: (value) =>
                  setState(() => _paymentMode = value ?? 'cash'),
            ),
            const SizedBox(height: AppTokens.spacing16),

            // Intra/Inter state toggle for GST
            SwitchListTile(
              title: const Text('Intra-State Transaction'),
              subtitle: Text(_intraState
                  ? 'CGST + SGST will be applied'
                  : 'IGST will be applied'),
              value: _intraState,
              onChanged: (value) {
                setState(() {
                  _intraState = value;
                  _calculateTotal();
                });
              },
            ),
            const SizedBox(height: AppTokens.spacing24),

            // Add IMEI Section
            Text('Add Items by IMEI',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppTokens.spacing16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imeiController,
                    decoration: const InputDecoration(
                      labelText: 'IMEI Number',
                      prefixIcon: Icon(Icons.qr_code),
                      hintText: 'Scan or enter IMEI',
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
            const SizedBox(height: AppTokens.spacing16),

            // Selected items
            if (_selectedUnits.isNotEmpty) ...[
              Text('Items (${_selectedUnits.length})',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppTokens.spacing8),
              ..._selectedUnits.asMap().entries.map((entry) {
                final index = entry.key;
                final unit = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTokens.spacing8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.phone_android),
                    ),
                    title: Text('IMEI: ${unit.imei}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (unit.color != null) Text('Color: ${unit.color}'),
                        Text(
                          'Price: ₹${NumberFormat('#,##0').format(unit.sellPrice)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeUnit(index),
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppTokens.spacing24),

              // Tax breakdown
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTokens.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bill Summary',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Divider(),
                      _buildSummaryRow('Taxable Amount',
                          '₹${NumberFormat('#,##0.00').format(_taxableAmount)}'),
                      if (_cgst > 0)
                        _buildSummaryRow(
                            'CGST', '₹${NumberFormat('#,##0.00').format(_cgst)}'),
                      if (_sgst > 0)
                        _buildSummaryRow(
                            'SGST', '₹${NumberFormat('#,##0.00').format(_sgst)}'),
                      if (_igst > 0)
                        _buildSummaryRow(
                            'IGST', '₹${NumberFormat('#,##0.00').format(_igst)}'),
                      const Divider(),
                      _buildSummaryRow(
                        'Total Amount',
                        '₹${NumberFormat('#,##0.00').format(_totalAmount)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppTokens.spacing32),

            // Submit button
            FilledButton(
              onPressed: _isLoading ? null : _submitSale,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Sale'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }
}
