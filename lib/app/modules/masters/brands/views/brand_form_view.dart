import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../data/models/brand.dart';
import '../controllers/brand_controller.dart';

/// Brand form view
class BrandFormView extends GetView<BrandController> {
  final String? brandId;

  const BrandFormView({super.key, this.brandId});

  @override
  Widget build(BuildContext context) {
    return _BrandFormContent(brandId: brandId);
  }
}

class _BrandFormContent extends StatefulWidget {
  final String? brandId;

  const _BrandFormContent({this.brandId});

  @override
  State<_BrandFormContent> createState() => _BrandFormContentState();
}

class _BrandFormContentState extends State<_BrandFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = true;
  Brand? _existingBrand;

  @override
  void initState() {
    super.initState();
    _loadBrand();
  }

  Future<void> _loadBrand() async {
    if (widget.brandId != null) {
      final controller = Get.find<BrandController>();
      final state = controller.state.value;
      if (state is Ready<List<Brand>>) {
        try {
          _existingBrand = state.data.firstWhere((b) => b.id == widget.brandId);
          _nameController.text = _existingBrand!.name;
        } catch (e) {
          // Brand not found
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandId == null ? 'Add Brand' : 'Edit Brand'),
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
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Brand Name *',
                        hintText: 'Enter brand name',
                        prefixIcon: Icon(Icons.branding_watermark),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Brand name is required';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: AppTokens.spacing32),
                    FilledButton.icon(
                      onPressed: _saveBrand,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Brand'),
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

  Future<void> _saveBrand() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final brand = Brand(
      id: _existingBrand?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
    );

    final controller = Get.find<BrandController>();
    await controller.save(brand);
    Get.back();
  }
}
