import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../data/models/customer.dart';
import '../controllers/customer_controller.dart';

/// Customer form view
class CustomerFormView extends GetView<CustomerController> {
  final String? customerId;

  const CustomerFormView({super.key, this.customerId});

  @override
  Widget build(BuildContext context) {
    return _CustomerFormContent(customerId: customerId);
  }
}

class _CustomerFormContent extends StatefulWidget {
  final String? customerId;

  const _CustomerFormContent({this.customerId});

  @override
  State<_CustomerFormContent> createState() => _CustomerFormContentState();
}

class _CustomerFormContentState extends State<_CustomerFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();

  bool _isLoading = true;
  Customer? _existingCustomer;

  @override
  void initState() {
    super.initState();
    _loadCustomer();
  }

  Future<void> _loadCustomer() async {
    if (widget.customerId != null) {
      final controller = Get.find<CustomerController>();
      final state = controller.state.value;
      if (state is Ready<List<Customer>>) {
        try {
          _existingCustomer =
              state.data.firstWhere((c) => c.id == widget.customerId);
          _nameController.text = _existingCustomer!.name;
          _phoneController.text = _existingCustomer!.phone ?? '';
          _emailController.text = _existingCustomer!.email ?? '';
          _addressController.text = _existingCustomer!.address ?? '';
          _gstController.text = _existingCustomer!.gst ?? '';
        } catch (e) {
          // Customer not found
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.customerId == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTokens.spacing16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Name field (required)
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                        hintText: 'Enter customer name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: AppTokens.spacing16),

                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter phone number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppTokens.spacing16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter email address',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!GetUtils.isEmail(value)) {
                            return 'Enter a valid email';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTokens.spacing16),

                    // Address field
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: AppTokens.spacing16),

                    // GST field (optional for customers)
                    TextFormField(
                      controller: _gstController,
                      decoration: const InputDecoration(
                        labelText: 'GST Number (Optional)',
                        hintText: 'Enter GST number if business customer',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: AppTokens.spacing32),

                    // Save button
                    FilledButton.icon(
                      onPressed: _saveCustomer,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Customer'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTokens.spacing16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final customer = Customer(
      id: _existingCustomer?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      gst: _gstController.text.trim().isEmpty
          ? null
          : _gstController.text.trim(),
    );

    final controller = Get.find<CustomerController>();
    await controller.save(customer);
    Get.back();
  }
}
