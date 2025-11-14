enum CallDirection { incoming, outgoing }

enum CallStatus { completed, missed, rejected }

class CallRecord {
  final String id;
  final String contactName;
  final String contactHandle;
  final DateTime startedAt;
  final Duration duration;
  final CallDirection direction;
  final CallStatus status;

  const CallRecord({
    required this.id,
    required this.contactName,
    required this.contactHandle,
    required this.startedAt,
    required this.duration,
    required this.direction,
    required this.status,
  });
}
