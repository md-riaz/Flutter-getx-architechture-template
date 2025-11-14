class SmsMessage {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isIncoming;

  const SmsMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isIncoming,
  });
}
