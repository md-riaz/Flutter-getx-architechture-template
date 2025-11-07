import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../data/models/phone_model.dart';
import '../../../../data/models/brand.dart';
import '../repositories/phone_model_repo.dart';

/// Phone model controller
class PhoneModelController extends GetxController {
  final PhoneModelRepo _repo;

  PhoneModelController(this._repo);

  final state = const Idle<List<PhoneModel>>().obs;
  final query = ''.obs;
  final selectedBrandId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    debounce(query, (_) => fetch(), time: const Duration(milliseconds: 250));
    ever(selectedBrandId, (_) => fetch());
    fetch();
  }

  Future<void> fetch() async {
    state.value = const Loading();
    try {
      final data = await _repo.list(
        query: query.value,
        brandId: selectedBrandId.value,
      );
      state.value = data.isEmpty ? const Empty() : Ready(data);
    } catch (e) {
      state.value = ErrorState(e.toString());
    }
  }

  Future<void> save(PhoneModel model) async {
    try {
      await _repo.upsert(model);
      await fetch();
      Get.snackbar('Success', 'Model saved successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save model: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.remove(id);
      await fetch();
      Get.snackbar('Success', 'Model deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete model: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void search(String value) {
    query.value = value;
  }

  void filterByBrand(String? brandId) {
    selectedBrandId.value = brandId;
  }
}
