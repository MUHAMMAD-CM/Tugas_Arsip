import 'package:arsip_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/archive_controller.dart';

class ArchiveView extends GetView<ArchiveController> {
  const ArchiveView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Arsip Surat"),
            Obx(() {
              return DropdownButton<String>(
                value:
                    controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                hint: const Text("Semua Kategori"),
                items: [
                  const DropdownMenuItem(value: '', child: Text("Semua")),
                  ...controller.category
                      .map(
                        (a) =>
                            DropdownMenuItem(value: a.id, child: Text(a.nama)),
                      )
                      .toSet() // biar kategori tidak dobel
                      .toList(),
                ],
                onChanged: (val) {
                  controller.selectedCategory.value = val ?? '';
                },
              );
            }),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Berikut ini adalah surat-surat yang telah terbit dan diarsipkan.\nKlik 'Lihat' pada kolom aksi untuk menampilkan surat.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Cari nomer surat",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => controller.searchQuery.value = val,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text("Cari!")),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.filteredArchives.isEmpty) {
                  return const Center(child: Text("Belum ada arsip surat"));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Nomor Surat")),
                      DataColumn(label: Text("Kategori")),
                      DataColumn(label: Text("Judul")),
                      DataColumn(label: Text("Waktu Pengarsipan")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows:
                        controller.filteredArchives.map((archive) {
                          return DataRow(
                            cells: [
                              DataCell(Text(archive.nomorSurat)),
                              DataCell(Text(archive.kategoriNama ?? "-")),
                              DataCell(Text(archive.judul)),
                              DataCell(Text(archive.waktuPengarsipan)),
                              DataCell(
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed:
                                          () => controller.deleteArchive(
                                            archive.id.toString(),
                                          ),
                                      child: const Text("Hapus"),
                                    ),
                                    const SizedBox(width: 4),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      onPressed:
                                          () => controller.downloadArchive(
                                            archive.id.toString(),
                                          ),
                                      child: const Text("Unduh"),
                                    ),
                                    const SizedBox(width: 4),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed:
                                          () => controller.viewArchive(
                                            archive.id.toString(),
                                          ),
                                      child: const Text("Lihat >>"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await Get.toNamed(Routes.ARCHIVE_FORM);
                if (result == true) {
                  controller.loadArchives(); // reload kalau ada update
                }
              },
              child: const Text("Arsipkan Surat.."),
            ),
          ],
        ),
      ),
    );
  }
}
