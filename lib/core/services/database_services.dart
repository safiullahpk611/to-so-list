import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseServices {
  static Database? _db;

  /// Initializes the database and creates tables schema if not exist
  Future<Database> _initDB() async {
    try {
      // Use path_provider to get a writable app-specific directory
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'todo_apps.db');

      print("📁 Writable DB path: $path");

      // Use FFI for desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
          onConfigure: _onConfigure,
        ),
      );
    } catch (e) {
      print('❌ Error initializing database: $e');
      rethrow;
    }
  }

  /// Enable foreign key constraints
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Creates all tables in the database
  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
            CREATE TABLE users (
              appUserId INTEGER PRIMARY KEY AUTOINCREMENT,
              firstName TEXT,
              lastName TEXT,
              email TEXT,
              password TEXT
            )
          ''');

      await db.execute('''
     CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL CHECK(status IN ('Active', 'Completed')),
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users(appUserId) ON DELETE CASCADE
)
    ''');
    } catch (e) {
      print('Error creating tables: $e');
      rethrow;
    }
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }
  // Optional: fetch users
}
