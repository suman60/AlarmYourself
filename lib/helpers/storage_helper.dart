import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import 'alarm_model.dart';

class StorageHelper {
  static final StorageHelper _instance = StorageHelper._internal();
  factory StorageHelper() => _instance;
  StorageHelper._internal();

  static Database? _database;
  SharedPreferences? _prefs;

  // Initialize storage based on platform
  Future<void> initialize() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      await _initDatabase();
    }
  }

  // Database initialization for mobile platforms
  Future<void> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    _database = await openDatabase(
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
    if (kIsWeb) {
      return await _insertAlarmWeb(alarm);
    } else {
      return await _insertAlarmMobile(alarm);
    }
  }

  Future<int> _insertAlarmWeb(Alarm alarm) async {
    final alarms = await getAllAlarms();
    final newId = alarms.isEmpty ? 1 : alarms.map((a) => a.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    final newAlarm = alarm.copyWith(id: newId);
    
    alarms.add(newAlarm);
    await _saveAlarmsToWeb(alarms);
    return newId;
  }

  Future<int> _insertAlarmMobile(Alarm alarm) async {
    final db = await _database!;
    return await db.insert('alarms', alarm.toMap());
  }

  // Get all alarms
  Future<List<Alarm>> getAllAlarms() async {
    if (kIsWeb) {
      return await _getAllAlarmsWeb();
    } else {
      return await _getAllAlarmsMobile();
    }
  }

  Future<List<Alarm>> _getAllAlarmsWeb() async {
    final alarmsJson = _prefs!.getStringList('alarms') ?? [];
    return alarmsJson.map((json) => Alarm.fromMap(jsonDecode(json))).toList();
  }

  Future<List<Alarm>> _getAllAlarmsMobile() async {
    final db = await _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      'alarms',
      orderBy: 'alarm_time ASC',
    );
    return List.generate(maps.length, (i) => Alarm.fromMap(maps[i]));
  }

  // Get active alarms
  Future<List<Alarm>> getActiveAlarms() async {
    final alarms = await getAllAlarms();
    return alarms.where((alarm) => alarm.isActive).toList();
  }

  // Update alarm
  Future<int> updateAlarm(Alarm alarm) async {
    if (kIsWeb) {
      return await _updateAlarmWeb(alarm);
    } else {
      return await _updateAlarmMobile(alarm);
    }
  }

  Future<int> _updateAlarmWeb(Alarm alarm) async {
    final alarms = await getAllAlarms();
    final index = alarms.indexWhere((a) => a.id == alarm.id);
    if (index != -1) {
      alarms[index] = alarm;
      await _saveAlarmsToWeb(alarms);
      return 1;
    }
    return 0;
  }

  Future<int> _updateAlarmMobile(Alarm alarm) async {
    final db = await _database!;
    return await db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  // Delete alarm
  Future<int> deleteAlarm(int id) async {
    if (kIsWeb) {
      return await _deleteAlarmWeb(id);
    } else {
      return await _deleteAlarmMobile(id);
    }
  }

  Future<int> _deleteAlarmWeb(int id) async {
    final alarms = await getAllAlarms();
    alarms.removeWhere((alarm) => alarm.id == id);
    await _saveAlarmsToWeb(alarms);
    return 1;
  }

  Future<int> _deleteAlarmMobile(int id) async {
    final db = await _database!;
    return await db.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toggle alarm active status
  Future<int> toggleAlarm(int id, bool isActive) async {
    if (kIsWeb) {
      return await _toggleAlarmWeb(id, isActive);
    } else {
      return await _toggleAlarmMobile(id, isActive);
    }
  }

  Future<int> _toggleAlarmWeb(int id, bool isActive) async {
    final alarms = await getAllAlarms();
    final index = alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      alarms[index] = alarms[index].copyWith(isActive: isActive);
      await _saveAlarmsToWeb(alarms);
      return 1;
    }
    return 0;
  }

  Future<int> _toggleAlarmMobile(int id, bool isActive) async {
    final db = await _database!;
    return await db.update(
      'alarms',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Helper method to save alarms to web storage
  Future<void> _saveAlarmsToWeb(List<Alarm> alarms) async {
    final alarmsJson = alarms.map((alarm) => jsonEncode(alarm.toMap())).toList();
    await _prefs!.setStringList('alarms', alarmsJson);
  }
}
