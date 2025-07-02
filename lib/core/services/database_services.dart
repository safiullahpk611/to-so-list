import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:to_do_list/core/models/app_user.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDB() async {
    if (_db != null) return _db!;
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, 'todo_app.db');

    _db = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
        CREATE TABLE users (
          
          appUserId INTEGER PRIMARY KEY AUTOINCREMENT,
          firstName TEXT,
          lastName TEXT,
          email TEXT,
          phoneNumber TEXT,
          password TEXT
        )
      ''');
            print("✅ Users table created");
          },
        ));

    print("✅ Database connected at: $path");

    return _db!;
  }

  // static Future<void> insertUser(AppUser user) async {
  //   final db = await getDB();

  //   await db.insert(
  //     'users',
  //     user, // Use your model's toMap method
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );

  //   print("✅ User inserted successfully using model");
  // }
}
