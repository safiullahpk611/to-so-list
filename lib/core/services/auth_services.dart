import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_list/core/models/app_user.dart';
import 'package:to_do_list/core/services/database_services.dart';

class AuthServices {
  DatabaseServices databaseServices = DatabaseServices();
  Future<bool> insertUser(AppUser user) async {
    try {
      final exists = await userExists(user.email ?? '');
      if (exists) {
        print("User already registered with this email.");
        return false;
      }

      final db = await databaseServices.database;
      final id = await db.insert(
        'Users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      print("User inserted into SQLite with id $id");

      // Return the inserted user (with id)

      return true;
    } catch (e) {
      print("Error inserting user: $e");
      return false;
    }
  }

  Future<bool> userExists(String email) async {
    final db = await databaseServices.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<AppUser?> getUserByEmailAndPassword(
      String email, String password) async {
    try {
      final db = await databaseServices.database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      print("the result is ${result}");
      if (result.isNotEmpty) {
        return AppUser.fromMap(result.first); // login success
      } else {
        print("the result empty}");
        return null; // user not found
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

//
//
}
