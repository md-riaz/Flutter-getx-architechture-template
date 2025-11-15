import '../entities/sms_conversation.dart';
import '../repositories/sms_repository.dart';

class FetchSmsConversationsUseCase {
  final SmsRepository _repository;

  const FetchSmsConversationsUseCase(this._repository);

  Future<List<SmsConversation>> call() {
    return _repository.fetchConversations();
  }
}
