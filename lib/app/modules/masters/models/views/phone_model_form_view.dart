import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../data/models/phone_model.dart';
import '../../../../data/models/brand.dart';
import '../../../masters/brands/controllers/brand_controller.dart';
import '../controllers/phone_model_controller.dart';

/// Phone model form view
class PhoneModelFormView extends StatelessWidget {
  final String? modelId;

  const PhoneModelFormView({super.key, this.modelId});

  @override
  Widget build(BuildContext context) {
    return _PhoneModelFormContent(modelId: modelId);
  }
}

class _PhoneModelFormContent extends StatefulWidget {
  final String? modelId;

  const _PhoneModelFormContent({this.modelId});

  @override
  State<_PhoneModelFormContent> createState() => _PhoneModelFormContentState();
}

class _PhoneModelFormContentState extends State<_PhoneModelFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedBrandId;
  bool _isLoading = true;
  PhoneModel? _existingModel;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    if (widget.modelId != null) {
      final controller = Get.find<PhoneModelController>();
      final state = controller.state.value;
      if (state is Ready<List<PhoneModel>>) {
        try {
          _existingModel = state.data.firstWhere((m) => m.id == widget.modelId);
          _nameController.text = _existingModel!.name;
          _selectedBrandId = _existingModel!.brandId;
        } catch (e) {
          // Model not found
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
    final brandController = Get.find<BrandController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modelId == null ? 'Add Phone Model' : 'Edit Phone Model'),
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
                    // Brand dropdown
                    Obx(() {
                      final brandState = brandController.state.value;
                      if (brandState is Ready<List<Brand>>) {
                        final brands = brandState.data;
                        return DropdownButtonFormField<String>(
                          value: _selectedBrandId,
                          decoration: const InputDecoration(
                            labelText: 'Brand *',
                            prefixIcon: Icon(Icons.branding_watermark),
                          ),
                          items: brands.map((brand) {
                            return DropdownMenuItem(
                              value: brand.id,
                              child: Text(brand.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBrandId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a brand';
                            }
                            return null;
                          },
                        );
                      }
                      return const CircularProgressIndicator();
                    }),
                    const SizedBox(height: AppTokens.spacing16),

                    // Model name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Model Name *',
                        hintText: 'Enter model name',
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Model name is required';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: AppTokens.spacing32),

                    // Save button
                    FilledButton.icon(
                      onPressed: _saveModel,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Model'),
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

  Future<void> _saveModel() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final model = PhoneModel(
      id: _existingModel?.id ?? const Uuid().v4(),
      brandId: _selectedBrandId!,
      name: _nameController.text.trim(),
    );

    final controller = Get.find<PhoneModelController>();
    await controller.save(model);
    Get.back();
  }
}
