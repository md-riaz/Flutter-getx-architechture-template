import '../dtos/call_record_dto.dart';

abstract class VoiceLocalDataSource {
  Future<void> cacheHistory(List<CallRecordDto> history);
  List<CallRecordDto> getCachedHistory();
  CallRecordDto? getCachedCall(String callId);
}

class InMemoryVoiceLocalDataSource implements VoiceLocalDataSource {
  List<CallRecordDto> _history = const [];

  @override
  Future<void> cacheHistory(List<CallRecordDto> history) async {
    _history = List.unmodifiable(history);
  }

  @override
  List<CallRecordDto> getCachedHistory() => _history;

  @override
  CallRecordDto? getCachedCall(String callId) {
    for (final record in _history) {
      if (record.id == callId) {
        return record;
      }
    }
    return null;
  }
}
