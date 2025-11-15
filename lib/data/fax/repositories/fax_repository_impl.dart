import '../../../domain/fax/entities/fax_conversation.dart';
import '../../../domain/fax/entities/fax_message.dart';
import '../../../domain/fax/repositories/fax_repository.dart';
import '../../core/data_exception.dart';
import '../datasources/fax_local_data_source.dart';
import '../datasources/fax_remote_data_source.dart';

class FaxRepositoryImpl implements FaxRepository {
  final FaxRemoteDataSource _remoteDataSource;
  final FaxLocalDataSource _localDataSource;

  FaxRepositoryImpl({
    required FaxRemoteDataSource remoteDataSource,
    required FaxLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<FaxConversation>> fetchConversations() async {
    try {
      final dtos = await _remoteDataSource.fetchConversations();
      await _localDataSource.cacheConversations(dtos);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (error) {
      final cached = _localDataSource.getCachedConversations();
      if (cached.isNotEmpty) {
        return cached.map((dto) => dto.toDomain()).toList();
      }
      throw DataException('Failed to load fax inbox', error);
    }
  }

  @override
  Future<List<FaxMessage>> fetchMessages(String conversationId) async {
    try {
      final dtos = await _remoteDataSource.fetchMessages(conversationId);
      await _localDataSource.cacheMessages(conversationId, dtos);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (error) {
      final cached = _localDataSource.getCachedMessages(conversationId);
      if (cached.isNotEmpty) {
        return cached.map((dto) => dto.toDomain()).toList();
      }
      throw DataException('Failed to load fax document', error);
    }
  }
}
