import 'package:get/get.dart';
import '../../../core/state/ui_state.dart';
import '../../../data/models/product_unit.dart';
import '../repositories/stock_repo.dart';

/// Stock controller
class StockController extends GetxController {
  final StockRepo _repo;

  StockController(this._repo);

  final state = const Idle<List<ProductUnit>>().obs;
  final statistics = Rx<Map<String, int>>({});
  final query = ''.obs;
  final selectedStatus = Rxn<ProductStatus>();

  @override
  void onInit() {
    super.onInit();
    debounce(query, (_) => fetch(), time: const Duration(milliseconds: 250));
    ever(selectedStatus, (_) => fetch());
    fetch();
    fetchStatistics();
  }

  Future<void> fetch() async {
    state.value = const Loading();
    try {
      final data = await _repo.list(
        query: query.value,
        status: selectedStatus.value,
      );
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

  void filterByStatus(ProductStatus? status) {
    selectedStatus.value = status;
  }

  Future<void> markAsReturned(String id) async {
    try {
      final units = state.value is Ready<List<ProductUnit>>
          ? (state.value as Ready<List<ProductUnit>>).data
          : <ProductUnit>[];
      
      final unit = units.firstWhere((u) => u.id == id);
      final updated = unit.copyWith(
        status: ProductStatus.returned,
        saleId: null,
      );
      
      await _repo.update(updated);
      await fetch();
      await fetchStatistics();
      
      Get.snackbar('Success', 'Unit marked as returned',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update unit: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
