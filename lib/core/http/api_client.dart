import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Shared Dio-based HTTP client used by all modules.
///
/// Register in get_it via [setupServiceLocator] and access through the [Api]
/// facade or by resolving [DioApiClient] from the service locator directly.
///
/// Example:
/// ```dart
/// final client = locator<DioApiClient>();
/// final response = await client.get('/products');
/// ```
class DioApiClient {
  /// The underlying Dio instance. Exposed so data-sources can reuse it
  /// without needing a separate Dio registration.
  late final Dio dio;

  DioApiClient({
    String baseUrl = '',
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
    String? Function()? tokenProvider,
    Dio? dioInstance,
  }) {
    dio = dioInstance ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    dio.interceptors.addAll([
      if (tokenProvider != null)
        AuthInterceptor(tokenProvider: tokenProvider),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  // ──────────────────────────────────────────────
  // HTTP verbs
  // ──────────────────────────────────────────────

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _request<T>(
        () => dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: headers != null ? Options(headers: headers) : null,
        ),
      );

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _request<T>(
        () => dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: headers != null ? Options(headers: headers) : null,
        ),
      );

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _request<T>(
        () => dio.put<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: headers != null ? Options(headers: headers) : null,
        ),
      );

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _request<T>(
        () => dio.patch<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: headers != null ? Options(headers: headers) : null,
        ),
      );

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      _request<T>(
        () => dio.delete<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: headers != null ? Options(headers: headers) : null,
        ),
      );

  // ──────────────────────────────────────────────
  // Internal helpers
  // ──────────────────────────────────────────────

  Future<ApiResponse<T>> _request<T>(
    Future<Response<T>> Function() call,
  ) async {
    try {
      final response = await call();
      return ApiResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 200,
        message: response.statusMessage,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is ApiException) throw inner;
      throw ApiException(
        e.message ?? 'Request failed',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }
}
