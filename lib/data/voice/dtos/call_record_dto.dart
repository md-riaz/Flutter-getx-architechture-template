import '../../../domain/voice/entities/call_record.dart';
import '../../core/data_exception.dart';

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
    late CallDirection dir;
    late CallStatus stat;
    try {
      dir = CallDirection.values.byName(direction);
      stat = CallStatus.values.byName(status);
    } catch (e) {
      throw DataException('Invalid call record data: direction=$direction, status=$status', e);
    }

    return CallRecord(
      id: id,
      contactName: contactName,
      contactHandle: contactHandle,
      startedAt: startedAt,
      duration: duration,
      direction: dir,
      status: stat,
    );
  }
}
