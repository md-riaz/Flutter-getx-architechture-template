import 'package:get/get.dart';
import '../../../core/state/ui_state.dart';
import '../../../data/models/sale.dart';
import '../repositories/sales_repo.dart';

/// Sales controller
class SalesController extends GetxController {
  final SalesRepo _repo;

  SalesController(this._repo);

  final state = const Idle<List<Sale>>().obs;
  final statistics = Rx<Map<String, dynamic>>({});
  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(query, (_) => fetch(), time: const Duration(milliseconds: 250));
    fetch();
    fetchStatistics();
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

  Future<void> fetchStatistics() async {
    try {
      statistics.value = await _repo.getStatistics();
    } catch (e) {
      // Silently fail for statistics
    }
  }

  void search(String value) {
    query.value = value;
  }

  Future<void> createSale(Sale sale) async {
    try {
      await _repo.create(sale);
      await fetch();
      await fetchStatistics();
      Get.snackbar('Success', 'Sale created successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create sale: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
