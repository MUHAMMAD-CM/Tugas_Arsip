import 'dart:io';

import 'package:arsip_mobile/app/data/models/ArchiveWithCategory.dart';
import 'package:arsip_mobile/app/data/models/category_model.dart';
import 'package:arsip_mobile/app/data/services/db_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/models/archive_model.dart';

class HomeController extends GetxController {
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

  Future<String?> movePdfToDownload(String appFilePath, String fileName) async {
    final status = await Permission.storage.status;

    if (status.isDenied) {
      // minta permission
      final requestStatus = await Permission.manageExternalStorage.request();
      if (!requestStatus.isGranted) {
        Get.snackbar("Izin ditolak", "Tidak bisa menyimpan file tanpa izin");
        return null;
      }
    } else if (status.isPermanentlyDenied) {
      // arahkan user ke settings
      Get.snackbar(
        "Izin diperlukan",
        "Silakan aktifkan izin penyimpanan di pengaturan",
      );
      await openAppSettings();
      return null;
    }

    // jika sudah granted
    final downloadDir = Directory('/storage/emulated/0/Download');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final newPath = '${downloadDir.path}/$fileName.pdf';
    final file = File(appFilePath);

    if (!file.existsSync()) {
      Get.snackbar("Error", "File sumber tidak ditemukan");
      return null;
    }

    final newFile = await file.copy(newPath);
    Get.snackbar("Sukses", "File telah didownload di $newPath");
    return newFile.path;
  }

  void viewArchive(String archive) {
    // TODO: buka halaman detail PDF viewer (pakai flutter_pdfview)
  }
}
