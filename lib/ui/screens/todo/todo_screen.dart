import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/core/models/to_do_task_model.dart';
import 'package:to_do_list/ui/screens/todo/todo_provider.dart';

import '../../widgets/button.dart';

class TodoScreen extends StatefulWidget {
  String? userId;
  TodoScreen({super.key, this.userId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

//
class _TodoScreenState extends State<TodoScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
      create: (_) => TodoProvider(widget.userId.toString()),
      child: Consumer<TodoProvider>(builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton.icon(
                  onPressed: () => provider.logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ),
            ],
            //  title: Text("To Do AP"),
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepPurple,
              const Color.fromARGB(255, 26, 3, 66)
            ])),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width < 700 ? 220 : 300,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(16),
                    child: AddTaskForm(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilterHeader(
                          currentTabIndex: _tabController.index,
                          tabController: _tabController),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            TaskListView(filter: "All"),
                            TaskListView(filter: "Active"),
                            TaskListView(filter: "Completed"),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class FilterHeader extends StatelessWidget {
  final int currentTabIndex;
  final TabController tabController;

  const FilterHeader({
    super.key,
    required this.currentTabIndex,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("📂 Filter by status:",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          ChoiceChip(
            label: const Text("All"),
            selected: currentTabIndex == 0,
            onSelected: (_) => tabController.animateTo(0),
            selectedColor: Colors.blue.shade200,
          ),
          ChoiceChip(
            label: const Text("Active"),
            selected: currentTabIndex == 1,
            onSelected: (_) => tabController.animateTo(1),
            selectedColor: Colors.green.shade200,
          ),
          ChoiceChip(
            label: const Text("Completed"),
            selected: currentTabIndex == 2,
            onSelected: (_) => tabController.animateTo(2),
            selectedColor: Colors.orange.shade200,
          ),
        ],
      ),
    );
  }
}

//
class TaskListView extends StatelessWidget {
  final String filter;
  const TaskListView({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final filteredTasks = todoProvider.getFilteredTasks(filter);

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox, // You can change this to match the app theme
              size: 60,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              filter == "All"
                  ? "No tasks added yet!"
                  : "No tasks in \"$filter\"",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      onReorder: (oldIndex, newIndex) {
        // Adjust the index when reordering downward
        if (newIndex > oldIndex) newIndex -= 1;
        todoProvider.reorderTasks(filteredTasks, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        final isCompleted = task.status == 'Completed';

        return Card(
          key: ValueKey(task.id), // Required for reordering
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.orange,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    todoProvider.showEditDialog(context, task);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    todoProvider.handleDeleteTask(context, task.id!);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddTaskForm extends StatelessWidget {
  const AddTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("➕ Add New Task", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        TextField(
          controller: provider.titleController,
          onChanged: (val) => provider.todoTask.title = val,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: provider.descriptionController,
          onChanged: (val) => provider.todoTask.description = val,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: provider.todoTask.status.isEmpty
              ? null
              : provider.todoTask.status,
          items: ['Active', 'Completed']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
              .toList(),
          onChanged: (val) => provider.todoTask.status = val ?? '',
          decoration: const InputDecoration(labelText: 'Status'),
        ),
        const SizedBox(height: 20),
        // Update the path accordingly

        GradientButtonWithIcon(
          onPressed: () => provider.addTask(context, provider.todoTask),
          icon: Icons.add,
          label: 'Add Task',
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
//
