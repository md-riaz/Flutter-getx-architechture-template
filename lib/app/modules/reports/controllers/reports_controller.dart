import 'package:get/get.dart';

/// Reports controller
class ReportsController extends GetxController {
  final selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
