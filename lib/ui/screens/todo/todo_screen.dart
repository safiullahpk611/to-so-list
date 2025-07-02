import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/ui/screens/auth/sign_in/sign_in.dart';
import 'package:to_do_list/ui/screens/todo/todo_provider.dart';
import 'package:to_do_list/ui/widgets/title_bar.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
      create: (BuildContext context) {
        return TodoProvider();
      },
      child: Consumer<TodoProvider>(
          builder: (BuildContext context, TodoProvider model, Widget? child) {
        return Scaffold(
          // appBar: AppBar(title: const Text("📝 To-Do Manager")),
          body: Row(
            children: [
              // Sidebar for adding task
              Container(
                width: 350,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16),
                child: const AddTaskForm(),
              ),

              // Main area
              Expanded(
                child: Column(
                  children: [
                    const FilterHeader(),
                    const Expanded(child: TaskListView()),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate dummy task list
    final tasks = [
      {"title": "Buy groceries", "status": "Active"},
      {"title": "Send report", "status": "Completed"},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = task['status'] == 'Completed';

        return ListTile(
          leading: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : null,
          ),
          title: Text(
            task['title'] ?? '',
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          ),
          onTap: () {
            // Mark as complete or toggle status
          },
        );
      },
    );
  }
}

class FilterHeader extends StatelessWidget {
  const FilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Text("📂 Filter by status:", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 16),
          FilterChip(
              label: const Text("All"), selected: true, onSelected: (_) {}),
          const SizedBox(width: 8),
          FilterChip(
              label: const Text("Active"), selected: false, onSelected: (_) {}),
          const SizedBox(width: 8),
          FilterChip(
              label: const Text("Completed"),
              selected: false,
              onSelected: (_) {}),
        ],
      ),
    );
  }
}

class AddTaskForm extends StatelessWidget {
  const AddTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("➕ Add New Task", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(labelText: 'Title'),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          items: ['Active', 'Completed']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (_) {},
          decoration: const InputDecoration(labelText: 'Status'),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            todoProvider.logout(context);
          },
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
//
