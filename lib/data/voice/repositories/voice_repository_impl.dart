import '../../../domain/voice/entities/call_record.dart';
import '../../../domain/voice/repositories/voice_repository.dart';
import '../../core/data_exception.dart';
import '../datasources/voice_local_data_source.dart';
import '../datasources/voice_remote_data_source.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceRemoteDataSource _remoteDataSource;
  final VoiceLocalDataSource _localDataSource;

  VoiceRepositoryImpl({
    required VoiceRemoteDataSource remoteDataSource,
    required VoiceLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<CallRecord>> fetchCallHistory() async {
    try {
      final dtos = await _remoteDataSource.fetchCallHistory();
      await _localDataSource.cacheHistory(dtos);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (error) {
      final cached = _localDataSource.getCachedHistory();
      if (cached.isNotEmpty) {
        return cached.map((dto) => dto.toDomain()).toList();
      }
      throw DataException('Failed to load call history', error);
    }
  }

  @override
  Future<CallRecord?> fetchCallDetails(String callId) async {
    try {
      final dto = await _remoteDataSource.fetchCallDetails(callId);
      if (dto != null) {
        return dto.toDomain();
      }
    } catch (error) {
      final cached = _localDataSource.getCachedCall(callId);
      if (cached != null) {
        return cached.toDomain();
      }
      throw DataException('Failed to load call detail', error);
    }
    return _localDataSource.getCachedCall(callId)?.toDomain();
  }
}
