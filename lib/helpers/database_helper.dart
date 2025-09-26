import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import 'alarm_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        alarm_time INTEGER NOT NULL,
        is_active INTEGER NOT NULL,
        description TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  // Insert alarm
  Future<int> insertAlarm(Alarm alarm) async {
    final db = await database;
    return await db.insert('alarms', alarm.toMap());
  }

  // Get all alarms
  Future<List<Alarm>> getAllAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alarms',
      orderBy: 'alarm_time ASC',
    );
    return List.generate(maps.length, (i) => Alarm.fromMap(maps[i]));
  }

  // Get active alarms
  Future<List<Alarm>> getActiveAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alarms',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'alarm_time ASC',
    );
    return List.generate(maps.length, (i) => Alarm.fromMap(maps[i]));
  }

  // Update alarm
  Future<int> updateAlarm(Alarm alarm) async {
    final db = await database;
    return await db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  // Delete alarm
  Future<int> deleteAlarm(int id) async {
    final db = await database;
    return await db.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toggle alarm active status
  Future<int> toggleAlarm(int id, bool isActive) async {
    final db = await database;
    return await db.update(
      'alarms',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
