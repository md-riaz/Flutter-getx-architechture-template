class SmsConversation {
  final String id;
  final String contactName;
  final String contactHandle;
  final String lastMessagePreview;
  final DateTime lastUpdated;
  final int unreadCount;

  const SmsConversation({
    required this.id,
    required this.contactName,
    required this.contactHandle,
    required this.lastMessagePreview,
    required this.lastUpdated,
    required this.unreadCount,
  });
}
