import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _db;
  static Box? _hiveBox;

  /// Use SQLite on mobile, Hive on web
  Future<bool> get _useHive async => kIsWeb;

  /// Init DB depending on platform
  Future<void> init() async {
    if (await _useHive) {
      await Hive.initFlutter();
      _hiveBox = await Hive.openBox('appBox');
    } else {
      _db = await _initDB();
    }
  }

  // ---------------- SQLITE INIT ----------------
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE current_user(
            id INTEGER PRIMARY KEY,
            user_id INTEGER
          )
        ''');
      },
    );
  }

  // ---------------- SHARED METHODS ----------------

  Future<void> saveCurrentUser(int userId) async {
    if (await _useHive) {
      await _hiveBox!.put('current_user', userId);
    } else {
      final db = await database;
      await db.insert(
        'current_user',
        {'id': 1, 'user_id': userId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    if (await _useHive) {
      final userId = _hiveBox!.get('current_user');
      if (userId != null) {
             final data = _hiveBox!.get('user_$userId');
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      }
      return null;
    } else {
      final db = await database;
      final res = await db.rawQuery('''
        SELECT u.id, u.name, u.email 
        FROM users u
        JOIN current_user c ON u.id = c.user_id
        WHERE c.id = 1
      ''');
      if (res.isNotEmpty) return res.first;
      return null;
    }
  }

  Future<UserModel?> getUserById(int id) async {
    if (await _useHive) {
      final data = _hiveBox!.get('user_$id');
      if (data != null) {
        return UserModel.fromMap(Map<String, dynamic>.from(data));
      }
      return null;
    } else {
      final db = await database;
      final res = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (res.isNotEmpty) {
        return UserModel.fromMap(res.first);
      }
      return null;
    }
  }

  Future<int?> getSavedCurrentUserId() async {
    if (await _useHive) {
      return _hiveBox!.get('current_user');
    } else {
      final db = await database;
      final res = await db.query(
        'current_user',
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );
      if (res.isNotEmpty) {
        return res.first['user_id'] as int;
      }
      return null;
    }
  }

  Future<void> clearCurrentUser() async {
    if (await _useHive) {
      await _hiveBox!.delete('current_user');
    } else {
      final db = await database;
      await db.delete('current_user', where: 'id = ?', whereArgs: [1]);
    }
  }

  Future<int> insertUser(UserModel user) async {
    if (await _useHive) {
      // Simulate auto-increment id
      final id = (_hiveBox!.get('user_counter') ?? 0) + 1;
      _hiveBox!.put('user_counter', id);

      final data = user.toMap()..['id'] = id;
      await _hiveBox!.put('user_$id', data);
      return id;
    } else {
      final db = await database;
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<UserModel?> getUser(String email, String password) async {
    if (await _useHive) {
      final keys = _hiveBox!.keys.where((k) => k.toString().startsWith('user_'));
      for (final key in keys) {
        final data = Map<String, dynamic>.from(_hiveBox!.get(key));
        if (data['email'] == email && data['password'] == password) {
          return UserModel.fromMap(data);
        }
      }
      return null;
    } else {
      final db = await database;
      final res = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      if (res.isNotEmpty) {
        return UserModel.fromMap(res.first);
      }
      return null;
    }
  }

Future<bool> emailExists(String email) async {
  if (await _useHive) {
    final keys = _hiveBox!.keys.where((k) => k.toString().startsWith('user_'));
    for (final key in keys) {
      final value = _hiveBox!.get(key);
      if (value is Map) { // ✅ only process maps
        final data = Map<String, dynamic>.from(value);
        if ((data['email'] as String).toLowerCase() == email.toLowerCase()) {
          return true;
        }
      }
    }
    return false;
  } else {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'LOWER(email) = ?', // ✅ case-insensitive
      whereArgs: [email.toLowerCase()],
    );
    return res.isNotEmpty;
  }
}

}
