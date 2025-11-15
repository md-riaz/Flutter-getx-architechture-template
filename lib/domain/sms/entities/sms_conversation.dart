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

  SmsConversation copyWith({
    String? id,
    String? contactName,
    String? contactHandle,
    String? lastMessagePreview,
    DateTime? lastUpdated,
    int? unreadCount,
  }) {
    return SmsConversation(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      contactHandle: contactHandle ?? this.contactHandle,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsConversation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          contactName == other.contactName &&
          contactHandle == other.contactHandle &&
          lastMessagePreview == other.lastMessagePreview &&
          lastUpdated == other.lastUpdated &&
          unreadCount == other.unreadCount;

  @override
  int get hashCode => Object.hash(
        id,
        contactName,
        contactHandle,
        lastMessagePreview,
        lastUpdated,
        unreadCount,
      );
}
