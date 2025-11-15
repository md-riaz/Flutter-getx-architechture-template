import '../dtos/call_record_dto.dart';

abstract class VoiceRemoteDataSource {
  Future<List<CallRecordDto>> fetchCallHistory();
  Future<CallRecordDto?> fetchCallDetails(String callId);
}

class FakeVoiceRemoteDataSource implements VoiceRemoteDataSource {
  FakeVoiceRemoteDataSource();

  final List<CallRecordDto> _data = [
    CallRecordDto(
      id: 'call-301',
      contactName: 'Dispatch Central',
      contactHandle: '+1 202 555 0199',
      startedAt: DateTime(2024, 3, 20, 6, 45),
      duration: const Duration(minutes: 6, seconds: 12),
      direction: 'outgoing',
      status: 'completed',
    ),
    CallRecordDto(
      id: 'call-302',
      contactName: 'Maintenance Bay',
      contactHandle: '+1 202 555 0174',
      startedAt: DateTime(2024, 3, 19, 21, 5),
      duration: const Duration(minutes: 2, seconds: 48),
      direction: 'incoming',
      status: 'missed',
    ),
    CallRecordDto(
      id: 'call-303',
      contactName: 'Security Gate',
      contactHandle: '+1 202 555 0156',
      startedAt: DateTime(2024, 3, 19, 18, 30),
      duration: const Duration(minutes: 4, seconds: 2),
      direction: 'incoming',
      status: 'completed',
    ),
  ];

  @override
  Future<List<CallRecordDto>> fetchCallHistory() async {
    await Future.delayed(const Duration(milliseconds: 220));
    return _data;
  }

  @override
  Future<CallRecordDto?> fetchCallDetails(String callId) async {
    await Future.delayed(const Duration(milliseconds: 220));
    for (final record in _data) {
      if (record.id == callId) {
        return record;
      }
    }
    return null;
  }
}
