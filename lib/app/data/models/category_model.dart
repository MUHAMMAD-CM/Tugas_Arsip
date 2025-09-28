class CategoryModel {
  final String id;
  final String nama;
  final String keterangan;

  CategoryModel({
    required this.id,
    required this.nama,
    required this.keterangan,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      nama: map['nama'],
      keterangan: map['keterangan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'keterangan': keterangan};
  }
}
