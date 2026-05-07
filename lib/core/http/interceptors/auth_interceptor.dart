import 'package:dio/dio.dart';

/// Injects the Authorization Bearer token into every outgoing request.
/// The token is retrieved lazily via the [tokenProvider] callback so it
/// always reflects the most-current session token.
class AuthInterceptor extends Interceptor {
  final String? Function() tokenProvider;

  AuthInterceptor({required this.tokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
