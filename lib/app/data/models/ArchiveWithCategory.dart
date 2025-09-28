class ArchiveWithCategory {
  final String id;
  final String nomorSurat;
  final String judul;
  final String waktuPengarsipan;
  final String filePath;
  final String kategoriId;
  final String kategoriNama;
  final String kategoriKeterangan;

  ArchiveWithCategory({
    required this.id,
    required this.nomorSurat,
    required this.judul,
    required this.waktuPengarsipan,
    required this.filePath,
    required this.kategoriId,
    required this.kategoriNama,
    required this.kategoriKeterangan,
  });

  factory ArchiveWithCategory.fromMap(Map<String, dynamic> map) {
    return ArchiveWithCategory(
      id: map['id'],
      nomorSurat: map['nomor_surat'],
      judul: map['judul'],
      waktuPengarsipan: map['waktu_pengarsipan'],
      filePath: map['file_path'],
      kategoriId: map['kategori_id'],
      kategoriNama: map['kategori_nama'],
      kategoriKeterangan: map['kategori_keterangan'],
    );
  }
}
