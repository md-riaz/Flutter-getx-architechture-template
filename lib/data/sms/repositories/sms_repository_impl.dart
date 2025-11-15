import '../../../domain/sms/entities/sms_conversation.dart';
import '../../../domain/sms/entities/sms_message.dart';
import '../../../domain/sms/repositories/sms_repository.dart';
import '../../core/data_exception.dart';
import '../datasources/sms_local_data_source.dart';
import '../datasources/sms_remote_data_source.dart';

class SmsRepositoryImpl implements SmsRepository {
  final SmsRemoteDataSource _remoteDataSource;
  final SmsLocalDataSource _localDataSource;

  SmsRepositoryImpl({
    required SmsRemoteDataSource remoteDataSource,
    required SmsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<SmsConversation>> fetchConversations() async {
    try {
      final dtos = await _remoteDataSource.fetchConversations();
      await _localDataSource.cacheConversations(dtos);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (error) {
      final cached = _localDataSource.getCachedConversations();
      if (cached.isNotEmpty) {
        return cached.map((dto) => dto.toDomain()).toList();
      }
      throw DataException('Failed to load SMS conversations', error);
    }
  }

  @override
  Future<List<SmsMessage>> fetchMessages(String conversationId) async {
    try {
      final dtos = await _remoteDataSource.fetchMessages(conversationId);
      await _localDataSource.cacheMessages(conversationId, dtos);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (error) {
      final cached = _localDataSource.getCachedMessages(conversationId);
      if (cached.isNotEmpty) {
        return cached.map((dto) => dto.toDomain()).toList();
      }
      throw DataException('Failed to load SMS messages', error);
    }
  }
}
