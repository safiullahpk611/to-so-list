import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/models/base_view_model.dart';
import 'package:to_do_list/core/models/to_do_task_model.dart';
import 'package:to_do_list/core/services/database_storage.dart';
import 'package:to_do_list/ui/screens/auth/sign_in/sign_in.dart';

class TodoProvider extends BaseViewModal {
  /// Constructor that optionally accepts a user ID
  TodoProvider(String id) {
    if (id.isNotEmpty) {
      print("User ID received in constructor: $id");
      saveUserId(id);
    }
    print("TodoProvider constructor called");
  }

  final _dbStorage = DatabaseStorage();
  String? userId;

  // Model for task input
  TodoTask todoTask = TodoTask(
    userId: 1,
    title: '',
    description: '',
    status: '',
    createdAt: '',
    updatedAt: '',
  );

  /// List of all tasks for the current user
  List<TodoTask> tasks = [];

  /// Save user ID and load tasks
  void saveUserId(String id) {
    userId = id;
    print("User ID saved: $id");
    notifyListeners();
    loadTasks();
  }

  /// Logout function with confirmation dialog
  Future<void> logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all data
      await prefs.setBool('isLoggedIn', false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    }
  }

  /// Load tasks for the logged-in user
  Future<void> loadTasks() async {
    if (userId == null) return;

    tasks = await _dbStorage.getTasksForUser(userId!);

    for (var task in tasks) {
      print('📝 Task ID: ${task.id}, Title: ${task.title}');
    }

    notifyListeners();
  }

  /// Add a new task to the database
  Future<void> addTask(BuildContext context, TodoTask task) async {
    final now = DateTime.now().toIso8601String();
    final parsedUserId = int.parse(userId!);

    final newTask = TodoTask(
      userId: parsedUserId,
      title: todoTask.title,
      description: todoTask.description,
      status: todoTask.status,
      createdAt: now,
      updatedAt: now,
    );

    final res = await _dbStorage.addTask(newTask);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added successfully')),
    );
    await loadTasks();
  }

  /// Load user ID from shared preferences
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('loggedInUserId');
    if (id != null) {
      userId = id;
      print("Loaded user ID: $userId");
      await loadTasks();
      notifyListeners();
    }
  }

  /// Show edit dialog for updating an existing task
  void showEditDialog(BuildContext context, TodoTask task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    String status = task.status;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('✏️ Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['Active', 'Completed'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (val) => status = val!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedTask = TodoTask(
                id: task.id,
                title: titleController.text,
                description: descController.text,
                status: status,
                userId: task.userId,
                createdAt: task.createdAt,
                updatedAt: DateTime.now().toIso8601String(),
              );
              updateTask(updatedTask);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Update task in database and refresh UI
  Future<void> updateTask(TodoTask updatedTask) async {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await _dbStorage.updateTask(updatedTask);
      await loadTasks();
      notifyListeners();
    }
  }

  /// Delete a task by its ID
  Future<void> deleteTask(int id) async {
    await _dbStorage.deleteTask(id);
    await loadTasks();
    notifyListeners();
  }

  /// Show confirmation dialog before deleting a task
  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  List<TodoTask> getFilteredTasks(String filter) {
    if (filter == 'Active') {
      return tasks.where((task) => task.status == 'Active').toList();
    } else if (filter == 'Completed') {
      return tasks.where((task) => task.status == 'Completed').toList();
    }
    return tasks;
  }

  Future<void> handleDeleteTask(BuildContext context, int taskId) async {
    final confirm = await showDeleteConfirmationDialog(context);
    if (confirm) {
      await deleteTask(taskId);
    }
  }
}
