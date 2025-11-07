import 'package:get/get.dart';
import '../../masters/vendors/bindings/vendor_binding.dart';
import '../../masters/brands/bindings/brand_binding.dart';
import '../../masters/customers/bindings/customer_binding.dart';
import '../../masters/models/bindings/phone_model_binding.dart';
import '../../stock/bindings/stock_binding.dart';

/// Dashboard binding
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Preload module bindings
    VendorBinding().dependencies();
    BrandBinding().dependencies();
    CustomerBinding().dependencies();
    PhoneModelBinding().dependencies();
    StockBinding().dependencies();
  }
}
