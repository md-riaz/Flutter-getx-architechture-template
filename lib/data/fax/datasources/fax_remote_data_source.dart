import '../dtos/fax_conversation_dto.dart';
import '../dtos/fax_message_dto.dart';

abstract class FaxRemoteDataSource {
  Future<List<FaxConversationDto>> fetchConversations();
  Future<List<FaxMessageDto>> fetchMessages(String conversationId);
}

class FakeFaxRemoteDataSource implements FaxRemoteDataSource {
  FakeFaxRemoteDataSource();

  final List<FaxConversationDto> _data = [
    FaxConversationDto(
      id: 'fax-201',
      company: 'North Plant',
      subject: 'Daily inventory report',
      receivedAt: DateTime(2024, 3, 19, 7, 30),
      pageCount: 5,
      messages: [
        FaxMessageDto(
          id: 'fax-201-1',
          conversationId: 'fax-201',
          sender: 'North Plant',
          content: 'Cover: Inventory summary attached.',
          timestamp: DateTime(2024, 3, 19, 7, 30),
        ),
        FaxMessageDto(
          id: 'fax-201-2',
          conversationId: 'fax-201',
          sender: 'North Plant',
          content: 'Page 1: Raw materials report.',
          timestamp: DateTime(2024, 3, 19, 7, 31),
        ),
      ],
    ),
    FaxConversationDto(
      id: 'fax-202',
      company: 'South Warehouse',
      subject: 'Signed delivery confirmation',
      receivedAt: DateTime(2024, 3, 18, 16, 15),
      pageCount: 2,
      messages: [
        FaxMessageDto(
          id: 'fax-202-1',
          conversationId: 'fax-202',
          sender: 'South Warehouse',
          content: 'Cover: Delivery confirmation for invoice 118.',
          timestamp: DateTime(2024, 3, 18, 16, 15),
        ),
        FaxMessageDto(
          id: 'fax-202-2',
          conversationId: 'fax-202',
          sender: 'South Warehouse',
          content: 'Signature page with receiver acknowledgement.',
          timestamp: DateTime(2024, 3, 18, 16, 16),
        ),
      ],
    ),
  ];

  @override
  Future<List<FaxConversationDto>> fetchConversations() async {
    await Future.delayed(const Duration(milliseconds: 275));
    return _data;
  }

  @override
  Future<List<FaxMessageDto>> fetchMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 275));
    FaxConversationDto? conversation;
    for (final item in _data) {
      if (item.id == conversationId) {
        conversation = item;
        break;
      }
    }
    return conversation?.messages ?? const <FaxMessageDto>[];
  }
}
