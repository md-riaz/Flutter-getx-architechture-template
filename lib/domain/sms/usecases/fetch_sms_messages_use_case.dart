import '../entities/sms_message.dart';
import '../repositories/sms_repository.dart';

class FetchSmsMessagesParams {
  final String conversationId;

  const FetchSmsMessagesParams({required this.conversationId});
}

class FetchSmsMessagesUseCase {
  final SmsRepository _repository;

  const FetchSmsMessagesUseCase(this._repository);

  Future<List<SmsMessage>> call(FetchSmsMessagesParams params) {
    return _repository.fetchMessages(params.conversationId);
  }
}
