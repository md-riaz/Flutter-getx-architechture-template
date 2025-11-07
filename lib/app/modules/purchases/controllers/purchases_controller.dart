import 'package:get/get.dart';
import '../../../core/state/ui_state.dart';
import '../../../data/models/purchase.dart';
import '../repositories/purchases_repo.dart';

/// Purchases controller
class PurchasesController extends GetxController {
  final PurchasesRepo _repo;

  PurchasesController(this._repo);

  final state = const Idle<List<Purchase>>().obs;
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

  Future<void> refresh() async {
    await fetch();
    await fetchStatistics();
  }
}
