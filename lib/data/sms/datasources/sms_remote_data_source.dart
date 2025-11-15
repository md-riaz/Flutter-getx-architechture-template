import '../dtos/sms_conversation_dto.dart';
import '../dtos/sms_message_dto.dart';

abstract class SmsRemoteDataSource {
  Future<List<SmsConversationDto>> fetchConversations();
  Future<List<SmsMessageDto>> fetchMessages(String conversationId);
}

class FakeSmsRemoteDataSource implements SmsRemoteDataSource {
  FakeSmsRemoteDataSource();

  final List<SmsConversationDto> _data = [
    SmsConversationDto(
      id: 'sms-100',
      contactName: 'Logistics HQ',
      contactHandle: '+1 202 555 0144',
      lastMessagePreview: 'Truck 12 arrived at the depot.',
      lastUpdated: DateTime(2024, 3, 20, 10, 15),
      unreadCount: 1,
      messages: [
        SmsMessageDto(
          id: 'sms-100-1',
          conversationId: 'sms-100',
          sender: 'Logistics HQ',
          content: 'Truck 12 departed.',
          timestamp: DateTime(2024, 3, 20, 8, 30),
          isIncoming: true,
        ),
        SmsMessageDto(
          id: 'sms-100-2',
          conversationId: 'sms-100',
          sender: 'Alex Operations',
          content: 'Received. Arrival ETA 10:15.',
          timestamp: DateTime(2024, 3, 20, 9, 45),
          isIncoming: false,
        ),
        SmsMessageDto(
          id: 'sms-100-3',
          conversationId: 'sms-100',
          sender: 'Logistics HQ',
          content: 'Truck 12 arrived at the depot.',
          timestamp: DateTime(2024, 3, 20, 10, 15),
          isIncoming: true,
        ),
      ],
    ),
    SmsConversationDto(
      id: 'sms-101',
      contactName: 'Dock Supervisor',
      contactHandle: '+1 202 555 0119',
      lastMessagePreview: 'Crew is ready for unloading.',
      lastUpdated: DateTime(2024, 3, 19, 22, 5),
      unreadCount: 0,
      messages: [
        SmsMessageDto(
          id: 'sms-101-1',
          conversationId: 'sms-101',
          sender: 'Dock Supervisor',
          content: 'Crew is ready for unloading.',
          timestamp: DateTime(2024, 3, 19, 22, 5),
          isIncoming: true,
        ),
        SmsMessageDto(
          id: 'sms-101-2',
          conversationId: 'sms-101',
          sender: 'Alex Operations',
          content: 'Perfect, start once the trailer docks.',
          timestamp: DateTime(2024, 3, 19, 22, 10),
          isIncoming: false,
        ),
      ],
    ),
  ];

  @override
  Future<List<SmsConversationDto>> fetchConversations() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _data;
  }

  @override
  Future<List<SmsMessageDto>> fetchMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    SmsConversationDto? conversation;
    for (final item in _data) {
      if (item.id == conversationId) {
        conversation = item;
        break;
      }
    }
    return conversation?.messages ?? const <SmsMessageDto>[];
  }
}
