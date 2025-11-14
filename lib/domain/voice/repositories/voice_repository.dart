import '../entities/call_record.dart';

abstract class VoiceRepository {
  Future<List<CallRecord>> fetchCallHistory();
  Future<CallRecord?> fetchCallDetails(String callId);
}
