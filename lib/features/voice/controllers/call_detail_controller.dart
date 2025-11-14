import 'package:get/get.dart';
import '../../../base/base_controller.dart';
import '../../../domain/voice/entities/call_record.dart';
import '../services/voice_service.dart';

class CallDetailController extends BaseController {
  static const tag = 'CallDetailController';

  @override
  String get controllerName => tag;

  final VoiceService _voiceService;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final Map<String, CallRecord?> _cache = {};

  CallDetailController({required VoiceService voiceService})
      : _voiceService = voiceService;

  CallRecord? detailFor(String id) {
    return _cache[id] ?? _voiceService.detailFor(id);
  }

  Future<void> ensureLoaded(String id) async {
    if (_cache.containsKey(id)) {
      return;
    }
    await loadDetail(id);
  }

  Future<void> loadDetail(String id) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await _voiceService.fetchDetail(id);
      _cache[id] = result;
    } catch (_) {
      errorMessage.value = 'Unable to load call detail';
    } finally {
      isLoading.value = false;
    }
  }
}
