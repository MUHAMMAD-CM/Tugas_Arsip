import 'package:get/get.dart';

import '../controllers/archive_detail_controller.dart';

class ArchiveDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArchiveDetailController>(
      () => ArchiveDetailController(),
    );
  }
}
