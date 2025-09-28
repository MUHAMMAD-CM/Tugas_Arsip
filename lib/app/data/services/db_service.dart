import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/archive_model.dart';
import '../../data/models/category_model.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'arsip_desa.db');

    // opsional: hapus db lama kalau mau fresh start
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories (
            id TEXT PRIMARY KEY,
            nama TEXT NOT NULL,
            keterangan TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE archives (
            id TEXT PRIMARY KEY,
            nomor_surat TEXT NOT NULL,
            kategori_id TEXT NOT NULL,
            judul TEXT NOT NULL,
            waktu_pengarsipan TEXT NOT NULL,
            file_path TEXT,
            keterangan TEXT,
            FOREIGN KEY (kategori_id) REFERENCES categories (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // CRUD Category
  Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  // CRUD Archive
  Future<int> insertArchive(ArchiveModel archive) async {
    final db = await database;
    return await db.insert('archives', archive.toMap());
  }

  Future<List<ArchiveModel>> getArchives() async {
    final db = await database;
    final maps = await db.query('archives', orderBy: 'waktu_pengarsipan DESC');
    return maps.map((m) => ArchiveModel.fromMap(m)).toList();
  }

  Future<ArchiveModel?> getArchiveById(String id) async {
    final db = await database;
    final maps = await db.query(
      'archives',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ArchiveModel.fromMap(maps.first);
    }
    return null; // kalau tidak ketemu
  }

  Future<List<Map<String, dynamic>>> getArchivesWithCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT a.*, 
             c.nama AS kategori_nama, 
             c.keterangan AS kategori_keterangan
      FROM archives a
      LEFT JOIN categories c ON a.kategori_id = c.id
      ORDER BY a.waktu_pengarsipan DESC
    ''');
  }

  Future<int> updateArchive(ArchiveModel archive) async {
    final db = await database;
    return await db.update(
      'archives',
      archive.toMap(),
      where: 'id = ?',
      whereArgs: [archive.id],
    );
  }
}
