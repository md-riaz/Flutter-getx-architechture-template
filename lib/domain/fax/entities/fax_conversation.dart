class FaxConversation {
  final String id;
  final String company;
  final String subject;
  final DateTime receivedAt;
  final int pageCount;

  const FaxConversation({
    required this.id,
    required this.company,
    required this.subject,
    required this.receivedAt,
    required this.pageCount,
  });
}
