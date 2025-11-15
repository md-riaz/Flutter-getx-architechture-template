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
            onPressed: () => _confirmClearAll(context),
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
                        onChanged: (_) async {
                          final success = await controller.toggleTodo(todo.id);
                          if (!success && !Get.testMode) {
                            Get.snackbar(
                              'Todos',
                              controller.errorMessage.value ??
                                  'Unable to update todo.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
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
                        onPressed: () async {
                          final deleted = await controller.deleteTodo(todo.id);
                          if (deleted) {
                            if (!Get.testMode) {
                              Get.snackbar(
                                'Todos',
                                'Todo deleted successfully',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          } else if (!Get.testMode) {
                            Get.snackbar(
                              'Todos',
                              controller.errorMessage.value ??
                                  'Unable to delete todo.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() {
            final message = controller.errorMessage.value;
            if (message == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
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
              _buildStatItem('Total', controller.todoCount.toString(),
                  Colors.blue),
              _buildStatItem('Pending', controller.pendingCount.toString(),
                  Colors.orange),
              _buildStatItem('Completed',
                  controller.completedCount.toString(), Colors.green),
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

  Future<void> _showAddTodoDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    await Get.dialog(
      AlertDialog(
        title: const Text('Add New Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              onChanged: (value) => controller.title.value = value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => controller.description.value = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.title.value = '';
              controller.description.value = '';
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        final created = await controller.createTodo();
                        if (created) {
                          if (!Get.testMode) {
                            Get.snackbar(
                              'Todos',
                              'Todo created successfully',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                          Get.back();
                        } else if (!Get.testMode) {
                          Get.snackbar(
                            'Todos',
                            controller.errorMessage.value ??
                                'Unable to create todo.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
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

  Future<void> _confirmClearAll(BuildContext context) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Are you sure you want to delete all todos?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      final cleared = await controller.clearAll();
      if (cleared) {
        if (!Get.testMode) {
          Get.snackbar(
            'Todos',
            'All todos cleared',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (!Get.testMode) {
        Get.snackbar(
          'Todos',
          controller.errorMessage.value ?? 'Unable to clear todos.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
