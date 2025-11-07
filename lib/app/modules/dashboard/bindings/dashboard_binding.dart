import 'package:get/get.dart';
import '../../masters/vendors/bindings/vendor_binding.dart';
import '../../masters/brands/bindings/brand_binding.dart';

/// Dashboard binding
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Preload module bindings
    VendorBinding().dependencies();
    BrandBinding().dependencies();
  }
}
