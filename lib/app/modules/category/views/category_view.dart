import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/category_controller.dart';
import '../../../data/models/category_model.dart';
import 'package:uuid/uuid.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
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
        title: const Text("Kategori Surat"),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFFFFF)),
        onPressed: () => controller.openForm(context),
        child: Text(
          "Tambahkan Kategori",
          style: GoogleFonts.poppins(color: Color(0xFFEE8924), fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Berikut ini adalah kategori yang bisa digunakan untuk melabeli surat. \nKlik “Tambah” pada kolom aksi untuk menambahkan kategori baru.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Cari kategori...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = controller.filteredCategories;
              if (list.isEmpty) {
                return const Center(child: Text("Belum ada kategori"));
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final cat = list[index];
                  return ListTile(
                    title: Text(cat.nama),
                    subtitle: Text(cat.keterangan),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed:
                              () => controller.openForm(context, category: cat),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.deleteCategory(cat.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
