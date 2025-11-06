import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todos_controller.dart';

class TodosScreen extends GetView<TodosController> {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: controller.clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStats(),
          Expanded(
            child: Obx(() {
              if (controller.todos.isEmpty) {
                return const Center(
                  child: Text(
                    'No todos yet!\nTap + to add one',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.todos.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final todo = controller.todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => controller.toggleTodo(todo.id),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: todo.description.isNotEmpty
                          ? Text(todo.description)
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteTodo(todo.id),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => Text(
              'Random State: ${controller.randomState.value}',
              style: const TextStyle(color: Colors.grey),
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', controller.todoCount.toString(), Colors.blue),
          _buildStatItem('Pending', controller.pendingCount.toString(), Colors.orange),
          _buildStatItem('Completed', controller.completedCount.toString(), Colors.green),
        ],
      ),
    ));
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _showAddTodoDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Add New Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.titleController.value = value,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.descriptionController.value = value,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.titleController.value = '';
              controller.descriptionController.value = '';
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.createTodo,
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add'),
          )),
        ],
      ),
    );
  }
}
