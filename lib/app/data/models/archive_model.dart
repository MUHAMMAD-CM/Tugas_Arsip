class ArchiveModel {
  final String id;
  final String nomorSurat;
  final String kategoriId;
  final String judul;
  final String waktuPengarsipan;
  final String? filePath;
  final String? keterangan;

  ArchiveModel({
    required this.id,
    required this.nomorSurat,
    required this.kategoriId,
    required this.judul,
    required this.waktuPengarsipan,
    this.filePath,
    this.keterangan,
  });

  factory ArchiveModel.fromMap(Map<String, dynamic> map) {
    return ArchiveModel(
      id: map['id'],
      nomorSurat: map['nomor_surat'],
      kategoriId: map['kategori_id'],
      judul: map['judul'],
      waktuPengarsipan: map['waktu_pengarsipan'],
      filePath: map['file_path'],
      keterangan: map['keterangan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomor_surat': nomorSurat,
      'kategori_id': kategoriId,
      'judul': judul,
      'waktu_pengarsipan': waktuPengarsipan,
      'file_path': filePath,
      'keterangan': keterangan,
    };
  }
}
