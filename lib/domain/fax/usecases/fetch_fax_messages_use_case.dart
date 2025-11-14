import '../entities/fax_message.dart';
import '../repositories/fax_repository.dart';

class FetchFaxMessagesParams {
  final String conversationId;

  const FetchFaxMessagesParams({required this.conversationId});
}

class FetchFaxMessagesUseCase {
  final FaxRepository _repository;

  const FetchFaxMessagesUseCase(this._repository);

  Future<List<FaxMessage>> call(FetchFaxMessagesParams params) {
    return _repository.fetchMessages(params.conversationId);
  }
}
