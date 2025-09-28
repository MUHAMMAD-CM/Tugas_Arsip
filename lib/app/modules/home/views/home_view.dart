import 'package:arsip_mobile/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/archive_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFFFFF)),
        onPressed: () async {
          if (controller.category.isEmpty) {
            Get.snackbar(
              "Gagal",
              "Tidak ada kategori, tambahkan lebih dahulu",
              colorText: Colors.white,
              backgroundColor: const Color(0xFFef233c).withOpacity(0.7),
              snackPosition: SnackPosition.TOP,
              barBlur: 20,
              margin: const EdgeInsets.all(12),
              borderRadius: 16,
              icon: const Icon(Icons.error_outline, color: Colors.white),
              shouldIconPulse: true,
              duration: const Duration(seconds: 3),
            );
          } else {
            final result = await Get.toNamed(Routes.ARCHIVE_FORM);
            if (result == true) {
              controller.loadArchives();
            }
          }
        },
        child: Text(
          "Arsipkan Surat..",
          style: GoogleFonts.poppins(color: Color(0xFFEE8924), fontSize: 16),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Arsip"),
              onTap: () => Get.offNamed('/home'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Kategori Surat"),
              onTap: () => Get.offNamed('/category'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () => Get.offNamed('/about'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Cari nomer surat",
                      hintStyle: GoogleFonts.poppins(
                        color: Color(0xFF000000),
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => controller.searchQuery.value = val,
                  ),
                ),
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
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "Nomor Surat",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text("Kategori", textAlign: TextAlign.center),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text("Judul", textAlign: TextAlign.center),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            "Waktu Pengarsipan",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text("Aksi", textAlign: TextAlign.center),
                        ),
                      ),
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
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Get.toNamed(
                                          Routes.ARCHIVE_DETAIL,
                                          arguments: {
                                            "id": archive.id ?? '',
                                            "category": archive.kategoriNama,
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Lihat",
                                        style: TextStyle(
                                          color: Color(0xFF2b2d42),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed:
                                          () => controller.deleteArchive(
                                            archive.id.toString(),
                                          ),
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(
                                          color: Color(0xFF2b2d42),
                                        ),
                                      ),
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
                                      child: const Text(
                                        "Unduh",
                                        style: TextStyle(
                                          color: Color(0xFF2b2d42),
                                        ),
                                      ),
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
          ],
        ),
      ),
    );
  }
}
