import '../entities/call_record.dart';
import '../repositories/voice_repository.dart';

class GetCallDetailsParams {
  final String id;

  const GetCallDetailsParams(this.id);
}

class GetCallDetailsUseCase {
  final VoiceRepository _repository;

  const GetCallDetailsUseCase(this._repository);

  Future<CallRecord?> call(GetCallDetailsParams params) {
    return _repository.fetchCallDetails(params.id);
  }
}
