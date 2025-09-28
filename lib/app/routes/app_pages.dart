import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/archive/bindings/archive_binding.dart';
import '../modules/archive/views/archive_view.dart';
import '../modules/archive_detail/bindings/archive_detail_binding.dart';
import '../modules/archive_detail/views/archive_detail_view.dart';
import '../modules/archive_form/bindings/archive_form_binding.dart';
import '../modules/archive_form/views/archive_form_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/category_form/bindings/category_form_binding.dart';
import '../modules/category_form/views/category_form_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ARCHIVE_FORM,
      page: () => const ArchiveFormView(),
      binding: ArchiveFormBinding(),
    ),
    GetPage(
      name: _Paths.ARCHIVE_DETAIL,
      page: () => const ArchiveDetailView(),
      binding: ArchiveDetailBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY_FORM,
      page: () => const CategoryFormView(),
      binding: CategoryFormBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.ARCHIVE,
      page: () => const ArchiveView(),
      binding: ArchiveBinding(),
    ),
  ];
}
