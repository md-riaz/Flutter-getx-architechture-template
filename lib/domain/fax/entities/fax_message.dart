class FaxMessage {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final DateTime timestamp;

  const FaxMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}
