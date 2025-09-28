import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/archive_form_controller.dart';

class ArchiveFormView extends GetView<ArchiveFormController> {
  const ArchiveFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Arsip Surat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.nomorSuratC,
                decoration: const InputDecoration(
                  labelText: "Nomor Surat",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              Obx(
                () => DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedKategori.value,
                  items:
                      controller.kategoriList
                          .map(
                            (c) =>
                                DropdownMenuItem(value: c, child: Text(c.nama)),
                          )
                          .toList(),
                  onChanged: (val) => controller.selectedKategori.value = val,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.judulC,
                decoration: const InputDecoration(
                  labelText: "Judul Surat",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.keteranganC,
                decoration: const InputDecoration(
                  labelText: "Keterangan",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.filePath.value.isEmpty
                            ? "Belum ada file dipilih"
                            : controller.filename.value,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Pilih File"),
                      onPressed: () => controller.pickFile(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.saveArchive,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
