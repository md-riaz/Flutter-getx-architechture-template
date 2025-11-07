import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../data/models/vendor.dart';
import '../controllers/vendor_controller.dart';

/// Vendor form view
/// Create or edit vendor
class VendorFormView extends GetView<VendorController> {
  final String? vendorId;

  const VendorFormView({super.key, this.vendorId});

  @override
  Widget build(BuildContext context) {
    return _VendorFormContent(vendorId: vendorId);
  }
}

class _VendorFormContent extends StatefulWidget {
  final String? vendorId;

  const _VendorFormContent({this.vendorId});

  @override
  State<_VendorFormContent> createState() => _VendorFormContentState();
}

class _VendorFormContentState extends State<_VendorFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gstController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = true;
  Vendor? _existingVendor;

  @override
  void initState() {
    super.initState();
    _loadVendor();
  }

  Future<void> _loadVendor() async {
    if (widget.vendorId != null) {
      final controller = Get.find<VendorController>();
      final state = controller.state.value;
      
      if (state is Ready<List<Vendor>>) {
        try {
          _existingVendor = state.data.firstWhere((v) => v.id == widget.vendorId);
          _nameController.text = _existingVendor!.name;
          _gstController.text = _existingVendor!.gst ?? '';
          _phoneController.text = _existingVendor!.phone ?? '';
          _emailController.text = _existingVendor!.email ?? '';
          _addressController.text = _existingVendor!.address ?? '';
        } catch (e) {
          // Vendor not found
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
    _gstController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vendorId == null ? 'Add Vendor' : 'Edit Vendor'),
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
                        hintText: 'Enter vendor name',
                        prefixIcon: Icon(Icons.business),
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

                    // GST field
                    TextFormField(
                      controller: _gstController,
                      decoration: const InputDecoration(
                        labelText: 'GST Number',
                        hintText: 'Enter GST number',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      textCapitalization: TextCapitalization.characters,
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
                    const SizedBox(height: AppTokens.spacing32),

                    // Save button
                    FilledButton.icon(
                      onPressed: _saveVendor,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Vendor'),
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

  Future<void> _saveVendor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vendor = Vendor(
      id: _existingVendor?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      gst: _gstController.text.trim().isEmpty ? null : _gstController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
    );

    final controller = Get.find<VendorController>();
    await controller.save(vendor);
    Get.back();
  }
}
