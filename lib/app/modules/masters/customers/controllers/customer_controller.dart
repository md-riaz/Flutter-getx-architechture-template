import 'package:get/get.dart';
import '../../../../core/state/ui_state.dart';
import '../../../../data/models/customer.dart';
import '../repositories/customer_repo.dart';

/// Customer controller
class CustomerController extends GetxController {
  final CustomerRepo _repo;

  CustomerController(this._repo);

  final state = const Idle<List<Customer>>().obs;
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

  Future<void> save(Customer customer) async {
    try {
      await _repo.upsert(customer);
      await fetch();
      Get.snackbar('Success', 'Customer saved successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save customer: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.remove(id);
      await fetch();
      Get.snackbar('Success', 'Customer deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete customer: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void search(String value) {
    query.value = value;
  }
}
