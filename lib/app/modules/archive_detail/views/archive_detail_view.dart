import 'dart:io';

import 'package:arsip_mobile/app/data/models/archive_model.dart';
import 'package:arsip_mobile/app/data/models/category_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';

import '../controllers/archive_detail_controller.dart';

class ArchiveDetailView extends GetView<ArchiveDetailController> {
  const ArchiveDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Arsip Surat >> Lihat"),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() {
          final archive = controller.archive.value;

          if (archive == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final file = File(archive.filePath ?? '');
          if (!file.existsSync()) {
            return const Center(child: Text("File tidak ditemukan"));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nomor: ${archive.nomorSurat}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Kategori: ${controller.kategori.value}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Judul: ${archive.judul}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Waktu Unggah: ${archive.waktuPengarsipan}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PDFView(
                    filePath: file.path,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => controller.editArchiveDialog(),
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),

                      ElevatedButton.icon(
                        onPressed: () async {
                          await controller.movePdfToDownload(
                            controller.archive.value!.filePath ?? '',
                            controller.archive.value!.judul,
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("Download"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
