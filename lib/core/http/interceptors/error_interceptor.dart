import 'package:dio/dio.dart';
import '../api_exception.dart';

/// Converts Dio network/HTTP errors into [ApiException] instances so callers
/// only need to handle one exception type.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final message = _messageFor(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: ApiException(message, statusCode: statusCode, data: err.response?.data),
        type: err.type,
      ),
    );
  }

  String _messageFor(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out';
      case DioExceptionType.receiveTimeout:
        return 'Response timed out';
      case DioExceptionType.sendTimeout:
        return 'Request timed out';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
        return err.response?.data?['message'] as String? ??
            'Server error (${err.response?.statusCode})';
      default:
        return err.message ?? 'An unexpected error occurred';
    }
  }
}
