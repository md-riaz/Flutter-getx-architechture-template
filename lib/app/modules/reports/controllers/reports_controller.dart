import 'package:get/get.dart';
import '../repositories/reports_repo.dart';

/// Reports controller
class ReportsController extends GetxController {
  final ReportsRepo _repo;

  ReportsController(this._repo);

  final selectedTab = 0.obs;
  final purchaseData = Rx<Map<String, dynamic>>({});
  final salesData = Rx<Map<String, dynamic>>({});
  final stockData = Rx<Map<String, dynamic>>({});
  final gstData = Rx<Map<String, dynamic>>({});

  final isLoading = false.obs;

  // Date range for filtering
  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    super.onInit();
    loadAllReports();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<void> loadAllReports() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadPurchaseReport(),
        loadSalesReport(),
        loadStockReport(),
        loadGSTReport(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPurchaseReport() async {
    try {
      purchaseData.value = await _repo.getPurchaseReport(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load purchase report: $e');
    }
  }

  Future<void> loadSalesReport() async {
    try {
      salesData.value = await _repo.getSalesReport(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sales report: $e');
    }
  }

  Future<void> loadStockReport() async {
    try {
      stockData.value = await _repo.getStockReport();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load stock report: $e');
    }
  }

  Future<void> loadGSTReport() async {
    try {
      gstData.value = await _repo.getGSTReport(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load GST report: $e');
    }
  }

  Future<void> setDateRange(DateTime? start, DateTime? end) async {
    startDate = start;
    endDate = end;
    await loadAllReports();
  }

  void clearDateRange() {
    startDate = null;
    endDate = null;
    loadAllReports();
  }
}

