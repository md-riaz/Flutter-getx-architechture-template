import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/voice/entities/call_record.dart';
import '../services/voice_service.dart';

class VoiceController extends BaseController {
  static const tag = 'VoiceController';

  @override
  String get controllerName => tag;

  final VoiceService _voiceService;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  VoiceController({required VoiceService voiceService})
      : _voiceService = voiceService;

  RxList<CallRecord> get history => _voiceService.history;

  @override
  void onReady() {
    super.onReady();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _voiceService.refreshHistory();
    } catch (_) {
      errorMessage.value = 'Unable to load call history';
    } finally {
      isLoading.value = false;
    }
  }
}
