import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_architecture/data/auth/datasources/auth_local_data_source.dart';
import 'package:flutter_getx_architecture/data/auth/datasources/auth_remote_data_source.dart';
import 'package:flutter_getx_architecture/data/auth/repositories/auth_repository_impl.dart';
import 'package:flutter_getx_architecture/domain/auth/entities/user.dart';
import 'package:flutter_getx_architecture/data/sms/datasources/sms_local_data_source.dart';
import 'package:flutter_getx_architecture/data/sms/datasources/sms_remote_data_source.dart';
import 'package:flutter_getx_architecture/data/sms/repositories/sms_repository_impl.dart';
import 'package:flutter_getx_architecture/data/todos/datasources/todo_local_data_source.dart';
import 'package:flutter_getx_architecture/data/todos/datasources/todo_remote_data_source.dart';
import 'package:flutter_getx_architecture/data/todos/repositories/todo_repository_impl.dart';
import 'package:flutter_getx_architecture/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_getx_architecture/domain/auth/usecases/get_current_user_use_case.dart';
import 'package:flutter_getx_architecture/domain/auth/usecases/login_use_case.dart';
import 'package:flutter_getx_architecture/domain/auth/usecases/logout_use_case.dart';
import 'package:flutter_getx_architecture/domain/sms/repositories/sms_repository.dart';
import 'package:flutter_getx_architecture/domain/sms/usecases/fetch_sms_conversations_use_case.dart';
import 'package:flutter_getx_architecture/domain/sms/usecases/fetch_sms_messages_use_case.dart';
import 'package:flutter_getx_architecture/domain/todos/repositories/todo_repository.dart';
import 'package:flutter_getx_architecture/domain/todos/usecases/clear_todos_use_case.dart';
import 'package:flutter_getx_architecture/domain/todos/usecases/create_todo_use_case.dart';
import 'package:flutter_getx_architecture/domain/todos/usecases/delete_todo_use_case.dart';
import 'package:flutter_getx_architecture/domain/todos/usecases/fetch_todos_use_case.dart';
import 'package:flutter_getx_architecture/domain/todos/usecases/toggle_todo_completion_use_case.dart';
import 'package:flutter_getx_architecture/domain/todos/usecases/update_todo_use_case.dart';
import 'package:flutter_getx_architecture/features/auth/controllers/auth_controller.dart';
import 'package:flutter_getx_architecture/features/auth/services/auth_service.dart';
import 'package:flutter_getx_architecture/features/sms/services/sms_service.dart';
import 'package:flutter_getx_architecture/features/todos/controllers/todos_controller.dart';
import 'package:flutter_getx_architecture/features/todos/services/todos_service.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('Auth domain integration', () {
    late AuthRepository authRepository;
    late LoginUseCase loginUseCase;
    late LogoutUseCase logoutUseCase;
    late GetCurrentUserUseCase getCurrentUserUseCase;
    late AuthService authService;

    setUp(() {
      final remote = FakeAuthRemoteDataSource();
      final local = InMemoryAuthLocalDataSource();
      authRepository = AuthRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );
      loginUseCase = LoginUseCase(authRepository);
      logoutUseCase = LogoutUseCase(authRepository);
      getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
      authService = AuthService(
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
        getCurrentUserUseCase: getCurrentUserUseCase,
      );
    });

    test('login use case authenticates user', () async {
      final user = await loginUseCase(
        const LoginParams(
          email: 'alex.operations@example.com',
          password: 'Passw0rd!',
        ),
      );

      expect(user.email, 'alex.operations@example.com');
      expect(user.enabledFeatures.length, greaterThan(0));
      expect(getCurrentUserUseCase()?.email, 'alex.operations@example.com');
    });

    test('auth controller updates service on login and logout', () async {
      final controller = AuthController(
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
        getCurrentUserUseCase: getCurrentUserUseCase,
        authService: authService,
      );

      controller.onInit();

      controller.email.value = 'brenda.dispatch@example.com';
      controller.password.value = 'FaxMeNow';

      final loginSuccess = await controller.login();
      expect(loginSuccess, isTrue);
      expect(authService.currentUser?.email, 'brenda.dispatch@example.com');
      expect(authService.currentUser?.enabledFeatures.contains(AppFeature.fax),
          isTrue);

      final logoutSuccess = await controller.logout();
      expect(logoutSuccess, isTrue);
      expect(authService.currentUser, isNull);
    });
  });

  group('SMS service integration', () {
    late SmsRepository smsRepository;
    late FetchSmsConversationsUseCase fetchConversationsUseCase;
    late FetchSmsMessagesUseCase fetchMessagesUseCase;
    late SmsService smsService;

    setUp(() {
      final remote = FakeSmsRemoteDataSource();
      final local = InMemorySmsLocalDataSource();
      smsRepository = SmsRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );
      fetchConversationsUseCase = FetchSmsConversationsUseCase(smsRepository);
      fetchMessagesUseCase = FetchSmsMessagesUseCase(smsRepository);
      smsService = SmsService(
        fetchConversations: fetchConversationsUseCase,
        fetchMessages: fetchMessagesUseCase,
      );
    });

    test('loads conversations and messages', () async {
      await smsService.refreshConversations();
      expect(smsService.conversations, isNotEmpty);

      final conversationId = smsService.conversations.first.id;
      await smsService.refreshMessages(conversationId);
      final messages = smsService.messagesFor(conversationId);

      expect(messages, isNotEmpty);
    });
  });

  group('Todos controller integration', () {
    late TodoRepository todoRepository;
    late FetchTodosUseCase fetchTodosUseCase;
    late CreateTodoUseCase createTodoUseCase;
    late UpdateTodoUseCase updateTodoUseCase;
    late DeleteTodoUseCase deleteTodoUseCase;
    late ToggleTodoCompletionUseCase toggleTodoCompletionUseCase;
    late ClearTodosUseCase clearTodosUseCase;
    late TodosService todosService;
    late TodosController controller;

    setUp(() {
      final remote = FakeTodoRemoteDataSource();
      final local = InMemoryTodoLocalDataSource();
      todoRepository = TodoRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
      );
      fetchTodosUseCase = FetchTodosUseCase(todoRepository);
      createTodoUseCase = CreateTodoUseCase(todoRepository);
      updateTodoUseCase = UpdateTodoUseCase(todoRepository);
      deleteTodoUseCase = DeleteTodoUseCase(todoRepository);
      toggleTodoCompletionUseCase = ToggleTodoCompletionUseCase(todoRepository);
      clearTodosUseCase = ClearTodosUseCase(todoRepository);
      todosService = TodosService(
        fetchTodosUseCase: fetchTodosUseCase,
        createTodoUseCase: createTodoUseCase,
        updateTodoUseCase: updateTodoUseCase,
        deleteTodoUseCase: deleteTodoUseCase,
        toggleTodoCompletionUseCase: toggleTodoCompletionUseCase,
        clearTodosUseCase: clearTodosUseCase,
      );
      controller = TodosController(
        fetchTodosUseCase: fetchTodosUseCase,
        createTodoUseCase: createTodoUseCase,
        updateTodoUseCase: updateTodoUseCase,
        deleteTodoUseCase: deleteTodoUseCase,
        toggleTodoCompletionUseCase: toggleTodoCompletionUseCase,
        clearTodosUseCase: clearTodosUseCase,
        todosService: todosService,
      );
      controller.onInit();
    });

    test('create todo stores item locally', () async {
      controller.title.value = 'My Task';
      controller.description.value = 'Write tests';

      final created = await controller.createTodo();

      expect(created, isTrue);
      expect(controller.todos.length, 1);
      expect(controller.todoCount, 1);
    });

    test('toggle todo updates completion state', () async {
      controller.title.value = 'Complete me';
      controller.description.value = '';
      await controller.createTodo();
      final todoId = controller.todos.first.id;

      final toggled = await controller.toggleTodo(todoId);

      expect(toggled, isTrue);
      expect(controller.todos.first.isCompleted, isTrue);
    });

    test('clear all removes todos', () async {
      controller.title.value = 'Cleanup';
      controller.description.value = '';
      await controller.createTodo();

      final cleared = await controller.clearAll();

      expect(cleared, isTrue);
      expect(controller.todos, isEmpty);
    });
  });
}
