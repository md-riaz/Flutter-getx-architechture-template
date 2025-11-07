import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../data/models/vendor.dart';
import '../repositories/vendor_repo.dart';

/// Vendor controller
/// Manages vendor list state and operations
class VendorController extends GetxController {
  final VendorRepo _repo;

  VendorController(this._repo);

  // State
  final state = const Idle<List<Vendor>>().obs;
  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Debounce search query
    debounce(
      query,
      (_) => fetch(),
      time: const Duration(milliseconds: 250),
    );
    
    // Initial fetch
    fetch();
  }

  /// Fetch vendors from repository
  Future<void> fetch() async {
    state.value = const Loading();
    
    try {
      final data = await _repo.list(query: query.value);
      state.value = data.isEmpty ? const Empty() : Ready(data);
    } catch (e) {
      state.value = ErrorState(e.toString());
    }
  }

  /// Save (create or update) vendor
  Future<void> save(Vendor vendor) async {
    try {
      await _repo.upsert(vendor);
      await fetch();
      Get.snackbar(
        'Success',
        'Vendor saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save vendor: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Delete vendor
  Future<void> delete(String id) async {
    try {
      await _repo.remove(id);
      await fetch();
      Get.snackbar(
        'Success',
        'Vendor deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete vendor: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Set search query
  void search(String value) {
    query.value = value;
  }
}
