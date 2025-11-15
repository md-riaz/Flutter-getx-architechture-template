import 'package:get/get.dart';
import '../features/auth/binding/auth_binding.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/fax/binding/fax_binding.dart';
import '../features/fax/controllers/fax_detail_controller.dart';
import '../features/fax/screens/fax_detail_screen.dart';
import '../features/fax/screens/fax_list_screen.dart';
import '../features/fax/services/fax_service.dart';
import '../features/home/binding/home_binding.dart';
import '../features/home/screens/home_screen.dart';
import '../features/sms/binding/sms_binding.dart';
import '../features/sms/controllers/sms_thread_controller.dart';
import '../features/sms/screens/sms_list_screen.dart';
import '../features/sms/screens/sms_thread_screen.dart';
import '../features/sms/services/sms_service.dart';
import '../features/todos/binding/todos_binding.dart';
import '../features/todos/screens/todos_screen.dart';
import '../features/voice/binding/voice_binding.dart';
import '../features/voice/controllers/call_detail_controller.dart';
import '../features/voice/screens/call_detail_screen.dart';
import '../features/voice/screens/voice_history_screen.dart';
import '../features/voice/services/voice_service.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String todos = '/todos';
  static const String sms = '/sms';
  static const String smsThread = '/sms/thread';
  static const String fax = '/fax';
  static const String faxDetail = '/fax/detail';
  static const String voice = '/voice';
  static const String callDetail = '/voice/detail';

  static final List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: todos,
      page: () => const TodosScreen(),
      binding: TodosBinding(),
    ),
    GetPage(
      name: sms,
      page: () => const SmsListScreen(),
      binding: SmsBinding(),
    ),
    GetPage(
      name: smsThread,
      page: () => const SmsThreadScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<SmsService>()) {
          SmsBinding().dependencies();
        }
        if (!Get.isRegistered<SmsThreadController>()) {
          Get.lazyPut<SmsThreadController>(
            () => SmsThreadController(smsService: Get.find<SmsService>()),
          );
        }
      }),
    ),
    GetPage(
      name: fax,
      page: () => const FaxListScreen(),
      binding: FaxBinding(),
    ),
    GetPage(
      name: faxDetail,
      page: () => const FaxDetailScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<FaxService>()) {
          FaxBinding().dependencies();
        }
        if (!Get.isRegistered<FaxDetailController>()) {
          Get.lazyPut<FaxDetailController>(
            () => FaxDetailController(faxService: Get.find<FaxService>()),
          );
        }
      }),
    ),
    GetPage(
      name: voice,
      page: () => const VoiceHistoryScreen(),
      binding: VoiceBinding(),
    ),
    GetPage(
      name: callDetail,
      page: () => const CallDetailScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<VoiceService>()) {
          VoiceBinding().dependencies();
        }
        if (!Get.isRegistered<CallDetailController>()) {
          Get.lazyPut<CallDetailController>(
            () => CallDetailController(voiceService: Get.find<VoiceService>()),
          );
        }
      }),
    ),
  ];
}
