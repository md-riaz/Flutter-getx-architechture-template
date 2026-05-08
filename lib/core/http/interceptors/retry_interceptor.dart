import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Duration baseDelay;
  final Duration maxDelay;

  RetryInterceptor({
    required this.dio,
    this.baseDelay = const Duration(milliseconds: 300),
    this.maxDelay = const Duration(seconds: 5),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retries = err.requestOptions.extra['retries'] as int? ?? 0;
    final attempt = err.requestOptions.extra['retry_attempt'] as int? ?? 0;

    if (attempt >= retries || !_isRetryable(err)) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;
    requestOptions.extra['retry_attempt'] = attempt + 1;

    await Future<void>.delayed(_computeDelay(attempt));

    try {
      final response = await dio.fetch(requestOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return true;
    }

    final statusCode = e.response?.statusCode;
    return statusCode != null && statusCode >= 500;
  }

  Duration _computeDelay(int attempt) {
    final multiplier = 1 << attempt;
    final delay = Duration(milliseconds: baseDelay.inMilliseconds * multiplier);
    if (delay > maxDelay) return maxDelay;
    return delay;
  }
}
