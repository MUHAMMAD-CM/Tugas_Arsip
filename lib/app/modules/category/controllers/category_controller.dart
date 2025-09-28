import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/category_model.dart';
import '../../../data/services/db_service.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var searchQuery = ''.obs;
  var isSearching = false.obs;
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.isEmpty) return categories;
    return categories
        .where(
          (c) =>
              c.nama.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              c.keterangan.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
        )
        .toList();
  }

  Future<void> loadCategories() async {
    final db = await DBService().database;
    final maps = await db.query('categories');
    categories.value = maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    final db = await DBService().database;
    await db.insert('categories', category.toMap());
    await loadCategories();
  }

  Future<void> updateCategory(CategoryModel category) async {
    final db = await DBService().database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    final db = await DBService().database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    await loadCategories();
  }

  void openForm(BuildContext context, {CategoryModel? category}) {
    final namaCtrl = TextEditingController(text: category?.nama ?? "");
    final ketCtrl = TextEditingController(text: category?.keterangan ?? "");
    final isEdit = category != null;

    Get.dialog(
      AlertDialog(
        title: Text(isEdit ? "Edit Kategori" : "Tambah Kategori"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: ketCtrl,
              decoration: const InputDecoration(labelText: "Keterangan"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (namaCtrl.text.isEmpty) return;
              final newCat = CategoryModel(
                id: isEdit ? category!.id : const Uuid().v4(),
                nama: namaCtrl.text,
                keterangan: ketCtrl.text,
              );
              if (isEdit) {
                await updateCategory(newCat);
              } else {
                await addCategory(newCat);
              }
              Get.back();
            },
            child: Text(isEdit ? "Update" : "Simpan"),
          ),
        ],
      ),
    );
  }
}
