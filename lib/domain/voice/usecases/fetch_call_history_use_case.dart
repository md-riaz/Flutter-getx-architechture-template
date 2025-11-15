import '../entities/call_record.dart';
import '../repositories/voice_repository.dart';

class FetchCallHistoryUseCase {
  final VoiceRepository _repository;

  const FetchCallHistoryUseCase(this._repository);

  Future<List<CallRecord>> call() {
    return _repository.fetchCallHistory();
  }
}
