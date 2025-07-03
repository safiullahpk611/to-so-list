import 'package:to_do_list/core/models/to_do_task_model.dart';
import 'package:to_do_list/core/services/database_services.dart';

class DatabaseStorage {
  final databaseServices = DatabaseServices();

  Future<void> addTask(TodoTask task) async {
    try {
      final db = await databaseServices.database;
      await db.insert('todos', task.toMap());
      print("Task inserted for user ${task.userId}");
    } catch (e) {
      print("Failed to insert task: $e");
      rethrow;
    }
  }

  Future<List<TodoTask>> getTasksForUser(String userId) async {
    final db = await databaseServices.database;

    final maps = await db.query(
      'todos',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => TodoTask.fromMap(map)).toList();
  }

  Future<void> updateTask(TodoTask task) async {
    try {
      final db = await databaseServices.database;
      await db.update(
        'todos',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      print("Task updated successfully");
    } catch (e) {
      print("Error updating task: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await databaseServices.database;
      await db.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
      );
      print("Task deleted successfully");
    } catch (e) {
      print("Error deleting task: $e");
      rethrow;
    }
  }
}
