import '../../../domain/voice/entities/call_record.dart';

class CallRecordDto {
  final String id;
  final String contactName;
  final String contactHandle;
  final DateTime startedAt;
  final Duration duration;
  final String direction;
  final String status;

  const CallRecordDto({
    required this.id,
    required this.contactName,
    required this.contactHandle,
    required this.startedAt,
    required this.duration,
    required this.direction,
    required this.status,
  });

  CallRecord toDomain() {
    return CallRecord(
      id: id,
      contactName: contactName,
      contactHandle: contactHandle,
      startedAt: startedAt,
      duration: duration,
      direction: CallDirection.values.byName(direction),
      status: CallStatus.values.byName(status),
    );
  }
}
