import 'dart:io';

import 'package:arsip_mobile/app/data/models/archive_model.dart';
import 'package:arsip_mobile/app/data/models/category_model.dart';
import 'package:arsip_mobile/app/data/services/db_service.dart';
import 'package:arsip_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ArchiveDetailController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  final dbService = DBService();
  RxString id = ''.obs;
  RxString kategori = ''.obs;
  var archive = Rxn<ArchiveModel>();
  @override
  Future<void> onInit() async {
    super.onInit();
    // ambil dari arguments
    final args = Get.arguments;
    print(args);
    if (args != null && args['id'] != null) {
      id.value = args['id'];
    }
    if (args != null && args['category'] != null) {
      kategori.value = args['category'];
    }
    await loadArchive(id.value);
  }

  Future<void> loadArchive(String id) async {
    final db = await DBService().getArchiveById(id);
    archive.value = db;
  }

  Future<File> getFile() async {
    return File(archive.value!.filePath ?? '');
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

  Future<void> editArchiveDialog() async {
    final currentArchive = archive.value;
    if (currentArchive == null) return;

    String pickedFileName = currentArchive.filePath ?? '';
    final kategoriList = await dbService.getCategories();
    CategoryModel? selectedKategori = kategoriList.firstWhereOrNull(
      (c) => c.id == currentArchive.kategoriId,
    );

    final nomorController = TextEditingController(
      text: currentArchive.nomorSurat,
    );
    final judulController = TextEditingController(text: currentArchive.judul);
    final fileController = TextEditingController(text: currentArchive.filePath);

    Get.defaultDialog(
      title: "Edit Arsip",
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextField(
                controller: nomorController,
                decoration: const InputDecoration(
                  labelText: "Nomor Surat",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<CategoryModel>(
                value: selectedKategori,
                items:
                    kategoriList
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.nama)),
                        )
                        .toList(),
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() => selectedKategori = val);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: "Judul",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pickedFileName.isEmpty
                          ? "Belum ada file dipilih"
                          : pickedFileName,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Pilih File"),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null && result.files.single.path != null) {
                        setState(() {
                          pickedFileName = result.files.single.name;
                          fileController.text = result.files.single.path!;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
      textCancel: "Batal",
      textConfirm: "Simpan",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final updatedArchive = ArchiveModel(
          id: currentArchive.id,
          nomorSurat: nomorController.text,
          judul: judulController.text,
          kategoriId: selectedKategori?.id ?? currentArchive.kategoriId,
          filePath: fileController.text,
          waktuPengarsipan: currentArchive.waktuPengarsipan,
        );

        kategori.value = selectedKategori?.nama ?? kategori.value;

        await dbService.updateArchive(updatedArchive);
        await loadArchive(id.value);

        Get.back();
        Get.back();
        homeController.loadArchives();
        Get.snackbar("Sukses", "Data berhasil diperbarui");
      },
    );
  }
}
