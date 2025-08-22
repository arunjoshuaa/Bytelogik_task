import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

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

  // Initialize DB
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
                // Create current_user table
        await db.execute('''
          CREATE TABLE current_user(
            id INTEGER PRIMARY KEY,
            user_id INTEGER
          )
        ''');
      },
    );
  }
// Save logged-in user by ID
Future<void> saveCurrentUser(int userId) async {
  final db = await database;
  await db.insert(
    'current_user',
    {'id': 1, 'user_id': userId},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Get current user by joining with users table
Future<Map<String, dynamic>?> getCurrentUser() async {
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
// for counter page to load the name when app reopen
Future<UserModel?> getUserById(int id) async {
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

Future<int?> getSavedCurrentUserId() async {
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

// Clear on logout
Future<void> clearCurrentUser() async {
  final db = await database;
  await db.delete('current_user', where: 'id = ?', whereArgs: [1]);
}

  // Insert user
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

Future<UserModel?> getUser(String email, String password) async {
  final db = await database;
  final res = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );

  if (res.isNotEmpty) {
    return UserModel.fromMap(res.first); // user found
  }
  return null; // no user
}


  // Check if email already exists
  Future<bool> emailExists(String email) async {
    print("the email is $email");
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return res.isNotEmpty;
  }
}
