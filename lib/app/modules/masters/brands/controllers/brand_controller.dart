import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../data/models/brand.dart';
import '../repositories/brand_repo.dart';

/// Brand controller
class BrandController extends GetxController {
  final BrandRepo _repo;

  BrandController(this._repo);

  final state = const Idle<List<Brand>>().obs;
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

  Future<void> save(Brand brand) async {
    try {
      await _repo.upsert(brand);
      await fetch();
      Get.snackbar('Success', 'Brand saved successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save brand: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.remove(id);
      await fetch();
      Get.snackbar('Success', 'Brand deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete brand: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void search(String value) {
    query.value = value;
  }
}
