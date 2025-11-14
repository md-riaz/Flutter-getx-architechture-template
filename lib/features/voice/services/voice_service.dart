import 'package:get/get.dart';
import '../../../domain/voice/entities/call_record.dart';
import '../../../domain/voice/usecases/fetch_call_history_use_case.dart';
import '../../../domain/voice/usecases/get_call_details_use_case.dart';

class VoiceService extends GetxService {
  final FetchCallHistoryUseCase _fetchCallHistoryUseCase;
  final GetCallDetailsUseCase _getCallDetailsUseCase;

  final _history = <CallRecord>[].obs;
  final Map<String, CallRecord> _details = {};

  VoiceService({
    required FetchCallHistoryUseCase fetchCallHistoryUseCase,
    required GetCallDetailsUseCase getCallDetailsUseCase,
  })  : _fetchCallHistoryUseCase = fetchCallHistoryUseCase,
        _getCallDetailsUseCase = getCallDetailsUseCase;

  RxList<CallRecord> get history => _history;

  CallRecord? detailFor(String id) {
    return _details[id];
  }

  Future<void> refreshHistory() async {
    final records = await _fetchCallHistoryUseCase();
    _history.assignAll(records);
    for (final record in records) {
      _details[record.id] = record;
    }
  }

  Future<CallRecord?> fetchDetail(String id) async {
    final call = await _getCallDetailsUseCase(GetCallDetailsParams(id));
    if (call != null) {
      _details[id] = call;
      return call;
    }
    return _details[id];
  }
}
