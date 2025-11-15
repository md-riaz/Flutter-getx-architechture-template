import 'package:get/get.dart';
import '../controllers/examples_controller.dart';

class ExamplesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamplesController>(() => ExamplesController());
  }
}
