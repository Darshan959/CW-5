import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'aquarium.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE settings(id INTEGER PRIMARY KEY, fishCount INTEGER, speed REAL, color INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveSettings(int fishCount, double speed, int color) async {
    final db = await database;
    await db.insert(
        'settings',
        {
          'fishCount': fishCount,
          'speed': speed,
          'color': color,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final db = await database;
    final settings = await db.query('settings');
    if (settings.isNotEmpty) {
      return settings.first;
    }
    return null;
  }
}
