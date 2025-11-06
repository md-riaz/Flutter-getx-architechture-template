import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../services/todos_service.dart';

/// Todos controller with random state via Timer
class TodosController extends BaseController {
  static const tag = 'TodosController';
  
  @override
  String get controllerName => tag;
  
  final TodosService _todosService;
  
  final titleController = RxString('');
  final descriptionController = RxString('');
  final randomState = RxInt(0);
  final isLoading = RxBool(false);
  
  Timer? _stateTimer;
  final _random = Random();

  TodosController({TodosService? todosService})
      : _todosService = todosService ?? Get.find<TodosService>();

  List get todos => _todosService.todos;
  int get todoCount => _todosService.todoCount;
  int get completedCount => _todosService.completedCount;
  int get pendingCount => _todosService.pendingCount;

  @override
  void onInit() {
    super.onInit();
    _startRandomStateTimer();
  }

  @override
  void onReady() {
    super.onReady();
    print('[TodosController] Ready to manage todos');
  }

  @override
  void onClose() {
    _stateTimer?.cancel();
    _stateTimer = null;
    super.onClose();
  }

  /// Start timer to update random state periodically
  void _startRandomStateTimer() {
    _stateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Check if timer is still active and not cancelled
      if (_stateTimer == null || !_stateTimer!.isActive) {
        timer.cancel();
        return;
      }
      randomState.value = _random.nextInt(100);
      print('[TodosController] Random state updated: ${randomState.value}');
    });
  }

  /// Create a new todo
  Future<void> createTodo() async {
    if (titleController.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a title');
      return;
    }

    isLoading.value = true;
    
    await _todosService.createTodo(
      titleController.value,
      descriptionController.value,
    );

    isLoading.value = false;
    titleController.value = '';
    descriptionController.value = '';
    
    Get.back(); // Close dialog
    Get.snackbar('Success', 'Todo created successfully');
  }

  /// Toggle todo completion
  Future<void> toggleTodo(String id) async {
    await _todosService.toggleTodoComplete(id);
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    final success = await _todosService.deleteTodo(id);
    if (success) {
      Get.snackbar('Success', 'Todo deleted successfully');
    }
  }

  /// Clear all todos
  void clearAll() {
    Get.defaultDialog(
      title: 'Clear All',
      middleText: 'Are you sure you want to delete all todos?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () {
        _todosService.clearAllTodos();
        Get.back();
        Get.snackbar('Success', 'All todos cleared');
      },
    );
  }
}
