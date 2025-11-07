import 'package:get/get.dart';
import '../../masters/vendors/bindings/vendor_binding.dart';

/// Dashboard binding
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Preload vendor binding when dashboard is accessed
    VendorBinding().dependencies();
  }
}
