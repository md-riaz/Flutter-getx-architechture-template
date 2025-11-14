import '../entities/fax_conversation.dart';
import '../repositories/fax_repository.dart';

class FetchFaxConversationsUseCase {
  final FaxRepository _repository;

  const FetchFaxConversationsUseCase(this._repository);

  Future<List<FaxConversation>> call() {
    return _repository.fetchConversations();
  }
}
