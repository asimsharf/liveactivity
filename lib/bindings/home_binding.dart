import 'package:get/get.dart';

import '../PollController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PollController>(
      () => PollController(),
    );
  }
}
