import 'dart:io';

import 'package:arsip_mobile/app/data/models/ArchiveWithCategory.dart';
import 'package:arsip_mobile/app/data/models/category_model.dart';
import 'package:arsip_mobile/app/data/services/db_service.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ArchiveController extends GetxController {
  final dbService = DBService();

  // daftar arsip surat
  var archives = <ArchiveWithCategory>[].obs;
  var category = <CategoryModel>[].obs;
  var selectedCategory = ''.obs;

  // untuk pencarian
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadArchives();
    loadCategories();
  }

  Future<void> loadArchives() async {
    final result = await dbService.getArchivesWithCategory();
    print(result.first);
    archives.assignAll(
      result.map((e) => ArchiveWithCategory.fromMap(e)).toList(),
    );
  }

  Future<void> loadCategories() async {
    final db = await DBService().database;
    final maps = await db.query('categories');
    category.value = maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  // fungsi cari surat
  List<ArchiveWithCategory> get filteredArchives {
    List<ArchiveWithCategory> list = archives;

    // filter by search query
    if (searchQuery.isNotEmpty) {
      list =
          list
              .where(
                (a) => a.nomorSurat.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList();
    }

    // filter by category
    if (selectedCategory.isNotEmpty) {
      list =
          list
              .where((a) => a.kategoriId.toString() == selectedCategory.value)
              .toList();
    }

    return list;
  }

  Future<void> deleteArchive(String archiveID) async {
    final db = await dbService.database;
    await db.delete('archives', where: 'id = ?', whereArgs: [archiveID]);
    loadArchives();
  }

  void downloadArchive(String archive) {
    // TODO: implementasi unduh PDF (misalnya pakai open_filex atau dio)
  }

  void viewArchive(String archive) {
    // TODO: buka halaman detail PDF viewer (pakai flutter_pdfview)
  }
}
