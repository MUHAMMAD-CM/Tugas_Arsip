import 'package:get/get.dart';

import '../controllers/archive_form_controller.dart';

class ArchiveFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArchiveFormController>(
      () => ArchiveFormController(),
    );
  }
}
