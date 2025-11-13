import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../services/todos_service.dart';
import '../../../util/snackbar.dart';

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
  bool _isDisposed = false;

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
    _isDisposed = true;
    _stateTimer?.cancel();
    _stateTimer = null;
    super.onClose();
  }

  /// Start timer to update random state periodically
  void _startRandomStateTimer() {
    _stateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Exit early if controller is being disposed or closed
      if (_isDisposed || isClosed) {
        timer.cancel();
        return;
      }
      
      try {
        randomState.value = _random.nextInt(100);
        print('[TodosController] Random state updated: ${randomState.value}');
      } catch (e) {
        print('[TodosController] Error updating random state: $e');
        timer.cancel();
      }
    });
  }

  /// Create a new todo
  Future<void> createTodo() async {
    if (titleController.value.isEmpty) {
      AppSnackBar.error('Please enter a title', title: 'Error');
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
    
    if (Get.isDialogOpen == true) {
      Get.back(); // Close dialog
    }
    AppSnackBar.success('Todo created successfully', title: 'Success');
  }

  /// Toggle todo completion
  Future<void> toggleTodo(String id) async {
    await _todosService.toggleTodoComplete(id);
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    final success = await _todosService.deleteTodo(id);
    if (success) {
      AppSnackBar.success('Todo deleted successfully', title: 'Success');
    }
  }

  /// Clear all todos
  void clearAll() {
    if (Get.overlayContext == null) {
      print('[TodosController] Cannot show dialog - no overlay context');
      return;
    }
    
    // Use postFrameCallback to ensure safe dialog display
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.overlayContext == null || _isDisposed || isClosed) {
        print('[TodosController] Cannot show dialog - context not available');
        return;
      }
      
      Get.defaultDialog(
        title: 'Clear All',
        middleText: 'Are you sure you want to delete all todos?',
        textConfirm: 'Yes',
        textCancel: 'No',
        onConfirm: () {
          _todosService.clearAllTodos();
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          AppSnackBar.success('All todos cleared', title: 'Success');
        },
      );
    });
  }
}
