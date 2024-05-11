import 'package:get/get.dart';

import '../controllers/online_controller.dart';

class OnlineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineController>(
      () => OnlineController(),
    );
  }
}
