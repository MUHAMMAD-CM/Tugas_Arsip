import 'dart:io';

import 'package:arsip_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import '../../../data/models/archive_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/services/db_service.dart';

class ArchiveFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Input fields
  final nomorSuratC = TextEditingController();
  final judulC = TextEditingController();
  final keteranganC = TextEditingController();

  // Dropdown kategori
  var kategoriList = <CategoryModel>[].obs;
  var selectedKategori = Rx<CategoryModel?>(null);

  // File path
  var filePath = ''.obs;
  var filename = ''.obs;

  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    kategoriList.value = await DBService().getCategories();
    if (kategoriList.isNotEmpty) {
      selectedKategori.value = kategoriList.first;
    }
  }

  Future<String> savePdfToAppFolder(File pickedFile, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = '${appDir.path}/$fileName';

    // Copy file ke folder aplikasi
    final newFile = await pickedFile.copy(newPath);

    return newFile.path;
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);
      filename.value = result.files.single.name;

      // Simpan salinan ke folder aplikasi
      final savedPath = await savePdfToAppFolder(pickedFile, filename.value);
      filePath.value = savedPath;
    }
  }

  Future<void> saveArchive() async {
    if (!formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final formatted =
        DateFormat("dd MMMM yyyy HH:mm:ss", "id_ID").format(now).toString();

    final newArchive = ArchiveModel(
      id: const Uuid().v4(),
      nomorSurat: nomorSuratC.text,
      kategoriId: selectedKategori.value!.id,
      judul: judulC.text,
      waktuPengarsipan: formatted,
      filePath: filePath.value.isEmpty ? null : filePath.value,
      keterangan: keteranganC.text,
    );

    await DBService().insertArchive(newArchive);
    Get.back(result: true);
    await homeController.loadArchives();

    Get.snackbar(
      "Sukses",
      "Arsip surat berhasil ditambahkan",
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Izin diberikan → lanjut pilih file
      print("Akses storage diberikan");
    } else {
      // Izin ditolak → arahkan ke settings
      openAppSettings();
    }
  }
}
